import path from "node:path";
import { fileURLToPath } from "node:url";
import { readFileSync } from "node:fs";
import type { ContentBlock } from "@modelcontextprotocol/sdk/types.js";

export function resolvePath(inputPath: string, base: string = process.cwd()): string {
  if (!inputPath) {
    return base;
  }
  if (inputPath.startsWith("file://")) {
    return fileURLToPath(inputPath);
  }
  return path.isAbsolute(inputPath) ? inputPath : path.resolve(base, inputPath);
}

export function textContent(text: string): ContentBlock[] {
  return [{ type: "text", text }];
}

export function readPackageVersion(): string {
  const modulePath = fileURLToPath(import.meta.url);
  const pkgPath = path.resolve(path.dirname(modulePath), "..", "package.json");
  const pkg = JSON.parse(readFileSync(pkgPath, "utf8"));
  return pkg.version ?? "0.0.0";
}

export function formatDuration(ms: number): string {
  const seconds = Math.floor(ms / 1000);
  const minutes = Math.floor(seconds / 60);
  const remainingSeconds = seconds % 60;
  if (minutes === 0) {
    return `${remainingSeconds}s`;
  }
  return `${minutes}m ${remainingSeconds}s`;
}
