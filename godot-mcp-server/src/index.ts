import { execFile } from "node:child_process";
import path from "node:path";
import { promisify } from "node:util";
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

import { loadConfig } from "./config.js";
import { GodotProcessManager, type ProcessHandle } from "./processManager.js";
import { SceneManager, type ScenePropertyValue } from "./sceneManager.js";
import { GodotUidManager } from "./uidManager.js";
import { analyzeProject, findGodotProjects } from "./projectScanner.js";
import { formatDuration, readPackageVersion, resolvePath, textContent } from "./utils.js";

const execFileAsync = promisify(execFile);
const config = loadConfig();
const packageVersion = readPackageVersion();
const projectsRoot = path.resolve(config.projectsRoot);
const defaultProjectPath = config.defaultProjectPath
  ? path.resolve(config.defaultProjectPath)
  : projectsRoot;
const defaultSceneDir = path.isAbsolute(config.defaultSceneDirectory)
  ? config.defaultSceneDirectory
  : path.join(defaultProjectPath, config.defaultSceneDirectory);

const server = new McpServer(
  { name: "godot-mcp-core-descent", version: packageVersion },
  {
    instructions: "MCP server for launching Godot, running projects, and editing scenes.",
    capabilities: { tools: {} },
  }
);

const processManager = new GodotProcessManager(config.godotBinary);
const sceneManager = new SceneManager(defaultProjectPath, defaultSceneDir);

const propertySchema: z.ZodType<ScenePropertyValue> = z.union([
  z.string(),
  z.number(),
  z.boolean(),
  z.object({ kind: z.literal("vector2"), x: z.number(), y: z.number() }),
  z.object({ kind: z.literal("vector3"), x: z.number(), y: z.number(), z: z.number() }),
  z.object({
    kind: z.literal("color"),
    r: z.number(),
    g: z.number(),
    b: z.number(),
    a: z.number().optional(),
  }),
]);

const launchEditorSchema = z.object({
  projectPath: z.string().optional(),
  extraArgs: z.array(z.string()).default([]),
});

const runProjectSchema = z.object({
  projectPath: z.string().optional(),
  headless: z.boolean().default(false),
  debug: z.boolean().default(true),
  extraArgs: z.array(z.string()).default([]),
});

const debugOutputSchema = z.object({
  processId: z.string(),
  since: z.number().optional(),
});

const stopProcessSchema = z.object({ processId: z.string() });

const listProjectsSchema = z.object({
  root: z.string().optional(),
  depth: z.number().min(1).max(8).optional(),
});

const projectInfoSchema = z.object({ projectPath: z.string().optional() });

const createSceneSchema = z.object({
  scenePath: z.string(),
  rootType: z.string(),
  rootName: z.string().optional(),
  uid: z.string().optional(),
});

const addNodeSchema = z.object({
  scenePath: z.string(),
  nodeName: z.string(),
  nodeType: z.string(),
  parent: z.string().optional(),
  properties: z.record(propertySchema).optional(),
});

const loadSpriteSchema = z.object({
  scenePath: z.string(),
  nodeName: z.string(),
  texturePath: z.string(),
});

const meshExportSchema = z.object({
  scenePath: z.string(),
  outputPath: z.string(),
});

const saveSceneSchema = z.object({
  scenePath: z.string(),
  variantPath: z.string(),
  rootName: z.string().optional(),
  uid: z.string().optional(),
});

const getUidSchema = z.object({ projectPath: z.string().optional(), resourcePath: z.string() });

const updateUidSchema = z.object({
  projectPath: z.string().optional(),
  patterns: z.array(z.string()).optional(),
});

type LaunchEditorArgs = z.input<typeof launchEditorSchema>;
type RunProjectArgs = z.input<typeof runProjectSchema>;
type DebugOutputArgs = z.input<typeof debugOutputSchema>;
type StopProcessArgs = z.input<typeof stopProcessSchema>;
type ListProjectsArgs = z.input<typeof listProjectsSchema>;
type ProjectInfoArgs = z.input<typeof projectInfoSchema>;
type CreateSceneArgs = z.input<typeof createSceneSchema>;
type AddNodeArgs = z.input<typeof addNodeSchema>;
type LoadSpriteArgs = z.input<typeof loadSpriteSchema>;
type MeshExportArgs = z.input<typeof meshExportSchema>;
type SaveSceneArgs = z.input<typeof saveSceneSchema>;
type GetUidArgs = z.input<typeof getUidSchema>;
type UpdateUidArgs = z.input<typeof updateUidSchema>;

function requireProjectPath(input?: string): string {
  if (input) {
    return resolvePath(input, projectsRoot);
  }
  if (defaultProjectPath) {
    return defaultProjectPath;
  }
  throw new Error("A project path is required but none was provided.");
}

function summarizeProcess(handle: ProcessHandle) {
  const { child: _child, logs, ...rest } = handle;
  return { ...rest, logLines: logs.length };
}

