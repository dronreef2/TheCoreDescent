# THE CORE DESCENT - Game Design Document Expandido
## Desenvolvimento Fase 1: Protótipo Nível 1 Block-Based Logic

---

## EXECUTIVE SUMMARY - VIABILIDADE E COMPLEXIDADE

### Viabilidade Técnica: ALTA ✅
- **Complexidade de Implementação:** Baixa a Média
- **Equipe Necessária:** 1-2 desenvolvedores
- **Timeline Protótipo:** 3-4 semanas
- **Stack Tecnológica:** Godot Engine + GDScript
- **Principais Riscos:** System de drag-and-drop, performance com múltiplos objetos

### Complexidade por Nível:
- **Nível 1 (High-Level):** BAIXA - Block-based logic viável
- **Nível 2 (C/C++):** MÉDIA - Sistema de memória complexo
- **Nível 3 (Assembly):** MÉDIA - Otimização e sequenciamento
- **Nível 4 (Machine):** ALTA - Pattern recognition system
- **Nível 5 (Hardware):** ALTA - Timing-based logic gates

---

## MVP FEATURE BREAKDOWN - IMPLEMENTAÇÃO PRIORITÁRIA

### FASE 1 - CORE LOOP PROTOTYPE (Sprint 0-2)
**Prioridade: CRÍTICA**

#### 1.1 Block-Based Logic System
```
MECÂNICA: Drag-and-drop de blocos de lógica
DIFICULDADE: Baixa | ESFORÇO: 1 semana
```

**Especificação Técnica Godot:**
```gdscript
# Classes principais necessárias:
class_name LogicBlock
extends Node2D

enum BlockType { IF, ELSE, FOR, WHILE, VARIABLE }
enum BlockState { IDLE, DRAGGING, SNAP_TO_GRID }

var block_type: BlockType
var block_state: BlockState
var grid_position: Vector2i
var connection_points: Array[Vector2i] = []

# Sistema de snap to grid
func snap_to_grid():
    grid_position = position / GRID_SIZE
    position = grid_position * GRID_SIZE

# Verificação de conexões válidas
func can_connect(target_block: LogicBlock) -> bool:
    return connection_type.is_compatible(target_block.connection_type)
```

#### 1.2 Tracer Movement System
```
MECÂNICA: Personagem navega por labirinto lógico
DIFICULDADE: Baixa | ESFORÇO: 3 dias
```

**Algoritmo de Pathfinding:**
```gdscript
# Node-based pathfinding para lógica condicional
func evaluate_path(current_node: LogicNode) -> PathResult:
    match current_node.block_type:
        LogicBlock.BlockType.IF:
            return evaluate_condition(current_node.condition)
        LogicBlock.BlockType.FOR:
            return execute_loop(current_node.iterations)
        _:
            return PathResult.CONTINUE
```

#### 1.3 Language-Specific Abilities
```
SISTEMA: 4 especializações com habilidades únicas
DIFICULDADE: Baixa | ESFORÇO: 1 semana
```

**Implementação por Linguagem:**
- **Python (Duck Typing):** Verificação flexível de tipos
- **Java (Garbage Collector):** Sistema de cleanup automático
- **C# (.NET Framework):** Pontes pré-construídas
- **JavaScript (Callback):** Sistema de teleporte

### FASE 2 - PROGRESSÃO BÁSICA (Sprint 3-4)
**Prioridade: ALTA**

#### 2.1 Level Progression System
```gdscript
# Sistema de progressão incremental
class_name LevelProgress
extends Node

var current_level: int = 1
var completed_puzzles: Array[int] = []
var player_abilities: Array[String] = []

func unlock_ability(ability_name: String):
    if not player_abilities.has(ability_name):
        player_abilities.append(ability_name)
        emit_signal("ability_unlocked", ability_name)
```

#### 2.2 Basic Achievement System
- Conclusão de 10 puzzles
- Uso de todas as 4 linguagens
- Otimização (soluções em mínimo de movimentos)

