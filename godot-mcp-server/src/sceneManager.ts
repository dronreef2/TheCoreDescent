import fs from "node:fs/promises";
import path from "node:path";
import { randomUUID } from "node:crypto";
import { ensureDir } from "fs-extra";

export type PrimitiveProperty = string | number | boolean;

export type ScenePropertyValue =
  | PrimitiveProperty
  | { kind: "vector2"; x: number; y: number }
  | { kind: "vector3"; x: number; y: number; z: number }
  | { kind: "color"; r: number; g: number; b: number; a?: number };

export interface CreateSceneOptions {
  scenePath: string;
  rootType: string;
  rootName?: string;
  uid?: string;
}

export interface AddNodeOptions {
  scenePath: string;
  nodeName: string;
  nodeType: string;
  parent?: string;
  properties?: Record<string, ScenePropertyValue>;
}

export interface SpriteOptions {
  scenePath: string;
  nodeName: string;
  texturePath: string;
}

export interface MeshExportOptions {
  scenePath: string;
  outputPath: string;
}

export interface SceneVariantOptions {
  scenePath: string;
  variantPath: string;
  rootName?: string;
  uid?: string;
}

export class SceneManager {
  constructor(private readonly projectRoot: string, private readonly defaultSceneDir: string) {}

  async createScene(options: CreateSceneOptions): Promise<{ scenePath: string; uid: string }> {
    const targetPath = this.resolveScenePath(options.scenePath);
    await ensureDir(path.dirname(targetPath));
    const uid = options.uid ?? this.generateUid();
    const rootName = options.rootName ?? options.rootType;

    const header = `[gd_scene load_steps=1 format=3 uid="${uid}"]`;
    const nodeBlock = [`[node name="${rootName}" type="${options.rootType}"]`, ""]; // trailing newline

    await fs.writeFile(targetPath, `${header}\n\n${nodeBlock.join("\n")}`);
    return { scenePath: targetPath, uid };
  }

  async addNode(options: AddNodeOptions): Promise<void> {
    const scenePath = this.resolveScenePath(options.scenePath);
    await this.assertSceneExists(scenePath);

    const blockLines = [
      `[node name="${options.nodeName}" type="${options.nodeType}"${options.parent ? ` parent="${options.parent}"` : ""}]`,
    ];
    if (options.properties) {
      for (const [key, value] of Object.entries(options.properties)) {
        blockLines.push(`${key} = ${this.formatProperty(value)}`);
      }
    }
    blockLines.push("\n");

    await fs.appendFile(scenePath, `\n${blockLines.join("\n")}`);
  }

  async loadSprite(options: SpriteOptions): Promise<void> {
    const scenePath = this.resolveScenePath(options.scenePath);
    await this.assertSceneExists(scenePath);

    const content = await fs.readFile(scenePath, "utf8");
    const nodeRegex = new RegExp(
      `(\[node[^\]]*name="${this.escapeRegExp(options.nodeName)}"[^\]]*\][\\s\\S]*?)(?=\n\[node|$)`,
      "g"
    );
    const match = nodeRegex.exec(content);
    if (!match) {
      throw new Error(`Node ${options.nodeName} not found in scene ${scenePath}`);
    }

    const existingBlock = match[1];
    const textureLine = `texture = preload("${options.texturePath}")`;
    let updatedBlock: string;
    if (existingBlock.includes("texture =")) {
      updatedBlock = existingBlock.replace(/texture\s*=.*?(?=\n[A-Za-z_]|$)/s, `${textureLine}`);
    } else {
      updatedBlock = `${existingBlock.trimEnd()}\n${textureLine}\n`;
    }

    const newContent = `${content.slice(0, match.index)}${updatedBlock}${content.slice(
      match.index + existingBlock.length
    )}`;
    await fs.writeFile(scenePath, newContent);
  }

