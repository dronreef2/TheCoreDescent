#!/bin/bash
echo "🧪 Testando Godot MCP Server..."
echo ""

# 1. Verificar versão do Godot
echo "1️⃣ Verificando versão do Godot..."
echo '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"get_godot_version","arguments":{}}}' | node godot-mcp-server/build/index.js 2>&1 | tail -5

echo ""
echo "2️⃣ Listando projetos..."
echo '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"list_projects","arguments":{"rootPath":"/workspaces/TheCoreDescent/projeto_godot"}}}' | node godot-mcp-server/build/index.js 2>&1 | tail -5

echo ""
echo "3️⃣ Obtendo informações do projeto..."
echo '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"get_project_info","arguments":{"projectPath":"/workspaces/TheCoreDescent/projeto_godot"}}}' | node godot-mcp-server/build/index.js 2>&1 | tail -10

echo ""
echo "✅ Teste concluído!"
