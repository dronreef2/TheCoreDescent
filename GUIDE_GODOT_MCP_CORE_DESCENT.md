# Godot MCP - Guia para The Core Descent

## 🚀 **Configuração Completa Implementada**

### **Status da Implementação:**
- ✅ Plugin Godot MCP baixado e configurado
- ✅ Servidor MCP compilado e testado
- ✅ Plugin MCP copiado para projeto The Core Descent
- ✅ Configuração personalizada criada
- ✅ Pronto para uso com Claude Desktop
- ✅ Inventário de funções MCP documentado em `external_api/mcp_function_list.json`

---

## 📚 **Inventário de Ferramentas MCP**

O servidor MCP expõe **16 ferramentas** para automação Godot. Veja a documentação completa em:
```
external_api/mcp_function_list.json
```

### **Principais Categorias:**

#### 🎮 **Gerenciamento de Processos**
- `launch_editor` - Abre o editor Godot (requer `GODOT_ALLOW_EDITOR=true`)
- `run_project` - Executa projeto em modo debug ou headless
- `get_debug_output` - Captura logs stdout/stderr
- `stop_project` - Encerra processo Godot
- `list_processes` - Lista processos ativos gerenciados pelo MCP

#### 📁 **Descoberta de Projetos**
- `get_godot_version` - Versão instalada do Godot
- `list_projects` - Busca projetos em árvore de diretórios
- `get_project_info` - Analisa `project.godot` e conta recursos

#### 🎬 **Edição de Cenas**
- `create_scene` - Cria `.tscn` com nó raiz
- `add_node` - Insere novo nó em cena existente
- `load_sprite` - Atribui textura a Sprite2D
- `export_mesh_library` - Exporta MeshLibrary de MeshInstance nodes
- `save_scene` - Copia cena com UID opcional regenerado

#### 🔧 **Gerenciamento de UIDs**
- `get_uid` - Lê UID de recurso `.tscn`/`.tres`
- `update_project_uids` - Regenera UIDs em lote e atualiza referências

### **⚠️ Gotchas e Limitações:**

1. **`launch_editor`:**
   - Bloqueado por padrão (set `GODOT_ALLOW_EDITOR=true` no config)
   - Retorna ID de processo para tracking

2. **`run_project` headless:**
   - Útil para CI/testes automatizados
   - Use `get_debug_output` para recuperar logs incrementalmente

3. **`update_project_uids`:**
   - ⚠️ **Operação destrutiva** - faça backup antes
   - Atualiza automaticamente referências `uid://`
   - Use `patterns` para filtrar arquivos específicos

4. **Propriedades em `add_node`:**
   - Suporta: strings, numbers, booleans, Vector2/3, Color
   - Para texturas Sprite2D, use `load_sprite` ao invés de properties

---

## 📋 **Configuração do Claude Desktop**

### **1. Configuração Local (Recomendada)**
Copie o conteúdo de `/workspace/claude_desktop_config_core_descent.json` para seu arquivo de configuração do Claude Desktop:

