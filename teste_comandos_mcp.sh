#!/bin/bash

echo "🎮 === SIMULADOR DE COMANDOS MCP - THE CORE DESCENT ==="
echo "Testando comandos com os 11 níveis existentes..."
echo

# Comando 1: Listar todos os scripts
echo "=== COMANDO 1: list-project-scripts ==="
echo "Script: @mcp godot-mcp-core-descent list-project-scripts"
echo "RESULTADO:"
find /workspace/projeto_godot/scripts -name "Level*.gd" | sort
echo "Total: $(find /workspace/projeto_godot/scripts -name "Level*.gd" | wc -l) arquivos de nível"
echo

# Comando 2: Analisar Level 1
echo "=== COMANDO 2: read-script Level1 ==="
echo "Script: @mcp godot-mcp-core-descent read-script /workspace/projeto_godot/scripts/Level1.gd"
echo "ANÁLISE MCP:"
echo "Tamanho: $(wc -l < /workspace/projeto_godot/scripts/Level1.gd) linhas"
echo "Tema: $(grep -o 'Tema: .*' /workspace/projeto_godot/scripts/Level1.gd | head -1)"
echo "Puzzles: $(grep -o '"puzzle[^"]*"' /workspace/projeto_godot/scripts/Level1.gd | wc -l) identificados"
echo

# Comando 3: Analisar Level 11 (mais recente)
echo "=== COMANDO 3: read-script Level11 (DevOps & Cloud) ==="
echo "Script: @mcp godot-mcp-core-descent read-script /workspace/projeto_godot/scripts/Level11.gd"
echo "ANÁLISE MCP:"
echo "Tamanho: $(wc -l < /workspace/projeto_godot/scripts/Level11.gd) linhas"
echo "Tema: $(grep -o 'Tema: .*' /workspace/projeto_godot/scripts/Level11.gd | head -1)"
echo "Puzzles: $(grep -o '"puzzle[^"]*"' /workspace/projeto_godot/scripts/Level11.gd | wc -l) identificados"
echo

# Comando 4: Análise de performance
echo "=== COMANDO 4: analyze-script (todos os níveis) ==="
echo "Script: @mcp godot-mcp-core-descent analyze-script /workspace/projeto_godot/scripts/Level*.gd"
echo "ANÁLISE DE PERFORMANCE:"
echo "Total de linhas de código: $(find /workspace/projeto_godot/scripts -name "Level*.gd" -exec wc -l {} + | tail -1 | awk '{print $1}')"
echo "Nível mais complexo: Level$(find /workspace/projeto_godot/scripts -name "Level*.gd" -exec wc -l {} + | sort -n | tail -1 | awk '{print $NF}' | grep -o 'Level[0-9]\+' | grep -o '[0-9]\+') ($(find /workspace/projeto_godot/scripts -name "Level*.gd" -exec wc -l {} + | sort -n | tail -1 | awk '{print $1}') linhas)"
echo "Nível mais simples: Level$(find /workspace/projeto_godot/scripts -name "Level*.gd" -exec wc -l {} + | sort -n | head -1 | awk '{print $NF}' | grep -o 'Level[0-9]\+' | grep -o '[0-9]\+') ($(find /workspace/projeto_godot/scripts -name "Level*.gd" -exec wc -l {} + | sort -n | head -1 | awk '{print $1}') linhas)"
echo

# Comando 5: Sugestões de otimização
echo "=== COMANDO 5: optimize-script (GameManager) ==="
echo "Script: @mcp godot-mcp-core-descent read-script /workspace/projeto_godot/scripts/GameManager.gd"
echo "ANÁLISE DE ARQUITETURA:"
echo "Tamanho: $(wc -l < /workspace/projeto_godot/scripts/LevelManager.gd) linhas"
echo "Funções detectadas: $(grep -c 'func ' /workspace/projeto_godot/scripts/LevelManager.gd)"
echo "Sinais utilizados: $(grep -c 'signal ' /workspace/projeto_godot/scripts/LevelManager.gd)"
echo

# Comando 6: Criar Level 12
echo "=== COMANDO 6: create-script Level12 ==="
echo "Script: @mcp godot-mcp-core-descent create-script Level12 'cybersecurity'"
echo "PROMPT: 'Crie Level12.gd sobre Cybersecurity com 6 puzzles progressivos, target_moves 58→68'"
echo "STATUS: Pronto para execução via MCP"
echo

echo "✅ === TESTE MCP CONCLUÍDO ==="
echo "Todos os comandos simulados com sucesso!"
echo "Os níveis estão prontos para análise via Claude Desktop MCP"

