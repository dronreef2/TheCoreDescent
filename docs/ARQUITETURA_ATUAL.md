# Arquitetura Atual - The Core Descent

**Data da Snapshot:** 15 de Novembro de 2025  
**Status:** Pré-Refatoração (Baseline para Phase 0)

---

## 1. Topologia em Runtime

### **1.1 Camada de Coordenação**
```
GameManager (AutoLoad Singleton)
├── Estado Global: GameState enum (MAIN_MENU, PLAYING, PAUSED, etc.)
├── Progressão: unlocked_levels[], player_stats{}
├── Sistemas Principais:
│   ├── DragAndDropSystem (filho)
│   ├── PlayerController (filho)
│   ├── UIManager (filho)
│   ├── AudioManager (filho)
│   └── SaveSystem (filho)
└── Scene Management: carrega/limpa níveis dinamicamente
```

**Responsabilidades:**
- State machine para fluxo de menu → nível → pause → complete
- Gerenciamento de unlocks e estatísticas do jogador
- Orquestração de sistemas (drag, player, UI, audio, save)
- Scene loading/cleanup (cria/remove `current_level` node)

**Problemas:**
- **Monólito**: ~575 linhas misturando state, UI, scene lifecycle
- **Acoplamento**: UI setup embutido (`setup_main_menu()`, `setup_level_select()`, `setup_pause_menu()`)
- **Duplicação**: Lógica de unlock repetida em múltiplos lugares

---

### **1.2 Camada de Níveis**
```
Level1..Level14 (extends Node2D, cada um ~400-700 linhas)
├── Configuração: level_name, target_moves, grid_size
├── Estado: LevelState enum (LOADING, PLAYING, COMPLETED)
├── UI: move_counter, timer_label, puzzle_title, instructions
├── Puzzles: available_puzzles[] (array de dicionários)
└── Métodos:
    ├── _ready() → setup_level() + setup_ui() + load_puzzles()
    ├── setup_level(): obter refs de GameManager
    ├── setup_ui(): criar labels, botões (150 linhas duplicadas)
    ├── load_available_puzzles(): definir puzzles únicos do nível
    └── load_puzzle(idx): configurar objetivo atual
```

**Boilerplate Comum (~40% de cada arquivo):**
- `_ready()`, `setup_level()`, `setup_ui()` idênticos
- UI labels (move_counter, timer, title, instructions)
- Estado: `LevelState` enum, `moves_used`, `level_timer`, `is_timer_running`
- Timer logic em `_process(delta)`

**Variações:**
- Level2+ adicionam `ability_system`, `ability_counter` label
- Level3+ introduzem `network_system`, `layer_system`
- Cada nível tem puzzles únicos em `available_puzzles[]`

**Problemas:**
- **Duplicação massiva**: ~150 linhas de boilerplate por arquivo (14 níveis = 2100 LOC duplicados)
- **Manutenção difícil**: Mudança em UI requer editar 14 arquivos
- **Sem herança**: Oportunidade clara para `BaseLevel` class

---

### **1.3 Ponte MCP (Godot ↔ AI Copilots)**
```
godot-mcp-server (Node.js/TypeScript)
├── processManager: lançar/parar editor/runtime
├── sceneManager: criar/editar .tscn files
├── uidManager: regenerar UIDs Godot 4.4+
└── projectScanner: analisar project.godot, contar recursos
```

**Ferramentas Expostas:** 16 tools (ver `external_api/mcp_function_list.json`)

**Status de Integração:**
- ✅ Servidor MCP funcional e testado
- ✅ README documentado com exemplos
- ✅ Inventário de funções em JSON
- ❌ **Nenhum script GDScript** invoca MCP ativamente
- ❌ Sem addon Godot para chamar server via HTTP/stdio
- ❌ Manual syncing: desenvolvedor roda comandos via Claude Desktop

**Oportunidades:**
- Criar addon `addons/godot_mcp/` com HTTP client
- Expor tools via `EditorPlugin` menus
- Automatizar UID refresh em save hooks

---

## 2. Pain Points (Pré-Refatoração)

### **2.1 Monólito GameManager**
**Sintoma:** 575 linhas, 40+ métodos públicos  
**Impacto:**
- Difícil teste unitário (sem injeção de dependência)
- Mudanças em state machine arriscam quebrar UI/save
- Nova feature requer tocar arquivo crítico

**Proposta:** Extrair `GameStateService` (state + unlock logic) e `LevelFlowService` (scene load/cleanup)

