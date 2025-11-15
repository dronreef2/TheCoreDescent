import fs from "node:fs";
import path from "node:path";

export interface ServerConfig {
  godotBinary: string;
  defaultProjectPath?: string;
  projectsRoot: string;
  maxSearchDepth: number;
  defaultSceneDirectory: string;
  allowEditorLaunch: boolean;
}

const DEFAULTS = {
  godotBinary: process.env.GODOT_BIN ?? "godot4",
  defaultProjectPath: process.env.GODOT_PROJECT_PATH,
  projectsRoot:
    process.env.GODOT_PROJECTS_ROOT ?? path.resolve(process.cwd(), "..", "projeto_godot"),
  maxSearchDepth: Number(process.env.GODOT_SEARCH_DEPTH ?? 3),
  defaultSceneDirectory: process.env.GODOT_SCENE_DIR ?? "scenes",
  allowEditorLaunch: process.env.GODOT_ALLOW_EDITOR !== "false",
};

export function loadConfig(): ServerConfig {
  const configPath = process.env.GODOT_MCP_CONFIG;
  if (configPath && fs.existsSync(configPath)) {
    const userConfig = JSON.parse(fs.readFileSync(configPath, "utf8"));
    return {
      godotBinary: userConfig.godotBinary ?? DEFAULTS.godotBinary,
      defaultProjectPath: userConfig.defaultProjectPath ?? DEFAULTS.defaultProjectPath,
      projectsRoot: userConfig.projectsRoot ?? DEFAULTS.projectsRoot,
      maxSearchDepth: userConfig.maxSearchDepth ?? DEFAULTS.maxSearchDepth,
      defaultSceneDirectory:
        userConfig.defaultSceneDirectory ?? DEFAULTS.defaultSceneDirectory,
      allowEditorLaunch: userConfig.allowEditorLaunch ?? DEFAULTS.allowEditorLaunch,
    } satisfies ServerConfig;
  }

  return DEFAULTS;
}
