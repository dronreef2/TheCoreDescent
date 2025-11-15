import fs from "node:fs/promises";
import path from "node:path";
import fg from "fast-glob";
import { randomUUID } from "node:crypto";

export interface UidUpdate {
  resourcePath: string;
  oldUid: string;
  newUid: string;
}

export class GodotUidManager {
  constructor(private readonly projectPath: string) {}

  async getUid(resourcePath: string): Promise<string | null> {
    const absolute = this.resolvePath(resourcePath);
    const content = await fs.readFile(absolute, "utf8");
    const match = content.match(/uid="(uid:\/\/.*?)"/);
    return match ? match[1] : null;
  }

  async updateProjectUids(patterns: string[] = ["**/*.tscn", "**/*.tres"]): Promise<{
    updates: UidUpdate[];
  }> {
    const targets = await fg(patterns, {
      cwd: this.projectPath,
      absolute: true,
      ignore: [".godot/**"],
    });

    const updates: UidUpdate[] = [];
    for (const filePath of targets) {
      const content = await fs.readFile(filePath, "utf8");
      const match = content.match(/uid="(uid:\/\/.*?)"/);
      if (!match) {
        continue;
      }
      const oldUid = match[1];
      const newUid = this.generateUid();
      const updatedContent = content.split(oldUid).join(newUid);
      await fs.writeFile(filePath, updatedContent, "utf8");
      updates.push({ resourcePath: filePath, oldUid, newUid });
    }

    if (updates.length) {
      await this.updateReferences(updates);
    }

    return { updates };
  }

  private async updateReferences(updates: UidUpdate[]): Promise<void> {
    const pattern = ["**/*.tscn", "**/*.tres"];
    const files = await fg(pattern, {
      cwd: this.projectPath,
      absolute: true,
      ignore: [".godot/**"],
    });

    for (const file of files) {
      let content = await fs.readFile(file, "utf8");
      let modified = false;
      for (const update of updates) {
        if (content.includes(update.oldUid)) {
          content = content.split(update.oldUid).join(update.newUid);
          modified = true;
        }
      }
      if (modified) {
        await fs.writeFile(file, content, "utf8");
      }
    }
  }

  private resolvePath(resourcePath: string): string {
    if (resourcePath.startsWith("res://")) {
      return path.join(this.projectPath, resourcePath.replace("res://", ""));
    }
    return path.isAbsolute(resourcePath) ? resourcePath : path.join(this.projectPath, resourcePath);
  }

  private generateUid(): string {
    return `uid://${randomUUID().replace(/-/g, "").slice(0, 22)}`;
  }
}