---

### **2.2 Boilerplate de Níveis**
**Sintoma:** 2100 LOC duplicados em setup/UI  
**Impacto:**
- Adicionar label requer 14 edits
- Bugs em timer logic replicam em todos os níveis
- Novos níveis copiam código velho com bugs

**Proposta:** `BaseLevel` class com hooks virtuais (`_on_level_ready()`, `_customize_ui()`)

---

### **2.3 Integração MCP Manual**
**Sintoma:** MCP server isolado, sem ponte ativa com Godot  
**Impacto:**
- AI copilot não pode auto-update UIDs após edit
- Scene creation requer copy/paste manual
- Nenhum workflow automatizado para CI

**Proposta:**
- Addon HTTP client chamando MCP server
- CI job rodando `run_project --headless` + `get_debug_output`
- Pre-commit hook: `gdlint` + `update_project_uids` se necessário

---

### **2.4 Sem Lint/CI para GDScript**
**Sintoma:** 47+ trailing whitespace errors em Level6.gd  
**Impacto:**
- Code style inconsistente
- PRs com whitespace noise
- Nenhum gate para bad practices (max-line-length, too many methods)

**Proposta:**
- CI job rodando `gdlint` (non-blocking inicialmente)
- Pre-commit hook local
- Cleanup gradual via auto-format

---

## 3. Changelog de Refatorações Planejadas

### **Phase 0: Groundwork** (Este Documento)
- [x] Inventário MCP: `external_api/mcp_function_list.json`
- [x] gdlint wiring: `scripts/lint_gd.sh`, `pyproject.toml`
- [x] Architecture snapshot: `docs/ARQUITETURA_ATUAL.md`

### **Phase 1: Core Services Refactor**
- [ ] Branch `feature/core-services-refactor`
- [ ] Extrair `codigo/services/GameStateService.gd` (state machine, unlock logic)
- [ ] Extrair `codigo/services/LevelFlowService.gd` (scene loading, HUD wiring)
- [ ] Adaptar `GameManager.gd` para delegar aos services
- [ ] Unit tests: `projeto_godot/tests/test_game_state_service.gd`

### **Phase 2: BaseLevel Prototype**
- [ ] Criar `codigo/BaseLevel.gd` (~180 linhas)
- [ ] Migrar `Level1.gd` e `Level2.gd` (samples)
- [ ] Validar: headless load, timer funciona, UI idêntica
- [ ] Rollout: migrar Level3-14 em batches

### **Phase 3: CI Enhancement**
- [ ] Job `lint-gdscript`: rodar `gdlint` em todos .gd
- [ ] Job `validate-scenes`: headless load check
- [ ] Job `test-mcp-server`: npm lint + tool inventory validation
- [ ] Criar `scripts/ci/validate_scene.gd`

### **Phase 4: MCP Workflow Docs**
- [ ] `docs/MCP_WORKFLOWS.md` com exemplos práticos
- [ ] Atualizar `GUIDE_GODOT_MCP_CORE_DESCENT.md` com common gotchas
- [ ] Diagrama: Godot → MCP Server → AI Copilot loop

---

## 4. Métricas Baseline

| Métrica | Valor (Pré-Refactor) | Alvo (Pós-Refactor) |
|---------|----------------------|---------------------|
| Linhas duplicadas (níveis) | ~2100 | <500 |
| LOC GameManager.gd | 575 | <300 |
| Níveis sem BaseLevel | 14 | 0 |
| CI jobs GDScript | 0 | 3 (lint, scenes, MCP) |
| MCP tools documentados | 16 | 16 + workflows |
| Trailing whitespace errors | 47+ (Level6 alone) | <10 (projeto todo) |

---

## 5. Próximos Passos

1. **Commit Phase 0 artifacts:**
   ```bash
   git add external_api/mcp_function_list.json
   git add GUIDE_GODOT_MCP_CORE_DESCENT.md
   git add scripts/lint_gd.sh pyproject.toml
   git add docs/ARQUITETURA_ATUAL.md
   git commit -m "docs: Phase 0 groundwork - MCP inventory, gdlint, architecture snapshot"
   ```

2. **Create refactor branch:**
   ```bash
   git checkout -b feature/core-services-refactor
   ```

3. **Start service extraction** (ver planejamento detalhado no histórico de conversa)

---

**Última Atualização:** 2025-11-15  
**Responsável:** GitHub Copilot (Claude Sonnet 4.5) + @dronreef2