---

## TECHNICAL IMPLEMENTATION ROADMAP - FASES REALISTAS

### SPRINT 0: SETUP E ARQUITETURA (3 dias)
**Objetivo:** Ambiente de desenvolvimento funcional

**Tasks Críticos:**
- [ ] Setup projeto Godot com estrutura de pastas
- [ ] Sistema de cenas: Menu principal, Gameplay, Nível 1
- [ ] Git workflow e versionamento
- [ ] Core classes: GameManager, LevelManager, PlayerController

**Estrutura de Pastas:**
```
project/
├── scenes/
│   ├── menus/
│   ├── levels/
│   └── ui/
├── scripts/
│   ├── core/
│   ├── gameplay/
│   └── ui/
├── assets/
│   ├── textures/
│   ├── audio/
│   └── fonts/
└── prefabs/
    ├── blocks/
    └── effects/
```

### SPRINT 1: PROTÓTIPO BLOCK SYSTEM (5 dias)
**Objetivo:** Sistema de blocos funcional

**Implementação Prioritária:**

**1. LogicBlock.gd - Classe Base**
```gdscript
extends Node2D
class_name LogicBlock

# Propriedades essenciais
@export var block_type: LogicBlock.BlockType
@export var visual_color: Color
@export var grid_size: int = 32

# Estados do bloco
enum BlockState { IDLE, DRAGGING, SNAP_TO_GRID, CONNECTED }
var current_state: BlockState = BlockState.IDLE

# Sistema de conexão
var input_connections: Array[Vector2i] = []
var output_connections: Array[Vector2i] = []

func _ready():
    setup_visual()
    setup_connections()

func setup_visual():
    # Sprite baseado no tipo
    var sprite = Sprite2D.new()
    sprite.texture = load_block_texture()
    add_child(sprite)

func _input(event):
    match current_state:
        BlockState.IDLE:
            handle_idle_input(event)
        BlockState.DRAGGING:
            handle_dragging_input(event)
```

**2. DragAndDropSystem.gd**
```gdscript
extends Node

var dragged_block: LogicBlock
var drag_offset: Vector2
var snap_threshold: float = 16.0

func start_drag(block: LogicBlock, mouse_pos: Vector2):
    dragged_block = block
    drag_offset = mouse_pos - block.global_position
    block.current_state = LogicBlock.BlockState.DRAGGING

func update_drag(mouse_pos: Vector2):
    if dragged_block:
        dragged_block.global_position = mouse_pos - drag_offset

func end_drag():
    if dragged_block:
        attempt_snap(dragged_block)
        dragged_block.current_state = LogicBlock.BlockState.IDLE
        dragged_block = null

func attempt_snap(block: LogicBlock):
    var grid_pos = Vector2i(round(block.global_position.x / 32), round(block.global_position.y / 32))
    var world_pos = Vector2(grid_pos.x * 32, grid_pos.y * 32)
    
    if is_valid_grid_position(grid_pos):
        block.global_position = world_pos
        block.grid_position = grid_pos
        block.current_state = LogicBlock.BlockState.SNAP_TO_GRID
```

**3. GameManager.gd - Core Loop**
```gdscript
extends Node

signal level_completed
signal puzzle_solved

var current_level: LevelData
var tracer: PlayerController
var block_system: DragAndDropSystem
var logic_evaluator: LogicEvaluator

func _ready():
    setup_systems()
    load_level_1()

func setup_systems():
    block_system = DragAndDropSystem.new()
    logic_evaluator = LogicEvaluator.new()
    add_child(block_system)
    add_child(logic_evaluator)

func load_level_1():
    current_level = LevelData.new()
    current_level.load_from_file("res://data/levels/level_1.json")
    setup_level(current_level)

func evaluate_puzzle():
    var result = logic_evaluator.evaluate_blocks(current_level.puzzle_blocks)
    if result.is_solved:
        emit_signal("puzzle_solved")
        emit_signal("level_completed")
```