**Para macOS:**
```bash
nano ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

**Para Windows:**
```bash
notepad %APPDATA%\Claude\claude_desktop_config.json
```

### **2. Configuração Linux:**
```bash
nano ~/.config/claude/claude_desktop_config.json
```

### **3. Configuração Completa:**
```json
{
  "mcpServers": {
    "godot-mcp-core-descent": {
      "command": "node",
      "args": [
        "/workspace/godot-mcp/server/dist/index.js"
      ],
      "env": {
        "MCP_TRANSPORT": "stdio",
        "GODOT_PROJECT_PATH": "/workspace/projeto_godot"
      }
    }
  }
}
```

---

## 🎮 **Comandos Específicos para The Core Descent**

### **📊 Análise de Níveis Existentes**

#### **1. Analisar Level 11 (DevOps & Cloud):**
```
@mcp godot-mcp-core-descent read-script /workspace/projeto_godot/scripts/Level11.gd
```
**Prompt:** "Analise o Level11.gd e sugira otimizações de performance"

#### **2. Listar Todos os Scripts do Projeto:**
```
@mcp godot-mcp-core-descent list-project-scripts
```
**Prompt:** "Liste todos os scripts e identifique quais precisam de refactoring"

#### **3. Análise de Scene Current:**
```
@mcp godot-mcp-core-descent read godot://scene/current
```
**Prompt:** "Analise a estrutura da cena atual e sugira melhorias na UI"

### **🔧 Otimização de Código**

#### **4. Analisar GameManager:**
```
@mcp godot-mcp-core-descent read-script /workspace/projeto_godot/scripts/GameManager.gd
```
**Prompt:** "Revise o GameManager.gd e sugira melhorias na arquitetura de gerenciamento de estados"

#### **5. Otimizar LevelManager:**
```
@mcp godot-mcp-core-descent read-script /workspace/projeto_godot/scripts/LevelManager.gd
```
**Prompt:** "Analise o LevelManager.gd e proponha otimizações para o carregamento de níveis"

#### **6. Sistema de Habilidades:**
```
@mcp godot-mcp-core-descent read-script /workspace/projeto_godot/scripts/AdvancedLanguageAbilitySystem.gd
```
**Prompt:** "Analise o sistema de habilidades e sugira melhorias na performance"

---

## 🎯 **Criação de Novos Níveis via MCP**

### **7. Criar Level 12 - Cybersecurity:**
```
@mcp godot-mcp-core-descent create-script
```
**Prompt:** "Crie Level12.gd sobre Cybersecurity com foco em Network Security, Penetration Testing, e Compliance. Use a mesma estrutura dos níveis anteriores com 6 puzzles progressivos (58→68 movimentos)"

### **8. Criar Level 13 - Product Management:**
```
@mcp godot-mcp-core-descent create-script  
```
**Prompt:** "Crie Level13.gd sobre Product Management com foco em Product Strategy, User Research, e Agile Methodologies. Continue a progressão (70→80 movimentos)"

### **9. Criar Sistema de Save/Load:**
```
@mcp godot-mcp-core-descent create-script
```
**Prompt:** "Crie um sistema de save/load para o jogo The Core Descent com progressão de níveis"

---

## 🎨 **Manipulação de Cenas e UI**

### **10. Analisar Cena Principal:**
```
@mcp godot-mcp-core-descent read-scene /workspace/projeto_godot/scenes/Main.tscn
```
**Prompt:** "Analise a estrutura da Main.tscn e sugira melhorias na interface do usuário"

### **11. Adicionar Nova Cena de Menu:**
```
@mcp godot-mcp-core-descent create-scene
```
**Prompt:** "Crie uma nova cena de menu principal com botões para cada nível (1-11) e sistema de progresso visual"

### **12. Modificar Cena Existente:**
```
@mcp godot-mcp-core-descent modify-node
```
**Prompt:** "Adicione uma barra de progresso visual para cada nível no menu principal"

---

## 🛠️ **Configurações do Projeto**

### **13. Analisar Configurações:**
```
@mcp godot-mcp-core-descent get-project-settings
```
**Prompt:** "Analise as configurações do projeto e sugira otimizações para melhor performance"

### **14. Listar Recursos:**
```
@mcp godot-mcp-core-descent list-project-resources
```
**Prompt:** "Liste todos os recursos do projeto e identifique quais podem ser otimizados"

---

## 🔍 **Debug e Testes**

### **15. Executar Projeto:**
```
@mcp godot-mcp-core-descent run-project
```
**Prompt:** "Execute o projeto e teste se todos os 11 níveis carregam corretamente"

### **16. Analisar Estado do Editor:**
```
@mcp godot-mcp-core-descent get-editor-state
```
**Prompt:** "Mostre o estado atual do editor e identifique possíveis problemas"

---

## 📈 **Análise de Performance**

### **17. Análise Completa dos Níveis:**
```
@mcp godot-mcp-core-descent list-project-scripts | grep Level
```
**Prompt:** "Analise todos os níveis 1-11 e crie um relatório de performance com sugestões de otimização"

### **18. Refactoring Sugerido:**
```
@mcp godot-mcp-core-descent analyze-script /workspace/projeto_godot/scripts/Level10.gd
```
**Prompt:** "Analise o Level10.gd (Game Development) e sugira refactoring para melhor arquitetura"

---

## 🚀 **Casos de Uso Avançados**

### **19. Criar Sistema de Tutoriais:**
```
@mcp godot-mcp-core-descent create-script
```
**Prompt:** "Crie um sistema de tutoriais interativos que expliquem as mecânicas de cada nível"

### **20. Implementar Sistema de Conquistas:**
```
@mcp godot-mcp-core-descent create-script
```
**Prompt:** "Implemente um sistema de conquistas baseado no progresso através dos 11 níveis"

### **21. Otimizar Sistema de UI:**
```
@mcp godot-mcp-core-descent modify-script /workspace/projeto_godot/scripts/AdvancedLanguageUI.gd
```
**Prompt:** "Otimize o sistema de UI para melhor responsividade e experiência do usuário"

---

## 🎯 **Prompts Práticos para The Core Descent**

### **Para Desenvolvimento Diário:**
```
"@mcp godot-mcp-core-descent Analise o projeto The Core Descent e me ajude a identificar as próximas otimizações necessárias"
```

### **Para Criação de Conteúdo:**
```
"@mcp godot-mcp-core-descent Crie um novo nível sobre [tema específico] seguindo o padrão dos níveis existentes"
```

### **Para Debug:**
```
"@mcp godot-mcp-core-descent Debug o Level 11.gd e identifique por que pode não estar funcionando corretamente"
```

### **Para Performance:**
```
"@mcp godot-mcp-core-descent Otimize a performance geral do projeto The Core Descent"
```

---

## 📊 **Status Atual do Projeto**

### **The Core Descent - Níveis Implementados:**
1. ✅ Level 1 - A Torre de Marfim (Lógica Básica)
2. ✅ Level 2 - A Forja de Ponteiros (C++ Memory)
3. ✅ Level 3 - A Biblioteca de Objetos (OOP)
4. ✅ Level 4 - A Arquitetura Concorrente (Concurrency)
5. ✅ Level 5 - O Servidor Web (Web Development)
6. ✅ Level 6 - O Aplicativo Móvel (Mobile)
7. ✅ Level 7 - O Data Center (Data Science)
8. ✅ Level 8 - O Laboratório de Testes (QA)
9. ✅ Level 9 - As Fronteiras da Tecnologia (Emerging Tech)
10. ✅ Level 10 - O Estúdio de Jogos (Game Development)
11. ✅ Level 11 - A Fábrica Cloud (DevOps & Cloud)

### **Próximos Níveis Sugeridos:**
- **Level 12** - A Fortaleza Digital (Cybersecurity)
- **Level 13** - O Laboratório de Produto (Product Management)
- **Level 14** - A Agência de Marketing (Marketing & Analytics)

---

## 🛠️ **Troubleshooting**

### **Se o MCP não conectar:**
1. Verifique se o caminho do projeto está correto
2. Reinicie o Claude Desktop
3. Verifique se o Godot Engine está instalado

### **Se comandos não funcionarem:**
1. Verifique se os arquivos existem no caminho especificado
2. Confirme que o Godot project.godot está na pasta correta
3. Reinicie o servidor MCP

---

*Guia criado em: 2025-11-16 02:13:56*  
*Projeto: The Core Descent - 11 Níveis Implementados*  
*Plugin: Godot MCP configurado e pronto para uso*