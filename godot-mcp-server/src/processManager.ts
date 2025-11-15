import { spawn, type ChildProcessWithoutNullStreams } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { randomUUID } from "node:crypto";

export type ProcessKind = "editor" | "run";

export interface ProcessLogEntry {
  timestamp: number;
  stream: "stdout" | "stderr";
  message: string;
}

export interface ProcessHandle {
  id: string;
  projectPath: string;
  kind: ProcessKind;
  args: string[];
  startedAt: number;
  status: "running" | "exited" | "error";
  exitCode?: number | null;
  signal?: NodeJS.Signals | null;
  logs: ProcessLogEntry[];
  child: ChildProcessWithoutNullStreams;
}

const MAX_LOG_LINES = 2000;

export class GodotProcessManager {
  private readonly processes = new Map<string, ProcessHandle>();

  constructor(private readonly godotBinary: string) {}

  listProcesses(): ProcessHandle[] {
    return Array.from(this.processes.values());
  }

  launchEditor(projectPath: string, extraArgs: string[] = []): ProcessHandle {
    const normalizedPath = this.normalizeProjectPath(projectPath);
    const args = ["--editor", "--path", normalizedPath, ...extraArgs];
    return this.spawn("editor", normalizedPath, args);
  }

  runProject(
    projectPath: string,
    options: { headless?: boolean; debug?: boolean; extraArgs?: string[] } = {}
  ): ProcessHandle {
    const normalizedPath = this.normalizeProjectPath(projectPath);
    const args = ["--path", normalizedPath];
    if (options.headless) {
      args.unshift("--headless");
    }
    if (options.debug) {
      args.push("--debug");
    }
    if (options.extraArgs?.length) {
      args.push(...options.extraArgs);
    }
    return this.spawn("run", normalizedPath, args);
  }

  stopProcess(id: string): boolean {
    const handle = this.processes.get(id);
    if (!handle) {
      return false;
    }
    if (handle.status === "running") {
      handle.status = "exited";
      handle.child?.kill("SIGTERM");
    }
    this.processes.delete(id);
    return true;
  }

  getProcess(id: string): ProcessHandle | undefined {
    return this.processes.get(id);
  }

  getProcessLogs(id: string, since?: number): ProcessLogEntry[] {
    const handle = this.processes.get(id);
    if (!handle) {
      return [];
    }
    if (!since) {
      return handle.logs;
    }
    return handle.logs.filter((entry) => entry.timestamp >= since);
  }

  private spawn(kind: ProcessKind, projectPath: string, args: string[]): ProcessHandle {
    const id = randomUUID();
    const child = spawn(this.godotBinary, args, {
      cwd: projectPath,
      env: process.env,
      stdio: "pipe",
    });

    const handle: ProcessHandle = {
      id,
      projectPath,
      kind,
      args,
      startedAt: Date.now(),
      status: "running",
      logs: [],
      child: child as ChildProcessWithoutNullStreams,
    } as ProcessHandle;

    const recordLog = (stream: "stdout" | "stderr", data: Buffer): void => {
      const entry = { timestamp: Date.now(), stream, message: data.toString("utf8") };
      handle.logs.push(entry);
      if (handle.logs.length > MAX_LOG_LINES) {
        handle.logs.splice(0, handle.logs.length - MAX_LOG_LINES);
      }
    };

    if (child.stdout) {
      child.stdout.on("data", (chunk) => recordLog("stdout", chunk));
    }
    if (child.stderr) {
      child.stderr.on("data", (chunk) => recordLog("stderr", chunk));
    }

    child.on("error", (error) => {
      recordLog("stderr", Buffer.from(error.message));
      handle.status = "error";
    });

    child.on("close", (code, signal) => {
      handle.status = "exited";
      handle.exitCode = code;
      handle.signal = signal;
      this.processes.delete(id);
    });

    this.processes.set(id, handle);
    return handle;
  }

  private normalizeProjectPath(input: string): string {
    const fullPath = path.resolve(input);
    if (fullPath.endsWith("project.godot")) {
      return path.dirname(fullPath);
    }
    if (!fs.existsSync(fullPath)) {
      throw new Error(`Project path does not exist: ${fullPath}`);
    }
    const stats = fs.statSync(fullPath);
    if (!stats.isDirectory()) {
      throw new Error(`Project path must be a directory or project.godot file: ${fullPath}`);
    }
    return fullPath;
  }
}