### SPRINT 2: TRACER E GAMEPLAY CORE (5 dias)
**Objetivo:** Personagem funcional e mecânica principal

**PlayerController.gd:**
```gdscript
extends CharacterBody2D
class_name PlayerController

@export var move_speed: float = 100.0
@export var animation_player: AnimationPlayer

var current_logic_path: Array[LogicBlock] = []
var target_position: Vector2

func _ready():
    setup_visual()
    setup_animations()

func _physics_process(delta):
    update_movement(delta)
    check_logic_conditions()

func update_movement(delta):
    velocity = Vector2.ZERO
    
    if target_position != Vector2.ZERO:
        var direction = (target_position - global_position).normalized()
        velocity = direction * move_speed
        
    move_and_slide()

func execute_logic_block(block: LogicBlock):
    match block.block_type:
        LogicBlock.BlockType.IF:
            evaluate_condition(block.condition)
        LogicBlock.BlockType.FOR:
            execute_loop(block.iterations)
        LogicBlock.BlockType.WHILE:
            execute_while_loop(block.condition)

func evaluate_condition(condition: LogicCondition) -> bool:
    # Implementar sistema de condições
    return true  # Placeholder

func execute_loop(iterations: int):
    for i in range(iterations):
        # Executar lógica do loop
        pass
```

### SPRINT 3: LANGUAGE ABILITIES (3 dias)
**Objetivo:** Sistema de especializações funcionando

**LanguageAbilitySystem.gd:**
```gdscript
extends Node

enum Language { PYTHON, JAVA, CSHARP, JAVASCRIPT }

var selected_language: Language
var unlocked_abilities: Array[String] = []

func _ready():
    select_language(Language.PYTHON)  # Default

func select_language(language: Language):
    selected_language = language
    unlock_language_abilities(language)

func unlock_language_abilities(language: Language):
    match language:
        Language.PYTHON:
            unlock_ability("duck_typing")
            unlock_ability("dynamic_typing")
        Language.JAVA:
            unlock_ability("garbage_collection")
            unlock_ability("type_safety")
        Language.CSHARP:
            unlock_ability("dotnet_framework")
            unlock_ability("linq_queries")
        Language.JAVASCRIPT:
            unlock_ability("callbacks")
            unlock_ability("event_handling")

# Habilidades específicas por linguagem
func use_duck_typing(target_type: String, source_type: String) -> bool:
    if unlocked_abilities.has("duck_typing"):
        # Permitir uso flexível de tipos
        return true
    return source_type == target_type

func use_garbage_collection() -> void:
    if unlocked_abilities.has("garbage_collection"):
        # Limpar recursos órfãos
        cleanup_orphaned_resources()

func use_callback(location_id: String) -> void:
    if unlocked_abilities.has("callbacks"):
        # Teleportar para localização marcada
        teleport_to_location(location_id)
```

### SPRINT 4: PUZZLE DESIGN E TESTING (4 dias)
**Objetivo:** Nível 1 completo e testável

**Level 1 Puzzle Examples:**

**Puzzle 1 - Básico IF/ELSE:**
```
Objetivo: Guiar Tracer do ponto A ao B
Condição: Se chave azul coletada E portão aberto → Avançar
Fallback: Senão → Caminho alternativo
Solução: Coletar chave → Portão abre → Mover para próximo bloco
```

**Puzzle 2 - Variáveis:**
```
Objetivo: Usar variável para abrir porta
Mecânica: key_color = "blue" → door.color == key_color
Objetivo: Demonstrar conceito de variáveis
```

**Puzzle 3 - Loop FOR:**
```
Objetivo: Repetir ação 3 vezes
Mecânica: FOR 3x: Coletar item → Avançar
Objetivo: Ensinar iteração
```

---

## RISK ASSESSMENT - COMPLEXIDADE E MITIGATION