  async exportMeshLibrary(options: MeshExportOptions): Promise<{ outputPath: string; entries: number }> {
    const scenePath = this.resolveScenePath(options.scenePath);
    await this.assertSceneExists(scenePath);
    const content = await fs.readFile(scenePath, "utf8");
    const nodes = this.parseNodeBlocks(content);
    const meshEntries = nodes
      .map((node) => {
        const meshMatch = node.body.match(/\nmesh\s*=\s*(.*)/);
        if (!meshMatch) {
          return null;
        }
        return { name: node.name, meshExpression: meshMatch[1].trim() };
      })
      .filter((item): item is { name: string; meshExpression: string } => Boolean(item));

    if (!meshEntries.length) {
      throw new Error(`No MeshInstance nodes found in ${scenePath}`);
    }

    const outputPath = this.resolveScenePath(options.outputPath);
    await ensureDir(path.dirname(outputPath));
    const lines = [`[gd_resource type="MeshLibrary" load_steps=1 format=3]`, "", "[resource]"];
    meshEntries.forEach((entry, index) => {
      lines.push(`item/${index}/name = "${entry.name}"`);
      lines.push(`item/${index}/mesh = ${entry.meshExpression}`);
      lines.push("");
    });
    await fs.writeFile(outputPath, `${lines.join("\n")}\n`);
    return { outputPath, entries: meshEntries.length };
  }

  async saveSceneVariant(options: SceneVariantOptions): Promise<{ variantPath: string; uid: string }> {
    const originalPath = this.resolveScenePath(options.scenePath);
    await this.assertSceneExists(originalPath);
    const variantPath = this.resolveScenePath(options.variantPath);
    await ensureDir(path.dirname(variantPath));

    let content = await fs.readFile(originalPath, "utf8");
    const uid = options.uid ?? this.generateUid();
    content = content.replace(/uid="uid:\/\/[^"]+"/, `uid="${uid}"`);

    if (options.rootName) {
      content = content.replace(
        /(\[node\s+name=")([^"]+)("\s+type=.*?\])/,
        `$1${options.rootName}$3`
      );
    }

    await fs.writeFile(variantPath, content);
    return { variantPath, uid };
  }

  private resolveScenePath(scenePath: string): string {
    if (scenePath.startsWith("res://")) {
      const relative = scenePath.replace("res://", "");
      return path.join(this.projectRoot, relative);
    }
    const normalized = scenePath;
    if (path.isAbsolute(normalized)) {
      return normalized;
    }
    return path.join(this.defaultSceneDir, normalized);
  }

  private async assertSceneExists(scenePath: string): Promise<void> {
    try {
      await fs.access(scenePath);
    } catch (error) {
      throw new Error(`Scene file not found: ${scenePath}`);
    }
  }

  private escapeRegExp(value: string): string {
    return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  }

  private parseNodeBlocks(content: string): Array<{ name: string; body: string }> {
    const regex = /\[node[^\]]*name="([^"]+)"[^\]]*\][\s\S]*?(?=\n\[node|$)/g;
    const blocks: Array<{ name: string; body: string }> = [];
    let match: RegExpExecArray | null;
    while ((match = regex.exec(content)) !== null) {
      blocks.push({ name: match[1], body: match[0] });
    }
    return blocks;
  }

  private formatProperty(value: ScenePropertyValue): string {
    if (typeof value === "string") {
      const escaped = value.replace(/"/g, '\\"');
      return `"${escaped}"`;
    }
    if (typeof value === "number" || typeof value === "boolean") {
      return `${value}`;
    }
    switch (value.kind) {
      case "vector2":
        return `Vector2(${value.x}, ${value.y})`;
      case "vector3":
        return `Vector3(${value.x}, ${value.y}, ${value.z})`;
      case "color":
        return `Color(${value.r}, ${value.g}, ${value.b}, ${value.a ?? 1})`;
      default:
        return "null";
    }
  }

  private generateUid(): string {
    return `uid://${randomUUID().replace(/-/g, "").slice(0, 22)}`;
  }
}
