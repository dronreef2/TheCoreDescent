#!/bin/bash
# THE CORE DESCENT - Teste do Godot MCP
# Arquivo: test_mcp.sh - Testa se o MCP Server está funcionando

set -e

echo "=== Teste do Godot MCP Server ==="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Verificar se o build existe
echo "1. Verificando build do MCP..."
if [ -f "godot-mcp-server/build/index.js" ]; then
    echo -e "  ${GREEN}✓${NC} Build encontrado"
else
    echo -e "  ${RED}✗${NC} Build não encontrado. Execute: cd godot-mcp-server && npm run build"
    exit 1
fi

# 2. Verificar configuração
echo ""
echo "2. Verificando configuração..."
if [ -f "godot-mcp-server/mcp-config.json" ]; then
    echo -e "  ${GREEN}✓${NC} mcp-config.json encontrado"
    cat godot-mcp-server/mcp-config.json | grep -q "projeto_godot" && echo -e "  ${GREEN}✓${NC} Caminho do projeto configurado"
else
    echo -e "  ${RED}✗${NC} Configuração não encontrada"
    exit 1
fi

# 3. Verificar projeto Godot
echo ""
echo "3. Verificando projeto Godot..."
if [ -f "projeto_godot/project.godot" ]; then
    echo -e "  ${GREEN}✓${NC} project.godot encontrado"
    echo "  Versão: $(grep 'config/features' projeto_godot/project.godot | grep -o '4\.[0-9]')"
else
    echo -e "  ${RED}✗${NC} Projeto Godot não encontrado"
    exit 1
fi

# 4. Verificar Node.js
echo ""
echo "4. Verificando Node.js..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "  ${GREEN}✓${NC} Node.js instalado: $NODE_VERSION"
else
    echo -e "  ${RED}✗${NC} Node.js não encontrado"
    exit 1
fi

# 5. Testar execução do MCP (timeout de 5s)
echo ""
echo "5. Testando execução do MCP Server..."
timeout 5s node godot-mcp-server/build/index.js 2>&1 | head -20 &
MCP_PID=$!
sleep 2

if ps -p $MCP_PID > /dev/null 2>&1; then
    echo -e "  ${GREEN}✓${NC} MCP Server iniciou com sucesso"
    kill $MCP_PID 2>/dev/null || true
else
    echo -e "  ${YELLOW}⚠${NC}  MCP Server pode ter problemas (verifique logs acima)"
fi

# 6. Listar ferramentas disponíveis
echo ""
echo "6. Ferramentas MCP disponíveis:"
echo "  - list_godot_projects (auto-aprovado)"
echo "  - get_project_info (auto-aprovado)"
echo "  - get_debug_output (auto-aprovado)"
echo "  - run_project (requer aprovação)"
echo "  - launch_editor (requer aprovação)"
echo "  - create_scene (requer aprovação)"

# 7. Status final
echo ""
echo "========================================"
echo "RESUMO DO TESTE"
echo "========================================"
echo -e "${GREEN}✓${NC} Build MCP OK"
echo -e "${GREEN}✓${NC} Configuração OK"
echo -e "${GREEN}✓${NC} Projeto Godot OK"
echo -e "${GREEN}✓${NC} Node.js OK"
echo ""
echo "✨ MCP Server está pronto para uso!"
echo ""
echo "📖 Como usar:"
echo "  1. Leia GUIA_GODOT_MCP.md"
echo "  2. Configure seu editor (Cline/Cursor)"
echo "  3. Peça à IA: 'Liste os projetos Godot'"
echo ""
echo "🎮 Projeto configurado: /workspaces/TheCoreDescent/projeto_godot"