### RISCO ALTO: Performance com Múltiplos Blocos
**Probabilidade:** Média | **Impacto:** Alto
**Mitigation:**
- Implementar object pooling para blocos
- Otimizar renderização com tilemaps
- Usar octree para collision detection

### RISCO MÉDIO: Sistema de Conexões Complexo
**Probabilidade:** Alta | **Impacto:** Médio  
**Mitigation:**
- Implementar sistema incremental
- Usar grid-based connection validation
- Criar editor visual para debugging

### RISCO BAIXO: Tracer Movement Logic
**Probabilidade:** Baixa | **Impacto:** Médio
**Mitigation:**
- Pathfinding simples baseado em grid
- Estado machine para behavior
- Debug visualization tools

---

## PERFORMANCE CONSIDERATIONS BY LEVEL

### Level 1 Performance Targets:
- **Frame Rate:** 60 FPS estável
- **Memory Usage:** < 100MB
- **Load Time:** < 3 segundos
- **Simultaneous Blocks:** 50 máximo

### Optimization Strategies:
```gdscript
# Object Pooling para blocos
class_name BlockPool
extends Node

var available_blocks: Array[LogicBlock] = []
var max_pool_size: int = 50

func get_block() -> LogicBlock:
    if available_blocks.size() > 0:
        return available_blocks.pop_back()
    else:
        return LogicBlock.new()

func return_block(block: LogicBlock):
    if available_blocks.size() < max_pool_size:
        block.reset()
        available_blocks.append(block)
```

---

## TEAM DOCUMENTATION - IMPLEMENTAÇÃO PRÁTICA

### PARA PROGRAMADORES:
**TDD Priorities:**
1. LogicBlock system (crítico)
2. DragAndDrop mechanics (crítico) 
3. Player movement logic (importante)
4. Language abilities (importante)
5. UI systems (básico)

**Code Architecture:**
- Composição sobre herança para blocos
- Signals para comunicação entre sistemas
- Resource management com pooling
- Modular design para extensibilidade

### PARA GAME DESIGNERS:
**Balance Sheet:**
- Grid size: 32px optimal para precisão
- Move speed: 100px/s para responsividade
- Snap threshold: 16px para tolerance
- Max blocks per level: 20 para clarity

**Tuning Guide:**
- Dificuldade progressiva por puzzle complexity
- Feedback visual immediate para ações
- Achievement unlock points: 25%, 50%, 75%, 100%

### PARA ARTISTS:
**Art Bible Priority:**
- Block sprites: 64x64px base size
- Color palette: High contrast para accessibility
- Animation: 8-12 frames para smoothness
- VFX: Particle systems para state changes

### PARA QA TESTERS:
**Critical Path Testing:**
1. Drag & drop precision em diferentes resolutions
2. Snap behavior consistency
3. Language ability cooldowns
4. Performance com 50+ blocks
5. Save/load game state

---

## NEXT STEPS - IMPLEMENTAÇÃO IMEDIATA

### Esta Semana (Sprint 1):
1. **Dia 1-2:** Setup Godot + core classes
2. **Dia 3-4:** LogicBlock base implementation
3. **Dia 5:** DragAndDrop system functional

### Próxima Semana (Sprint 2):
1. **Dia 1-2:** PlayerController + movement
2. **Dia 3-4:** Level 1 puzzle design
3. **Dia 5:** Language abilities prototype

### Sprint 3 (Week 3):
1. Polish e bug fixes
2. Performance optimization
3. Basic UI implementation
4. Alpha testing interno

---

**CONCLUSÃO:**
O Nível 1 block-based logic é tecnicamente viável com implementação em 3-4 semanas. A arquitetura modular facilita progressão incremental para níveis mais complexos. Focus em performance e user experience será crítico para sucesso do protótipo.

*Próximo milestone: Protótipo jogável completo do Nível 1 com todas as mecânicas core funcionando.*