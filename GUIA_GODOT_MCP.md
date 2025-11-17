# 🎮 Guia de Uso do Godot MCP - The Core Descent

**Data**: 2024-01-17  
**Projeto**: The Core Descent  
**MCP Server**: Godot MCP (já configurado)

---

## ✅ Status da Configuração

- ✅ MCP Server compilado em: `godot-mcp-server/build/`
- ✅ Configuração criada: `godot-mcp-server/mcp-config.json`
- ✅ VSCode settings: `.vscode/mcp-settings.json`
- ✅ Projeto Godot em: `projeto_godot/`

---

## 🚀 Comandos Disponíveis via IA

### 1. **Análise do Projeto**

**Listar projetos Godot:**
```
"Liste todos os projetos Godot no workspace"
```

**Obter informações do projeto:**
```
"Mostre as informações do projeto The Core Descent"
```

**Ver estrutura de cenas:**
```
"Mostre a árvore de cenas do projeto"
```

---

### 2. **Execução e Debug**

**Executar projeto:**
```
"Execute o projeto Godot The Core Descent"
```

**Capturar erros:**
```
"Execute o projeto e capture todos os erros de debug"
```

**Executar Level1 específico:**
```
"Execute o Level1 e mostre os erros no console"
```

---

### 3. **Gerenciamento de Cenas**

**Criar nova cena:**
```
"Crie uma cena de teste com um Node2D raiz e um Label filho"
```

**Modificar cena existente:**
```
"Adicione um Timer ao Level1.tscn"
```

**Exportar para GridMap:**
```
"Exporte os recursos do Level1 para GridMap"
```

---

### 4. **Análise de Código GDScript**

**Validar sintaxe:**
```
"Verifique se há erros de sintaxe em todos os arquivos .gd"
```

**Analisar Level específico:**
```
"Analise o código do Level1.gd e sugira melhorias"
```

---

## 📋 Fluxo de Trabalho Recomendado

### **Fase 1: Verificação Inicial**
```
Você: "Analise o projeto The Core Descent e liste todos os níveis"

IA usando MCP:
1. Lista projetos Godot no workspace
2. Obtém info do projeto_godot/
3. Mostra estrutura: 11 níveis + BaseLevel + Services
4. Identifica arquivos .tscn e .gd
```

### **Fase 2: Teste e Debug**
```
Você: "Execute Level1 e mostre erros"

IA usando MCP:
1. Executa: godot4 --headless --path projeto_godot/
2. Captura output do console
3. Filtra erros e warnings
4. Sugere correções baseadas nos erros
```

### **Fase 3: Correção Iterativa**
```
Você: "Corrija o erro de referência nula no Level1"

IA usando MCP:
1. Lê codigo/Level1.gd
2. Aplica correção
3. Executa novamente
4. Confirma que erro foi resolvido
```

---

## 🛠️ Ferramentas MCP Disponíveis

### **list_godot_projects**
- Lista todos os projetos Godot no workspace
- Auto-aprovado (não precisa confirmação)

### **get_project_info**
- Retorna detalhes do projeto (versão, cenas, scripts)
- Auto-aprovado

### **run_project**
- Executa o projeto em modo headless
- **Requer aprovação manual**

### **launch_editor**
- Abre o editor Godot
- **Requer aprovação manual**

### **get_debug_output**
- Captura saída do console durante execução
- Auto-aprovado

### **get_scene_tree**
- Retorna estrutura de nodes de uma cena
- Auto-aprovado

### **create_scene**
- Cria nova cena .tscn
- **Requer aprovação manual**

### **add_node_to_scene**
- Adiciona node a cena existente
- **Requer aprovação manual**

### **export_gridmap_resources**
- Exporta recursos para GridMap
- **Requer aprovação manual**

---

## 🎯 Casos de Uso Específicos

### **Validar Level1 Refatorado**
```bash
# Comando direto (você mesmo):
cd /workspaces/TheCoreDescent
bash scripts/ci/validate_level1_static.sh

# Via IA com MCP:
"Execute o script de validação estática do Level1 e mostre os resultados"
```