server.registerTool(
  "launch_editor",
  {
    title: "Launch Godot Editor",
    description: "Opens the Godot editor for a given project.",
    inputSchema: launchEditorSchema,
  },
  async (input: LaunchEditorArgs) => {
    const { projectPath, extraArgs } = launchEditorSchema.parse(input);
    if (!config.allowEditorLaunch) {
      return {
        content: textContent("Editor launch is disabled via configuration."),
        isError: true,
      };
    }
    const targetPath = requireProjectPath(projectPath);
    const handle = processManager.launchEditor(targetPath, extraArgs);
    return {
      content: textContent(`Editor launched for ${targetPath} (process ${handle.id}).`),
      structuredContent: { process: summarizeProcess(handle) },
    };
  }
);

server.registerTool(
  "run_project",
  {
    title: "Run Godot Project",
    description: "Runs a Godot project in debug or headless mode.",
    inputSchema: runProjectSchema,
  },
  async (input: RunProjectArgs) => {
    const { projectPath, headless, debug, extraArgs } = runProjectSchema.parse(input);
    const targetPath = requireProjectPath(projectPath);
    const handle = processManager.runProject(targetPath, { headless, debug, extraArgs });
    return {
      content: textContent(
        `Project started (${handle.id}) at ${targetPath} with args ${handle.args.join(" ")}`
      ),
      structuredContent: { process: summarizeProcess(handle) },
    };
  }
);

server.registerTool(
  "get_debug_output",
  {
    title: "Fetch Godot Logs",
    description: "Returns captured stdout/stderr from a managed Godot process.",
    inputSchema: debugOutputSchema,
  },
  async (input: DebugOutputArgs) => {
    const { processId, since } = debugOutputSchema.parse(input);
    const logs = processManager.getProcessLogs(processId, since);
    if (!logs.length) {
      return {
        content: textContent(`No logs recorded for process ${processId}.`),
      };
    }
    const formatted = logs
      .map((entry) => `${new Date(entry.timestamp).toISOString()} [${entry.stream}] ${entry.message}`)
      .join("");
    return {
      content: textContent(formatted),
      structuredContent: { logs },
    };
  }
);

server.registerTool(
  "stop_project",
  {
    title: "Stop Godot Process",
    description: "Stops a running Godot process started by this server.",
    inputSchema: stopProcessSchema,
  },
  async (input: StopProcessArgs) => {
    const { processId } = stopProcessSchema.parse(input);
    const stopped = processManager.stopProcess(processId);
    return stopped
      ? { content: textContent(`Process ${processId} stopped.`), structuredContent: { processId } }
      : {
          content: textContent(`Process ${processId} not found.`),
          structuredContent: { processId },
          isError: true,
        };
  }
);

server.registerTool(
  "get_godot_version",
  {
    title: "Godot Version",
    description: "Returns the installed Godot version string.",
  },
  async () => {
    const { stdout } = await execFileAsync(config.godotBinary, ["--version"]);
    const version = stdout.trim();
    return { content: textContent(version), structuredContent: { version } };
  }
);

server.registerTool(
  "list_projects",
  {
    title: "List Godot Projects",
    description: "Finds Godot projects within a directory tree.",
    inputSchema: listProjectsSchema,
  },
  async (input: ListProjectsArgs) => {
    const { root, depth } = listProjectsSchema.parse(input);
    const searchRoot = root ? resolvePath(root, projectsRoot) : projectsRoot;
    const projects = await findGodotProjects(searchRoot, depth ?? config.maxSearchDepth);
    if (!projects.length) {
      return { content: textContent(`No projects found under ${searchRoot}.`) };
    }
    const lines = projects
      .map(
        (p) =>
          `- ${p.name} (${p.projectPath}) - updated ${new Date(p.lastModified).toISOString()}`
      )
      .join("\n");
    return {
      content: textContent(lines),
      structuredContent: { projects },
    };
  }
);

server.registerTool(
  "get_project_info",
  {
    title: "Analyze Godot Project",
    description: "Reads project.godot and summarizes scenes/scripts/resources.",
    inputSchema: projectInfoSchema,
  },
  async (input: ProjectInfoArgs) => {
    const { projectPath } = projectInfoSchema.parse(input);
    const targetPath = requireProjectPath(projectPath);
    const analysis = await analyzeProject(targetPath);
    const summary = [
      `Project: ${analysis.descriptor.name}`,
      `Scenes: ${analysis.stats.scenes}, Scripts: ${analysis.stats.scripts}, Resources: ${analysis.stats.resources}`,
      `Default Scene: ${analysis.defaultScene ?? "(none)"}`,
    ].join("\n");
    return { content: textContent(summary), structuredContent: { analysis } };
  }
);

