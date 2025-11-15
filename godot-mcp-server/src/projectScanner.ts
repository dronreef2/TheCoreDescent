import fs from "node:fs/promises";
import path from "node:path";
import fg from "fast-glob";
import ini from "ini";

export interface ProjectDescriptor {
  projectPath: string;
  projectFile: string;
  name: string;
  lastModified: number;
}

export interface ProjectAnalysis {
  descriptor: ProjectDescriptor;
  config: Record<string, unknown>;
  defaultScene?: string;
  stats: {
    scenes: number;
    scripts: number;
    resources: number;
  };
  scenes: string[];
  scripts: string[];
  resources: string[];
}

export async function findGodotProjects(
  rootDir: string,
  depth = 3
): Promise<ProjectDescriptor[]> {
  const pattern = path.posix.join(path.resolve(rootDir).replace(/\\/g, "/"), "**/project.godot");
  const matches = await fg(pattern, { caseSensitiveMatch: false, deep: depth, onlyFiles: true });
  const descriptors: ProjectDescriptor[] = [];

  for (const match of matches) {
    const projectFile = path.resolve(match);
    const stats = await fs.stat(projectFile);
    const descriptor: ProjectDescriptor = {
      projectPath: path.dirname(projectFile),
      projectFile,
      name: path.basename(path.dirname(projectFile)),
      lastModified: stats.mtimeMs,
    };
    descriptors.push(descriptor);
  }

  return descriptors;
}

export async function analyzeProject(projectPath: string): Promise<ProjectAnalysis> {
  const projectFile = projectPath.endsWith("project.godot")
    ? projectPath
    : path.join(projectPath, "project.godot");

  const descriptor: ProjectDescriptor = {
    projectPath: path.dirname(projectFile),
    projectFile,
    name: path.basename(path.dirname(projectFile)),
    lastModified: (await fs.stat(projectFile)).mtimeMs,
  };

  const raw = await fs.readFile(projectFile, "utf8");
  const config = ini.parse(raw);
  const defaultScene = config.application?.run_scene;

  const [scenes, scripts, resources] = await Promise.all([
    fg(["**/*.tscn"], { cwd: descriptor.projectPath, ignore: [".godot/**", "addons/**"] }),
    fg(["**/*.gd"], { cwd: descriptor.projectPath, ignore: [".godot/**", "addons/**"] }),
    fg(["**/*.{png,jpg,jpeg,webp,svg,tscn,tres,mesh,glb}"], {
      cwd: descriptor.projectPath,
      ignore: [".godot/**", "addons/**"],
    }),
  ]);

  return {
    descriptor,
    config,
    defaultScene,
    stats: {
      scenes: scenes.length,
      scripts: scripts.length,
      resources: resources.length,
    },
    scenes,
    scripts,
    resources,
  };
}
