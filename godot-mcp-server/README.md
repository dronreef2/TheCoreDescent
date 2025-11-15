# Godot MCP Server

Model Context Protocol (MCP) server that automates common Godot Engine workflows for The Core Descent. It can launch the editor, run projects, capture logs, manage scenes, and update resource UIDs so AI copilots can interact with a real Godot project.

## Features

- Launch or stop Godot editor/game processes in debug or headless mode
- Stream captured stdout/stderr logs back to the assistant
- Discover projects and inspect `project.godot` metadata
- Create scenes, append nodes, wire Sprite2D textures, and export MeshLibrary assets
- Save scene variants with regenerated UIDs for Godot 4.4+
- Refresh resource UIDs across a project and fix references in dependent scenes

## Requirements

- Node.js 18+
- Godot 4.x installed locally (exposed via the `GODOT_BIN` env variable or on the `PATH`)
- Access to the `projeto_godot` directory within this repository

## Installation

```bash
cd godot-mcp-server
npm install
npm run build
```

Start the server over stdio (suitable for tools like Cline/Cursor):

```bash
node ./build/index.js
```

## Configuration

Environment variables:

| Variable | Default | Description |
| --- | --- | --- |
| `GODOT_BIN` | `godot4` | Path to the Godot binary |
| `GODOT_PROJECT_PATH` | `projeto_godot` root | Default project when none is supplied |
| `GODOT_PROJECTS_ROOT` | `../projeto_godot` | Root used for project discovery |
| `GODOT_SCENE_DIR` | `scenes` | Relative path where new scenes are stored |
| `GODOT_SEARCH_DEPTH` | `3` | Depth when scanning for `project.godot` |
| `GODOT_ALLOW_EDITOR` | `true` | Set to `false` to block `launch_editor` |
| `GODOT_MCP_CONFIG` | — | Optional JSON file containing the same keys |

Example config file (`godot-mcp.json`):

```json
{
  "godotBinary": "/usr/local/bin/godot4",
  "projectsRoot": "/workspaces/TheCoreDescent/projeto_godot",
  "defaultSceneDirectory": "scenes"
}
```

Run with:

```bash
GODOT_MCP_CONFIG=/path/to/godot-mcp.json node ./build/index.js
```

## Available Tools

| Tool | Description |
| --- | --- |
| `launch_editor` | Opens the Godot editor for a project (respects `GODOT_ALLOW_EDITOR`) |
| `run_project` | Runs a project in debug or headless mode and captures logs |
| `get_debug_output` | Returns stdout/stderr since the last call |
| `stop_project` | Stops a tracked Godot process |
| `get_godot_version` | Reports the installed Godot version |
| `list_projects` | Scans for `project.godot` files under a root directory |
| `get_project_info` | Parses `project.godot`, scenes, scripts, and resources |
| `create_scene` | Generates a new `.tscn` with a chosen root node |
| `add_node` | Appends a node block with typed properties |
| `load_sprite` | Assigns a texture to a Sprite2D node |
| `export_mesh_library` | Collects MeshInstance nodes into a MeshLibrary resource |
| `save_scene` | Copies scenes into variants with optional UID regeneration |
| `get_uid` | Reads the UID from a `.tscn`/`.tres` resource |
| `update_project_uids` | Rewrites UIDs project-wide and updates references |
| `list_processes` | Lists any editor/runtime processes the server started |

## MCP Client Example (Cline)

```json
{
  "mcpServers": {
    "godot": {
      "command": "node",
      "args": ["/absolute/path/to/godot-mcp-server/build/index.js"],
      "env": {
        "GODOT_BIN": "/Applications/Godot.app/Contents/MacOS/Godot",
        "GODOT_PROJECT_PATH": "/workspaces/TheCoreDescent/projeto_godot"
      }
    }
  }
}
```

Once connected, invoke tools such as:

```
@mcp godot run_project {"headless": true}
@mcp godot get_debug_output {"processId": "<uuid>"}
@mcp godot create_scene {"scenePath": "levels/NewLevel.tscn", "rootType": "Node3D"}
```

## Development Scripts

- `npm run dev` – Rebuild on change with `tsx watch`
- `npm run lint` – Type-check the project
- `npm run build` – Emit `build/` artifacts for distribution