### **Testar Todos os Níveis**
```
"Execute cada nível (1-11) em headless mode e capture erros de cada um"
```

### **Analisar Performance**
```
"Execute o projeto por 30 segundos e analise o uso de memória e FPS"
```

### **Comparar Level1 Original vs Refatorado**
```
"Compare o Level1.gd da branch main com o da branch feature/core-services-refactor"
```

---

## ⚙️ Configuração Manual (Opcional)

### **Para Cline/Claude Dev:**

Arquivo: `~/Library/Application Support/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json`

```json
{
  "mcpServers": {
    "godot-the-core-descent": {
      "command": "node",
      "args": ["/workspaces/TheCoreDescent/godot-mcp-server/build/index.js"],
      "env": {
        "GODOT_BIN": "godot4",
        "GODOT_PROJECT_PATH": "/workspaces/TheCoreDescent/projeto_godot",
        "GODOT_MCP_CONFIG": "/workspaces/TheCoreDescent/godot-mcp-server/mcp-config.json",
        "DEBUG": "true"
      },
      "disabled": false,
      "autoApprove": ["list_godot_projects", "get_project_info", "get_debug_output"]
    }
  }
}
```

### **Para Cursor:**

Arquivo: `.cursor/mcp.json` (na raiz do projeto)

```json
{
  "mcpServers": {
    "godot": {
      "command": "node",
      "args": ["godot-mcp-server/build/index.js"],
      "env": {
        "GODOT_PROJECT_PATH": "projeto_godot"
      }
    }
  }
}
```

---

## 🐛 Troubleshooting

### **Godot não encontrado**
```bash
# Verificar onde está o Godot:
which godot4 godot

# Se não estiver no PATH, configure:
export GODOT_BIN=/caminho/para/godot4
```

### **MCP não responde**
```bash
# Recompilar MCP:
cd godot-mcp-server
npm run build

# Testar manualmente:
node build/index.js
```

### **Permissões negadas**
```bash
# Dar permissão de execução:
chmod +x scripts/ci/*.sh
```

---

## 📊 Benefícios para The Core Descent

✅ **Validação Automatizada**: IA executa e vê erros reais dos 11 níveis
✅ **Feedback Instantâneo**: Correções testadas imediatamente
✅ **Análise de Refatoração**: Comparar antes/depois da migração para BaseLevel
✅ **Debug Inteligente**: Sugestões baseadas em erros Godot reais
✅ **Economia de Tempo**: Menos alternância entre terminal e editor

---

## 🎮 Exemplo de Sessão Completa

```
Você: "Verifique o status do projeto The Core Descent após a refatoração"

IA usando MCP:
1. ✅ Lista projeto em projeto_godot/
2. ✅ Identifica 11 níveis + BaseLevel + Services
3. ✅ Executa validação estática (24/24 testes)
4. ✅ Executa projeto headless
5. ✅ Captura 0 erros de sintaxe
6. ✅ Confirma todos os níveis carregam
7. ✅ Mostra métricas: -43% LOC no Level1
8. ✅ Sugere: "Próximo passo - migrar Level2"
```

---

## 📝 Notas Importantes

- **Godot Binary**: Se Godot não estiver no PATH, configure `GODOT_BIN` no ambiente
- **Aprovações**: Comandos que modificam arquivos precisam de aprovação manual
- **Debug Mode**: `DEBUG=true` habilita logs detalhados do MCP
- **Performance**: Execução headless é mais rápida que abrir o editor

---

## 🚀 Próximos Passos

1. **Testar MCP**: Peça à IA para listar projetos
2. **Executar Level1**: Validar refatoração com execução real
3. **Automatizar Testes**: Criar workflow que usa MCP para CI/CD
4. **Expandir Uso**: Usar MCP para migrar Level2-14

---

**Configuração salva em**: `.vscode/mcp-settings.json` e `godot-mcp-server/mcp-config.json`

**Status**: ✅ Pronto para usar!