server.registerTool(
  "create_scene",
  {
    title: "Create Scene",
    description: "Creates a new .tscn with a root node.",
    inputSchema: createSceneSchema,
  },
  async (input: CreateSceneArgs) => {
    const { scenePath, rootType, rootName, uid } = createSceneSchema.parse(input);
    const result = await sceneManager.createScene({ scenePath, rootType, rootName, uid });
    return {
      content: textContent(`Scene created at ${result.scenePath} (uid ${result.uid}).`),
      structuredContent: result,
    };
  }
);

server.registerTool(
  "add_node",
  {
    title: "Add Node",
    description: "Injects a new node block into a scene file.",
    inputSchema: addNodeSchema,
  },
  async (input: AddNodeArgs) => {
    const { scenePath, nodeName, nodeType, parent, properties } = addNodeSchema.parse(input);
    await sceneManager.addNode({ scenePath, nodeName, nodeType, parent, properties });
    return {
      content: textContent(`Node ${nodeName} added to ${scenePath}.`),
      structuredContent: { scenePath, nodeName, nodeType },
    };
  }
);

server.registerTool(
  "load_sprite",
  {
    title: "Load Sprite",
    description: "Assigns a texture to an existing Sprite2D node.",
    inputSchema: loadSpriteSchema,
  },
  async (input: LoadSpriteArgs) => {
    const { scenePath, nodeName, texturePath } = loadSpriteSchema.parse(input);
    await sceneManager.loadSprite({ scenePath, nodeName, texturePath });
    return {
      content: textContent(`Texture ${texturePath} applied to ${nodeName}.`),
      structuredContent: { scenePath, nodeName, texturePath },
    };
  }
);

server.registerTool(
  "export_mesh_library",
  {
    title: "Export MeshLibrary",
    description: "Scans a scene for MeshInstance nodes and exports a MeshLibrary resource.",
    inputSchema: meshExportSchema,
  },
  async (input: MeshExportArgs) => {
    const { scenePath, outputPath } = meshExportSchema.parse(input);
    const result = await sceneManager.exportMeshLibrary({ scenePath, outputPath });
    return {
      content: textContent(`MeshLibrary created at ${result.outputPath} with ${result.entries} entries.`),
      structuredContent: result,
    };
  }
);

server.registerTool(
  "save_scene",
  {
    title: "Save Scene Variant",
    description: "Copies a scene to a new path, optionally regenerating its UID.",
    inputSchema: saveSceneSchema,
  },
  async (input: SaveSceneArgs) => {
    const { scenePath, variantPath, rootName, uid } = saveSceneSchema.parse(input);
    const result = await sceneManager.saveSceneVariant({ scenePath, variantPath, rootName, uid });
    return {
      content: textContent(`Scene saved to ${result.variantPath} (uid ${result.uid}).`),
      structuredContent: result,
    };
  }
);

server.registerTool(
  "get_uid",
  {
    title: "Get Resource UID",
    description: "Reads the UID declared in a .tscn/.tres file.",
    inputSchema: getUidSchema,
  },
  async (input: GetUidArgs) => {
    const { projectPath, resourcePath } = getUidSchema.parse(input);
    const project = requireProjectPath(projectPath);
    const uidManager = new GodotUidManager(project);
    const uid = await uidManager.getUid(resourcePath);
    if (!uid) {
      return { content: textContent(`No UID found in ${resourcePath}`), isError: true };
    }
    return { content: textContent(uid), structuredContent: { uid } };
  }
);

server.registerTool(
  "update_project_uids",
  {
    title: "Reseed UIDs",
    description: "Generates fresh UIDs for project resources and updates references.",
    inputSchema: updateUidSchema,
  },
  async (input: UpdateUidArgs) => {
    const { projectPath, patterns } = updateUidSchema.parse(input);
    const project = requireProjectPath(projectPath);
    const uidManager = new GodotUidManager(project);
    const result = await uidManager.updateProjectUids(patterns);
    const summary = result.updates
      .map((item) => `${item.resourcePath}: ${item.oldUid} -> ${item.newUid}`)
      .join("\n");
    const content = summary || "No resources contained UID metadata.";
    return {
      content: textContent(content),
      structuredContent: result,
    };
  }
);

server.registerTool(
  "list_processes",
  {
    title: "List Managed Processes",
    description: "Returns metadata for Godot processes launched by this server.",
  },
  async (_args: Record<string, unknown>) => {
    const processes = processManager.listProcesses();
    if (!processes.length) {
      return { content: textContent("No active processes.") };
    }
    const summary = processes
      .map((proc) => {
        const duration = formatDuration(Date.now() - proc.startedAt);
        return `${proc.id} (${proc.kind}) running ${duration} with args ${proc.args.join(" ")}`;
      })
      .join("\n");
    const structured = processes.map((proc) => summarizeProcess(proc));
    return {
      content: textContent(summary),
      structuredContent: { processes: structured },
    };
  }
);

async function main(): Promise<void> {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((error) => {
  console.error("Godot MCP server failed:", error);
  process.exit(1);
});
