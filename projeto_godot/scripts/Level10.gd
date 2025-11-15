# THE CORE DESCENT - NÍVEL 10: O ESTÚDIO DE JOGOS
# Arquivo: Level10.gd - Game Development: Unity, Unreal Engine, Game Design

extends Node2D
class_name Level10

# Configurações do nível
@export var level_name: String = "O Estúdio de Jogos"
@export var level_description: String = "Domine game engines e padrões de design para criar experiências épicas"
@export var target_moves: int = 44  # Número ideal de movimentos
@export var grid_width: int = 38
@export var grid_height: int = 32

# Referências aos sistemas
var game_manager: Node
var drag_system: DragAndDropSystem
var player: PlayerController
var ui_manager: Node
var ability_system: Node

# Estado do nível
enum LevelState { LOADING, PLAYING, COMPLETED, FAILED }
var current_state: LevelState = LevelState.LOADING

# Dados do nível
var start_position: Vector2i = Vector2i(2, 16)
var goal_position: Vector2i = Vector2i(35, 16)
var start_block: LogicBlock
var goal_block: LogicBlock

# Objetivo atual
var moves_used: int = 0
var blocks_placed: int = 0
var _object_pool_size: int = 10
var _resource_pool: Array = []
var level_timer: float = 0.0
var is_timer_running: bool = false
var ability_used_count: Dictionary = {}
var unity_projects: Array = []
var unreal_projects: Array = []
var godot_projects: Array = []
var game_systems: Array = []
var performance_metrics: Dictionary = {}
var game_design_patterns: Array = []
var asset_management: Dictionary = {}
var optimization_strategies: Array = []

# Puzzles disponíveis
var available_puzzles: Array[Dictionary] = []
var current_puzzle_index: int = 0

# UI Elements
var move_counter: Label
var timer_label: Label
var puzzle_info_label: Label
var progress_bar: ProgressBar
var game_engine_panel: Control
var performance_monitor: Control
var design_patterns_display: Control

# Sinais
signal level_completed
signal level_failed
signal puzzle_solved(puzzle_data: Dictionary)
signal move_made
signal ability_activated
signal unity_project_created
signal unreal_project_developed
signal godot_scene_built
signal game_design_pattern_implemented
signal performance_optimization_applied

# Puzzles do nível - Foco em Game Development
func initialize_puzzles():
    available_puzzles = [
        {
            "id": "unity_2d_3d_development",
            "title": "Desenvolvimento Unity",
            "description": "Crie jogos 2D/3D com Unity C# e sistemas de componentes",
            "target_moves": 28,
            "start_position": Vector2i(2, 8),
            "goal_position": Vector2i(16, 24),
            "blocks_required": 14,
            "concepts": ["Unity C#", "MonoBehaviour", "Prefab System", "Scene Management", "Input System", "Physics", "Animation", "UI System", "Asset Pipeline", "Lighting", "Shaders", "Audio", "Coroutines", "ScriptableObjects"],
            "mechanics": {
                "component_architecture": true,
                "prefab_instantiation": true,
                "scene_transitions": true,
                "physics_simulation": true,
                "ui_interaction": true,
                "animation_control": true,
                "audio_management": true,
                "asset_loading": true
            },
            "obstacles": [
                {"type": "performance_bottleneck", "position": Vector2i(6, 12), "cpu_usage": 85},
                {"type": "memory_leak", "position": Vector2i(9, 16), "leak_mb_per_second": 2.5},
                {"type": "asset_dependency", "position": Vector2i(12, 20), "missing_assets": ["Textures", "Audio"]},
                {"type": "physics_instability", "position": Vector2i(14, 14), "rigidbody_jitter": true}
            ],
            "unity_features": [
                {"name": "Unity Physics", "system": "PhysX", "optimization": "Broad-phase culling"},
                {"name": "UI Canvas", "render_mode": "Screen Space Overlay", "performance": "60fps"},
                {"name": "Animation System", "type": "Animator Controller", "blend_trees": true}
            ]
        },
        {
            "id": "unreal_blueprint_cpp",
            "title": "Desenvolvimento Unreal Engine",
            "description": "Desenvolva com Unreal C++ e Blueprints para alta performance",
            "target_moves": 32,
            "start_position": Vector2i(4, 26),
            "goal_position": Vector2i(20, 4),
            "blocks_required": 16,
            "concepts": ["Unreal C++", "Blueprint System", "Actor Classes", "Component System", "Level Streaming", "Material Editor", "UMG UI", "AI Behavior Trees", "Physics Simulation", "Particle Systems", "Post Processing", "Audio", "Input Binding", "Game Mode", "Pawn Classes", "Gameplay Framework"],
            "mechanics": {
                "blueprint_visual_programming": true,
                "cpp_performance": true,
                "actor_component_architecture": true,
                "level_streaming": true,
                "material_shading": true,
                "ai_behavior_trees": true,
                "particle_effects": true,
                "gameplay_framework": true
            },
            "obstacles": [
                {"type": "compilation_time", "position": Vector2i(8, 22), "build_minutes": 15},
                {"type": "blueprint_complexity", "position": Vector2i(12, 18), "node_count": 250},
                {"type": "material_shader_cost", "position": Vector2i(15, 12), "instructions_per_pixel": 150},
                {"type": "ai_pathfinding_cost", "position": Vector2i(17, 8), "nodes_per_frame": 5000}
            ],
            "unreal_features": [
                {"name": "Unreal Engine 5", "rendering": "Nanite", "lighting": "Lumen"},
                {"name": "Blueprint", "type": "Visual Scripting", "performance": "Runtime C++"},
                {"name": "AI System", "type": "Behavior Trees", "navigation": "NavMesh"}
            ]
        },
        {
            "id": "godot_gdscript_scene_tree",
            "title": "Desenvolvimento Godot",
            "description": "Construa jogos com Godot GDScript e sistema de cenas",
            "target_moves": 36,
            "start_position": Vector2i(18, 2),
            "goal_position": Vector2i(34, 24),
            "blocks_required": 18,
            "concepts": ["GDScript", "Scene Tree", "Node System", "Signals", "Resource Management", "Collision Detection", "AnimationPlayer", "Tween", "State Machines", "TileMap", "Path2D", "Control Nodes", "Shaders", "Audio Streams", "Input Map", "Viewport", "CanvasItem", "Physics"],
            "mechanics": {
                "scene_hierarchy": true,
                "signal_system": true,
                "gdscript_programming": true,
                "node_interaction": true,
                "animation_control": true,
                "physics_simulation": true,
                "resource_management": true,
                "viewport_rendering": true
            },
            "obstacles": [
                {"type": "signal_dependency", "position": Vector2i(22, 6), "signal_chain_depth": 8},
                {"type": "scene_nesting", "position": Vector2i(25, 12), "nested_levels": 5},
                {"type": "gdscript_performance", "position": Vector2i(28, 18), "script_calls_per_frame": 1000},
                {"type": "node_deletion_order", "position": Vector2i(30, 20), "cleanup_complexity": "high"}
            ],
            "godot_features": [
                {"name": "Godot 4.0", "rendering": "Vulkan", "scripting": "GDScript"},
                {"name": "Scene System", "type": "PackedScenes", "instancing": true},
                {"name": "Physics", "type": "2D/3D Physics", "engine": "Custom"}
            ]
        },
        {
            "id": "game_design_patterns_ecs",
            "title": "Game Design Patterns ECS",
            "description": "Implemente padrões de design de jogos com ECS (Entity Component System)",
            "target_moves": 40,
            "start_position": Vector2i(6, 28),
            "goal_position": Vector2i(24, 4),
            "blocks_required": 20,
            "concepts": ["Entity Component System", "Data-Oriented Design", "Component Pooling", "System Architecture", "Memory Layout", "Cache Optimization", "Job System", "Command Pattern", "Observer Pattern", "Factory Pattern", "Object Pool", "Strategy Pattern", "State Machine", "Event System", "Service Locator", "Dependency Injection", "Component Architecture", "Performance Profiling"],
            "mechanics": {
                "entity_management": true,
                "component_data": true,
                "system_processing": true,
                "memory_optimization": true,
                "cache_friendly": true,
                "parallel_execution": true,
                "data_encapsulation": true,
                "pattern_implementation": true
            },
            "obstacles": [
                {"type": "cache_miss_rate", "position": Vector2i(10, 24), "miss_percentage": 25},
                {"type": "entity_count", "position": Vector2i(14, 18), "total_entities": 10000},
                {"type": "component_bloat", "position": Vector2i(18, 12), "components_per_entity": 15},
                {"type": "system_dependency", "position": Vector2i(21, 8), "system_chain_depth": 7}
            ],
            "ecs_frameworks": [
                {"name": "Unity DOTS", "version": "1.0", "performance": "High"},
                {"name": "Unreal ECS", "integration": "Component System", "scalability": "Large"},
                {"name": "Custom ECS", "control": "Full", "optimization": "Maximum"}
            ]
        },
        {
            "id": "game_mechanics_state_machines",
            "title": "Mecânicas e State Machines",
            "description": "Desenvolva mecânicas de jogo com state machines e behavior trees",
            "target_moves": 42,
            "start_position": Vector2i(26, 6),
            "goal_position": Vector2i(36, 26),
            "blocks_required": 22,
            "concepts": ["State Machines", "Behavior Trees", "Decision Making", "Game Loop", "Update Cycles", "Input Processing", "Game Rules", "Level Design", "Player Progression", "Power-ups", "Boss Mechanics", "AI State Transitions", "Animation States", "Game Physics", "Collision Handling", "Score System", "Save/Load", "Difficulty Scaling", "Camera Control", "Audio States", "UI State Management", "Network States"],
            "mechanics": {
                "state_transitions": true,
                "behavior_decisions": true,
                "game_rule_enforcement": true,
                "player_feedback": true,
                "ai_state_management": true,
                "animation_sync": true,
                "progression_logic": true,
                "difficulty_adaptation": true
            },
            "obstacles": [
                {"type": "state_explosion", "position": Vector2i(28, 10), "total_states": 200},
                {"type": "transition_spaghetti", "position": Vector2i(30, 16), "complexity_rating": "extreme"},
                {"type": "ai_decision_depth", "position": Vector2i(32, 20), "decision_trees": 50},
                {"type": "animation_sync_issues", "position": Vector2i(34, 24), "desync_percentage": 15}
            ],
            "state_machine_types": [
                {"type": "Hierarchical FSM", "usage": "Character AI", "complexity": "High"},
                {"type": "Behavior Trees", "usage": "Enemy AI", "flexibility": "Very High"},
                {"type": "Utility AI", "usage": "NPC Behavior", "adaptability": "Dynamic"}
            ]
        },
        {
            "id": "performance_optimization_pooling",
            "title": "Otimização e Object Pooling",
            "description": "Otimize performance com object pooling e profiling avançado",
            "target_moves": 44,
            "start_position": Vector2i(8, 4),
            "goal_position": Vector2i(32, 28),
            "blocks_required": 24,
            "concepts": ["Object Pooling", "Memory Management", "Garbage Collection", "Profiling Tools", "Performance Metrics", "CPU Optimization", "GPU Optimization", "LOD Systems", "Occlusion Culling", "Texture Compression", "Audio Optimization", "Network Optimization", "Asset Streaming", "Level Loading", "Save System", "Cache Strategies", "Multi-threading", "Job Scheduling", "Renderer Optimization", "Physics Optimization", "Animation Optimization", "UI Optimization", "Shader Optimization", "Debug Tools"],
            "mechanics": {
                "object_reuse": true,
                "memory_allocation": true,
                "performance_profiling": true,
                "culling_optimization": true,
                "lod_implementation": true,
                "streaming_management": true,
                "multi_threading": true,
                "renderer_optimization": true
            },
            "obstacles": [
                {"type": "garbage_collection", "position": Vector2i(12, 8), "stutter_duration_ms": 15},
                {"type": "memory_fragmentation", "position": Vector2i(16, 16), "fragmentation_percentage": 35},
                {"type": "cpu_bottleneck", "position": Vector2i(20, 22), "cpu_usage": 95},
                {"type": "gpu_memory_full", "position": Vector2i(25, 26), "vram_usage_percent": 98},
                {"type": "draw_call_overhead", "position": Vector2i(28, 12), "calls_per_frame": 2000},
                {"type": "physics_calculation_cost", "position": Vector2i(30, 18), "constraints": 5000}
            ],
            "optimization_techniques": [
                {"name": "Object Pool", "savings": "80% allocation reduction", "usage": "Bullets, Particles"},
                {"name": "LOD System", "savings": "50% poly reduction", "usage": "Distant Objects"},
                {"name": "Occlusion Culling", "savings": "40% draw call reduction", "usage": "Hidden Geometry"},
                {"name": "Texture Streaming", "savings": "60% VRAM usage", "usage": "Large Worlds"}
            ]
        }
    ]

func _ready():
    _initialize_concept_cache()
    _initialize_object_pool()
    print("Level 10: O Estúdio de Jogos - Iniciando...")
    
    # Inicializar puzzles
    initialize_puzzles()
    
    # Configurar timer
    level_timer = 0.0
    is_timer_running = true
    
    # Configurar estado inicial
    current_state = LevelState.LOADING
    
    # Configurar blocos do tabuleiro
    setup_grid()
    setup_blocks()
    
    # Conectar sinais
    setup_signals()
    
    # Inicializar UI
    setup_ui()
    
    # Marcar como pronto para iniciar
    current_state = LevelState.PLAYING
    print("Level 10 pronto para jogar - Estúdio de Jogos!")

func setup_grid():
    """Configura a grade do tabuleiro de game development"""
    # Criar blocos de início e fim
    start_block = create_logic_block(start_position, "start", "Início do Desenvolvimento")
    goal_block = create_logic_block(goal_position, "goal", "Jogo Lançado com Sucesso")
    
    # Adicionar obstáculos baseados no puzzle atual
    var current_puzzle = available_puzzles[current_puzzle_index]
    setup_puzzle_obstacles(current_puzzle.get("obstacles", []))

func setup_blocks():
    """Configura os blocos lógicos no tabuleiro de game development"""
    var current_puzzle = available_puzzles[current_puzzle_index]
    var concepts = current_puzzle.get("concepts", [])
    
    # Adicionar blocos para cada conceito
    for concept in concepts:
        var position = get_random_valid_position()
        create_logic_block(position, "concept", concept)
    
    # Adicionar blocos específicos de game development
    add_game_dev_blocks()

func create_logic_block(position: Vector2i, block_type: String, data: String) -> LogicBlock:
    """Cria um bloco lógico na posição especificada"""
    var block = LogicBlock.new()
    block.position = position
    block.block_type = block_type
    block.data = data
    block.set("custom_data", {
        "level": 10,
        "concept": data,
        "game_dev_context": true,
        "engine_compatibility": get_engine_compatibility(data),
        "complexity_level": get_complexity_level(data),
        "performance_impact": get_performance_impact(data),
        "implementation_effort": get_implementation_effort(data)
    })
    
    add_child(block)
    return block

func add_game_dev_blocks():
    """Adiciona blocos específicos de game development"""
    var game_engines = ["Unity", "Unreal Engine", "Godot", "GameMaker", "Construct", "RPG Maker"]
    var programming_languages = ["C#", "C++", "GDScript", "Visual Scripting", "Blueprints", "Lua"]
    var game_patterns = ["ECS", "State Machines", "Observer Pattern", "Factory Pattern", "Object Pool", "Component Pattern"]
    
    for engine in game_engines:
        var position = get_random_valid_position()
        create_logic_block(position, "game_engine", engine)
    
    for language in programming_languages:
        var position = get_random_valid_position()
        create_logic_block(position, "programming_language", language)
    
    for pattern in game_patterns:
        var position = get_random_valid_position()
        create_logic_block(position, "design_pattern", pattern)

func get_engine_compatibility(data: String) -> Array:
    """Retorna compatibilidade com engines de desenvolvimento"""
    var compatibility_map = {
        "Unity C#": ["Unity", "MonoGame"],
        "Unreal C++": ["Unreal Engine"],
        "GDScript": ["Godot"],
        "Blueprint System": ["Unreal Engine"],
        "ECS": ["Unity DOTS", "Custom Frameworks"],
        "State Machines": ["All Engines"],
        "Object Pooling": ["All Engines"],
        "Animation Player": ["Unity", "Godot", "Custom"],
        "Physics Simulation": ["All Engines"],
        "Shader Programming": ["Unity", "Unreal", "Godot"]
    }
    return compatibility_map.get(data, ["Generic"])

func get_complexity_level(data: String) -> String:
    """Retorna o nível de complexidade do conceito"""
    var complexity_map = {
        "Unity C#": "medium",
        "Unreal C++": "high",
        "GDScript": "low",
        "Blueprint System": "medium",
        "ECS": "very_high",
        "State Machines": "medium",
        "Object Pooling": "medium",
        "Shader Programming": "very_high",
        "Physics Simulation": "high",
        "AI Behavior Trees": "high"
    }
    return complexity_map.get(data, "medium")

func get_performance_impact(data: String) -> String:
    """Retorna o impacto na performance"""
    var performance_map = {
        "Unity C#": "low",
        "Unreal C++": "low",
        "GDScript": "medium",
        "Blueprint System": "medium",
        "ECS": "high_positive",
        "State Machines": "low_positive",
        "Object Pooling": "high_positive",
        "Shader Programming": "high_positive",
        "Physics Simulation": "high",
        "AI Behavior Trees": "medium_positive"
    }
    return performance_map.get(data, "neutral")

func get_implementation_effort(data: String) -> int:
    """Retorna o esforço de implementação (1-10)"""
    var effort_map = {
        "Unity C#": 5,
        "Unreal C++": 7,
        "GDScript": 3,
        "Blueprint System": 4,
        "ECS": 8,
        "State Machines": 5,
        "Object Pooling": 6,
        "Shader Programming": 9,
        "Physics Simulation": 7,
        "AI Behavior Trees": 8
    }
    return effort_map.get(data, 5)

func setup_puzzle_obstacles(obstacles: Array):
    """Configura obstáculos específicos do puzzle de game development"""
    for obstacle in obstacles:
        var obstacle_node = create_game_dev_obstacle(obstacle)
        add_child(obstacle_node)

func create_game_dev_obstacle(obstacle_data: Dictionary) -> Node:
    """Cria um obstáculo específico de game development"""
    var obstacle_type = obstacle_data.get("type", "generic")
    var position = obstacle_data.get("position", Vector2i(0, 0))
    var obstacle = Node2D.new()
    obstacle.position = position * 32
    
    # Configurar propriedades específicas de game development
    obstacle.set("obstacle_type", obstacle_type)
    obstacle.set("obstacle_data", obstacle_data)
    obstacle.set("game_dev_domain", get_game_dev_domain(obstacle_type))
    obstacle.set("development_challenge", get_development_challenge(obstacle_type))
    
    return obstacle

func get_game_dev_domain(obstacle_type: String) -> String:
    """Retorna o domínio de game development do obstáculo"""
    var domain_map = {
        "performance_bottleneck": "Optimization",
        "memory_leak": "Memory Management",
        "compilation_time": "Build Pipeline",
        "blueprint_complexity": "Visual Programming",
        "signal_dependency": "Event System",
        "cache_miss_rate": "Data Architecture",
        "state_explosion": "State Management",
        "garbage_collection": "Performance",
        "cpu_bottleneck": "CPU Optimization",
        "draw_call_overhead": "Rendering Optimization"
    }
    return domain_map.get(obstacle_type, "General")

func get_development_challenge(obstacle_type: String) -> String:
    """Retorna o tipo de desafio de desenvolvimento"""
    var challenge_map = {
        "performance_bottleneck": "optimization",
        "memory_leak": "debugging",
        "compilation_time": "build_optimization",
        "blueprint_complexity": "code_maintainability",
        "signal_dependency": "architecture_design",
        "cache_miss_rate": "data_locality",
        "state_explosion": "complexity_management",
        "garbage_collection": "memory_management",
        "cpu_bottleneck": "profiling",
        "draw_call_overhead": "rendering_optimization"
    }
    return challenge_map.get(obstacle_type, "unknown")

func setup_signals():
    """Configura as conexões de sinais"""
    if drag_system:
        drag_system.block_dropped.connect(_on_block_dropped)
    
    if player:
        player.move_completed.connect(_on_player_move_completed)
    
    if game_manager:
        game_manager.pause_requested.connect(_on_pause_requested)

func setup_ui():
    """Configura a interface do usuário para game development"""
    move_counter = Label.new()
    timer_label = Label.new()
    puzzle_info_label = Label.new()
    progress_bar = ProgressBar.new()
    game_engine_panel = Control.new()
    performance_monitor = Control.new()
    design_patterns_display = Control.new()

func _process(delta: float):
    """Atualiza o estado do nível de game development"""
    if is_timer_running and current_state == LevelState.PLAYING:
        level_timer += delta
        update_timer_display()
    
    # Verificar métricas específicas de game development
    check_performance_metrics()
    check_development_efficiency()
    check_game_mechanics()
    check_optimization_status()
    
    # Verificar condições de vitória/derrota
    check_level_completion()
    check_level_failure()

func check_performance_metrics():
    """Verifica métricas de performance específicas do desenvolvimento de jogos"""
    var current_puzzle = available_puzzles[current_puzzle_index]
    var puzzle_id = current_puzzle.get("id", "")
    
    match puzzle_id:
        "unity_2d_3d_development":
            check_unity_performance()
        "unreal_blueprint_cpp":
            check_unreal_performance()
        "godot_gdscript_scene_tree":
            check_godot_performance()
        "game_design_patterns_ecs":
            check_ecs_performance()
        "game_mechanics_state_machines":
            check_state_machine_performance()
        "performance_optimization_pooling":
            check_optimization_effectiveness()

func check_unity_performance():
    """Verifica performance específica do Unity"""
    var frame_rate = 60  # FPS simulado
    var memory_usage = moves_used * 2.5  # MB simulado
    var cpu_usage = 70 + (moves_used * 0.5)  # % simulado
    
    if frame_rate < 30:
        print("Performance crítica: %.0f FPS (abaixo do mínimo aceitável)" % frame_rate)
    
    if memory_usage > 512:
        print("Uso de memória elevado: %.1f MB" % memory_usage)
    
    if cpu_usage > 85:
        print("Alto uso de CPU: %.1f%%" % cpu_usage)

func check_unreal_performance():
    """Verifica performance específica do Unreal Engine"""
    var compile_time = moves_used * 0.3  # minutos simulado
    var blueprint_nodes = moves_used * 2  # nós simulado
    var material_cost = moves_used * 5  # instruções por pixel simulado
    
    if compile_time > 20:
        print("Tempo de compilação elevado: %.1f minutos" % compile_time)
    
    if blueprint_nodes > 500:
        print("Complexidade de Blueprint alta: %.0f nós" % blueprint_nodes)
    
    if material_cost > 100:
        print("Custo de material elevado: %.0f instruções/pixel" % material_cost)

func check_godot_performance():
    """Verifica performance específica do Godot"""
    var signal_depth = min(moves_used / 3, 10)  # profundidade de sinais
    var scene_nesting = min(moves_used / 4, 8)  # níveis de aninhamento
    var script_calls = moves_used * 20  # chamadas de script por frame
    
    if signal_depth > 8:
        print("Profundidade de sinais elevada: %d níveis" % signal_depth)
    
    if scene_nesting > 6:
        print("Aninhamento de cenas profundo: %d níveis" % scene_nesting)
    
    if script_calls > 1000:
        print("Muitas chamadas de script: %.0f por frame" % script_calls)

func check_ecs_performance():
    """Verifica performance do ECS"""
    var entity_count = moves_used * 50  # entidades simuladas
    var cache_miss_rate = min(moves_used * 0.5, 40)  # % de cache miss
    var system_chain_depth = min(moves_used / 10, 8)  # profundidade de sistemas
    
    if entity_count > 10000:
        print("Muitas entidades: %.0f (pode afetar performance)" % entity_count)
    
    if cache_miss_rate > 30:
        print("Taxa de cache miss alta: %.1f%%" % cache_miss_rate)
    
    if system_chain_depth > 6:
        print("Cadeia de sistemas longa: %d sistemas" % system_chain_depth)

func check_state_machine_performance():
    """Verifica performance de state machines"""
    var total_states = moves_used * 3  # estados totais
    var transition_complexity = moves_used * 0.4  # complexidade de transição
    var ai_decisions = moves_used * 5  # decisões de IA por frame
    
    if total_states > 200:
        print("Explosão de estados: %.0f estados totais" % total_states)
    
    if transition_complexity > 8:
        print("Complexidade de transição elevada: %.1f" % transition_complexity)
    
    if ai_decisions > 300:
        print("Muitas decisões de IA: %.0f por frame" % ai_decisions)

func check_optimization_effectiveness():
    """Verifica efetividade das otimizações"""
    var gc_stutters = max(0, moves_used - 35) * 0.1  # stutters de garbage collection
    var memory_fragmentation = min(moves_used * 0.8, 50)  # % de fragmentação
    var draw_calls = moves_used * 15  # draw calls por frame
    var physics_constraints = moves_used * 10  # restrições de física
    
    if gc_stutters > 10:
        print("Muitos stutters de GC: %.1f ms de travamento" % gc_stutters)
    
    if memory_fragmentation > 40:
        print("Fragmentação de memória alta: %.1f%%" % memory_fragmentation)
    
    if draw_calls > 1500:
        print("Muitos draw calls: %.0f por frame" % draw_calls)
    
    if physics_constraints > 4000:
        print("Muitas restrições de física: %.0f" % physics_constraints)

func check_development_efficiency():
    """Verifica eficiência do desenvolvimento"""
    var current_puzzle = available_puzzles[current_puzzle_index]
    var target_moves_puzzle = current_puzzle.get("target_moves", 30)
    var efficiency_ratio = float(moves_used) / float(target_moves_puzzle)
    
    if efficiency_ratio > 1.5:
        print("Eficiência baixa: %.2fx o movimento alvo" % efficiency_ratio)
    elif efficiency_ratio < 0.8:
        print("Excelente eficiência: %.2fx o movimento alvo" % efficiency_ratio)

func check_game_mechanics():
    """Verifica mecânicas específicas de jogo"""
    var current_puzzle = available_puzzles[current_puzzle_index]
    var mechanics = current_puzzle.get("mechanics", {})
    
    # Verificar implementação das mecânicas principais
    var implemented_mechanics = 0
    var total_mechanics = mechanics.size()
    
    for mechanic in mechanics.keys():
        if mechanics[mechanic]:
            implemented_mechanics += 1
    
    var completion_percentage = float(implemented_mechanics) / float(total_mechanics)
    
    if completion_percentage >= 0.8:
        print("Mecânicas bem implementadas: %.1f%% completas" % (completion_percentage * 100))

func check_optimization_status():
    """Verifica status de otimizações"""
    var optimization_techniques = [
        "object_pooling", "memory_management", "profiling", "culling_optimization",
        "lod_implementation", "streaming_management", "multi_threading", "renderer_optimization"
    ]
    
    var implemented_optimizations = 0
    
    for technique in optimization_techniques:
        # Simular verificação de implementação baseada nos movimentos
        if moves_used > 10 + (implemented_optimizations * 5):
            implemented_optimizations += 1
    
    var optimization_score = (float(implemented_optimizations) / float(optimization_techniques.size())) * 100
    
    if optimization_score > 70:
        print("Otimização avançada: %.1f%% das técnicas implementadas" % optimization_score)

func update_timer_display():
    """Atualiza a exibição do timer com contexto de game development"""
    var minutes = int(level_timer / 60)
    var seconds = int(level_timer % 60)
    var current_engine = get_current_engine_focus()
    var development_phase = get_current_development_phase()
    
    if timer_label:
        timer_label.text = "Tempo: %02d:%02d | %s | %s | Movimentos: %d" % [
            minutes, seconds, current_engine, development_phase, moves_used
        ]

func get_current_engine_focus() -> String:
    """Retorna o foco de engine atual"""
    var engines = ["Unity", "Unreal", "Godot", "Patterns", "Mechanics", "Optimization"]
    var index = min(current_puzzle_index, engines.size() - 1)
    return engines[index]

func get_current_development_phase() -> String:
    """Retorna a fase de desenvolvimento atual"""
    var phases = ["Setup", "Core Systems", "Advanced Features", "Optimization", "Polish", "Release"]
    var index = min(current_puzzle_index, phases.size() - 1)
    return phases[index]

func check_level_completion():
    """Verifica se o nível foi completado"""
    if current_puzzle_index >= available_puzzles.size():
        current_state = LevelState.COMPLETED
        is_timer_running = false
        emit_signal("level_completed")
        print("Level 10 concluído! Estúdio de jogos dominado com sucesso!")
        print("Você criou jogos épicos usando as melhores engines e padrões!")
        return
    
    var current_puzzle = available_puzzles[current_puzzle_index]
    if is_puzzle_solved(current_puzzle):
        current_puzzle_index += 1
        if current_puzzle_index < available_puzzles.size():
            load_next_puzzle()
        emit_signal("puzzle_solved", current_puzzle)

func is_puzzle_solved(puzzle: Dictionary) -> bool:
    """Verifica se um puzzle de game development foi resolvido"""
    var mechanics = puzzle.get("mechanics", {})
    var performance_criteria = check_game_dev_performance(puzzle)
    var architecture_criteria = check_architecture_quality(puzzle)
    
    var implemented_count = 0
    var required_count = mechanics.size()
    
    # Verificar mechanics implementados
    for mechanic in mechanics.keys():
        if mechanics[mechanic] == true:
            implemented_count += 1
    
    # Verificar critérios específicos de game development
    var performance_met = performance_criteria
    var architecture_met = architecture_criteria
    
    return (implemented_count >= required_count * 0.8) and performance_met and architecture_met

func check_game_dev_performance(puzzle: Dictionary) -> bool:
    """Verifica critérios de performance específicos de game development"""
    var puzzle_id = puzzle.get("id", "")
    var efficiency_ratio = float(moves_used) / float(puzzle.get("target_moves", 30))
    
    # Critérios específicos por engine/tecnologia
    match puzzle_id:
        "unity_2d_3d_development":
            return efficiency_ratio <= 1.4 and check_unity_quality_metrics()
        "unreal_blueprint_cpp":
            return efficiency_ratio <= 1.3 and check_unreal_quality_metrics()
        "godot_gdscript_scene_tree":
            return efficiency_ratio <= 1.5 and check_godot_quality_metrics()
        "game_design_patterns_ecs":
            return efficiency_ratio <= 1.2 and check_ecs_quality_metrics()
        "game_mechanics_state_machines":
            return efficiency_ratio <= 1.4 and check_state_machine_quality()
        "performance_optimization_pooling":
            return efficiency_ratio <= 1.3 and check_optimization_quality()
        _:
            return efficiency_ratio <= 1.5

func check_architecture_quality(puzzle: Dictionary) -> bool:
    """Verifica qualidade da arquitetura de desenvolvimento"""
    var puzzle_id = puzzle.get("id", "")
    var complexity_score = calculate_architecture_complexity()
    
    # Critérios de qualidade da arquitetura
    match puzzle_id:
        "unity_2d_3d_development":
            return complexity_score >= 70
        "unreal_blueprint_cpp":
            return complexity_score >= 75
        "godot_gdscript_scene_tree":
            return complexity_score >= 65
        "game_design_patterns_ecs":
            return complexity_score >= 80
        "game_mechanics_state_machines":
            return complexity_score >= 70
        "performance_optimization_pooling":
            return complexity_score >= 85
        _:
            return complexity_score >= 60

func check_unity_quality_metrics() -> bool:
    """Verifica métricas de qualidade do Unity"""
    # Simular verificações específicas do Unity
    var component_count = min(moves_used / 2, 20)
    var prefab_usage = moves_used > 15
    var scene_management = moves_used > 20
    
    return component_count >= 8 and prefab_usage and scene_management

func check_unreal_quality_metrics() -> bool:
    """Verifica métricas de qualidade do Unreal Engine"""
    # Simular verificações específicas do Unreal
    var blueprint_usage = moves_used > 12
    var cpp_integration = moves_used > 18
    var actor_architecture = moves_used > 25
    
    return blueprint_usage and cpp_integration and actor_architecture

func check_godot_quality_metrics() -> bool:
    """Verifica métricas de qualidade do Godot"""
    # Simular verificações específicas do Godot
    var signal_usage = moves_used > 10
    var scene_organization = moves_used > 16
    var gdscript_optimization = moves_used > 22
    
    return signal_usage and scene_organization and gdscript_optimization

func check_ecs_quality_metrics() -> bool:
    """Verifica métricas de qualidade do ECS"""
    # Simular verificações específicas do ECS
    var entity_design = moves_used > 20
    var component_separation = moves_used > 28
    var system_organization = moves_used > 35
    
    return entity_design and component_separation and system_organization

func check_state_machine_quality() -> bool:
    """Verifica qualidade de state machines"""
    # Simular verificações de state machines
    var state_organization = moves_used > 15
    var transition_logic = moves_used > 25
    var behavior_integration = moves_used > 35
    
    return state_organization and transition_logic and behavior_integration

func check_optimization_quality() -> bool:
    """Verifica qualidade das otimizações"""
    # Simular verificações de otimização
    var pooling_implementation = moves_used > 18
    var profiling_applied = moves_used > 28
    var performance_optimization = moves_used > 38
    
    return pooling_implementation and profiling_applied and performance_optimization

func calculate_architecture_complexity() -> float:
    """Calcula score de complexidade da arquitetura"""
    var base_score = 50.0
    var pattern_bonus = current_puzzle_index * 8.0
    var implementation_bonus = min(float(moves_used), 30.0) * 1.2
    return min(base_score + pattern_bonus + implementation_bonus, 100.0)

func load_next_puzzle():
    """Carrega o próximo puzzle de game development"""
    if current_puzzle_index >= available_puzzles.size():
        return
    
    var next_puzzle = available_puzzles[current_puzzle_index]
    
    # Resetar estado
    moves_used = 0
    blocks_placed = 0
    
    # Limpar sistemas anteriores
    clear_game_dev_systems()
    
    # Atualizar UI
    update_puzzle_display(next_puzzle)
    
    # Configurar novo puzzle
    setup_puzzle_obstacles(next_puzzle.get("obstacles", []))

func clear_game_dev_systems():
    """Limpa sistemas de game development anteriores"""
    unity_projects.clear()
    unreal_projects.clear()
    godot_projects.clear()
    game_systems.clear()

func update_puzzle_display(puzzle: Dictionary):
    """Atualiza a exibição do puzzle de game development"""
    var puzzle_title = puzzle.get("title", "")
    var puzzle_desc = puzzle.get("description", "")
    var engine_focus = get_engine_focus_from_puzzle(puzzle.get("id", ""))
    var development_progress = calculate_development_progress()
    
    if puzzle_info_label:
        puzzle_info_label.text = "%s: %s [Engine: %s | Progresso: %d%%]" % [
            puzzle_title, puzzle_desc, engine_focus, development_progress
        ]
    
    if progress_bar:
        var progress = float(current_puzzle_index) / float(available_puzzles.size())
        progress_bar.value = progress * 100

func get_engine_focus_from_puzzle(puzzle_id: String) -> String:
    """Retorna o foco de engine baseado no puzzle"""
    match puzzle_id:
        "unity_2d_3d_development":
            return "Unity"
        "unreal_blueprint_cpp":
            return "Unreal Engine"
        "godot_gdscript_scene_tree":
            return "Godot"
        "game_design_patterns_ecs":
            return "Multi-Engine"
        "game_mechanics_state_machines":
            return "Architecture"
        "performance_optimization_pooling":
            return "Optimization"
        _:
            return "Generic"

func calculate_development_progress() -> int:
    """Calcula progresso do desenvolvimento"""
    var base_progress = current_puzzle_index * 16
    var efficiency_bonus = min(moves_used, 20) * 2
    var complexity_bonus = min(current_puzzle_index * 3, 15)
    return min(base_progress + efficiency_bonus + complexity_bonus, 95)

# Manipuladores de eventos
func _on_block_dropped(block: LogicBlock, position: Vector2i):
    """Manipula quando um bloco é solto no contexto de game development"""
    blocks_placed += 1
    moves_used += 1
    emit_signal("move_made")
    
    # Validação específica para game development
    var current_puzzle = available_puzzles[current_puzzle_index]
    validate_game_dev_block_placement(block, current_puzzle)
    
    # Emitir sinais específicos baseados na engine/tecnologia
    if is_unity_block(block):
        emit_signal("unity_project_created")
    elif is_unreal_block(block):
        emit_signal("unreal_project_developed")
    elif is_godot_block(block):
        emit_signal("godot_scene_built")
    elif is_pattern_block(block):
        emit_signal("game_design_pattern_implemented")
    elif is_optimization_block(block):
        emit_signal("performance_optimization_applied")

func _on_player_move_completed():
    """Manipula quando o jogador completa um movimento"""
    emit_signal("move_made")
    check_level_completion()

func _on_pause_requested():
    """Manipula pedidos de pausa"""
    is_timer_running = !is_timer_running

func validate_game_dev_block_placement(block: LogicBlock, puzzle: Dictionary):
    """Valida se o bloco foi colocado corretamente no contexto de game development"""
    var concepts = puzzle.get("concepts", [])
    var block_concept = block.get("custom_data", {}).get("concept", "")
    var block_type = block.get("block_type", "")
    var complexity_level = block.get("custom_data", {}).get("complexity_level", "medium")
    
    # Verificar relevância do conceito
    var is_valid_concept = concepts.has(block_concept) or "generic" in concepts
    
    # Verificar complexidade adequada para o puzzle
    var puzzle_complexity = get_puzzle_complexity_level(puzzle.get("id", ""))
    var is_complexity_appropriate = is_complexity_level_compatible(complexity_level, puzzle_complexity)
    
    if not is_valid_concept or not is_complexity_appropriate:
        block.highlight_as_invalid()
        print("Aviso: Bloco pode não ser adequado para este tipo de desenvolvimento")

func get_puzzle_complexity_level(puzzle_id: String) -> String:
    """Retorna o nível de complexidade esperado para o puzzle"""
    match puzzle_id:
        "unity_2d_3d_development":
            return "medium"
        "unreal_blueprint_cpp":
            return "high"
        "godot_gdscript_scene_tree":
            return "low"
        "game_design_patterns_ecs":
            return "very_high"
        "game_mechanics_state_machines":
            return "medium"
        "performance_optimization_pooling":
            return "very_high"
        _:
            return "medium"

func is_complexity_level_compatible(block_complexity: String, puzzle_complexity: String) -> bool:
    """Verifica compatibilidade entre níveis de complexidade"""
    var compatibility_matrix = {
        "low": ["low", "medium"],
        "medium": ["medium", "high"],
        "high": ["high", "very_high"],
        "very_high": ["very_high"]
    }
    
    var compatible_levels = compatibility_matrix.get(block_complexity, [])
    return compatible_levels.has(puzzle_complexity)

func is_unity_block(block: LogicBlock) -> bool:
    """Verifica se o bloco é relacionado ao Unity"""
    var unity_concepts = ["unity", "c#", "monobehaviour", "prefab", "physics", "animation", "ui", "shader"]
    var block_concept = block.get("custom_data", {}).get("concept", "").to_lower()
    
    for concept in unity_concepts:
        if concept in block_concept:
            return true
    return false

func is_unreal_block(block: LogicBlock) -> bool:
    """Verifica se o bloco é relacionado ao Unreal Engine"""
    var unreal_concepts = ["unreal", "blueprint", "cpp", "actor", "component", "material", "ai", "physics"]
    var block_concept = block.get("custom_data", {}).get("concept", "").to_lower()
    
    for concept in unreal_concepts:
        if concept in block_concept:
            return true
    return false

func is_godot_block(block: LogicBlock) -> bool:
    """Verifica se o bloco é relacionado ao Godot"""
    var godot_concepts = ["godot", "gdscript", "scene", "node", "signal", "resource", "viewport", "canvas"]
    var block_concept = block.get("custom_data", {}).get("concept", "").to_lower()
    
    for concept in godot_concepts:
        if concept in block_concept:
            return true
    return false

func is_pattern_block(block: LogicBlock) -> bool:
    """Verifica se o bloco é relacionado a design patterns"""
    var pattern_concepts = ["ecs", "state machine", "observer", "factory", "pool", "strategy", "command", "pattern"]
    var block_concept = block.get("custom_data", {}).get("concept", "").to_lower()
    
    for concept in pattern_concepts:
        if concept in block_concept:
            return true
    return false

func is_optimization_block(block: LogicBlock) -> bool:
    """Verifica se o bloco é relacionado a otimização"""
    var optimization_concepts = ["optimization", "pooling", "culling", "lod", "profiling", "memory", "cache", "performance"]
    var block_concept = block.get("custom_data", {}).get("concept", "").to_lower()
    
    for concept in optimization_concepts:
        if concept in block_concept:
            return true
    return false

# Funções utilitárias
func get_random_valid_position() -> Vector2i:
    """Retorna uma posição válida aleatória no tabuleiro de game development"""
    var attempts = 0
    var max_attempts = 100
    
    while attempts < max_attempts:
        var x = randi_range(1, grid_width - 2)
        var y = randi_range(1, grid_height - 2)
        var position = Vector2i(x, y)
        
        if is_position_available(position):
            return position
        
        attempts += 1
    
    return Vector2i(6, 16)

func is_position_available(position: Vector2i) -> bool:
    """Verifica se uma posição está disponível"""
    # Implementar verificação de colisões para game development
    return true

# Funções de interface pública
func get_current_score() -> Dictionary:
    """Retorna a pontuação atual do nível de game development"""
    var time_score = max(0, 2000 - int(level_timer * 20))
    var efficiency_score = max(0, (target_moves * 120) - (moves_used * 15))
    var engine_mastery_score = calculate_engine_mastery_score()
    var pattern_implementation_score = calculate_pattern_score()
    var optimization_score = calculate_optimization_score()
    var performance_score = calculate_performance_score()
    
    return {
        "time_score": time_score,
        "efficiency_score": efficiency_score,
        "engine_mastery_score": engine_mastery_score,
        "pattern_implementation_score": pattern_implementation_score,
        "optimization_score": optimization_score,
        "performance_score": performance_score,
        "total_score": time_score + efficiency_score + engine_mastery_score + pattern_implementation_score + optimization_score + performance_score
    }

func calculate_engine_mastery_score() -> int:
    """Calcula pontuação baseada no domínio das engines"""
    var engine_scores = {"Unity": 0, "Unreal": 0, "Godot": 0, "Multi-Engine": 0}
    
    for i in range(current_puzzle_index):
        var puzzle = available_puzzles[i]
        var puzzle_id = puzzle.get("id", "")
        
        match puzzle_id:
            "unity_2d_3d_development":
                engine_scores["Unity"] += 100
            "unreal_blueprint_cpp":
                engine_scores["Unreal"] += 100
            "godot_gdscript_scene_tree":
                engine_scores["Godot"] += 100
            "game_design_patterns_ecs":
                engine_scores["Multi-Engine"] += 80
            "game_mechanics_state_machines":
                engine_scores["Multi-Engine"] += 60
            "performance_optimization_pooling":
                engine_scores["Multi-Engine"] += 40
    
    var total_engine_score = 0
    for engine in engine_scores.keys():
        total_engine_score += engine_scores[engine]
    
    return int(total_engine_score / 4)  # Média das engines

func calculate_pattern_score() -> int:
    """Calcula pontuação baseada na implementação de padrões"""
    var pattern_bonus = current_puzzle_index * 30
    var complexity_bonus = min(moves_used, 40) * 2
    var architecture_score = calculate_architecture_complexity()
    
    return int(pattern_bonus + complexity_bonus + architecture_score * 0.5)

func calculate_optimization_score() -> int:
    """Calcula pontuação baseada nas otimizações aplicadas"""
    var base_optimization = 60
    var technique_bonus = min(moves_used / 5, 8) * 25
    var performance_bonus = max(0, 100 - get_performance_penalty())
    
    return int(base_optimization + technique_bonus + performance_bonus)

func calculate_performance_score() -> int:
    """Calcula pontuação baseada na performance do jogo"""
    var frame_rate_score = min(60 * 10, 600)  # 60fps * 10 pontos por fps
    var memory_efficiency = max(0, 80 - (moves_used * 0.3))
    var cpu_efficiency = max(0, 90 - (moves_used * 0.5))
    
    return int((frame_rate_score + memory_efficiency + cpu_efficiency) / 3)

func get_performance_penalty() -> int:
    """Retorna penalidade de performance baseada no desenvolvimento"""
    var base_penalty = 10
    var complexity_penalty = current_puzzle_index * 5
    var efficiency_penalty = max(0, moves_used - (target_moves * 1.2)) * 2
    return int(base_penalty + complexity_penalty + efficiency_penalty)

func get_level_stats() -> Dictionary:
    """Retorna estatísticas detalhadas do nível de game development"""
    return {
        "level": 10,
        "name": level_name,
        "description": level_description,
        "target_moves": target_moves,
        "moves_used": moves_used,
        "puzzles_completed": current_puzzle_index,
        "total_puzzles": available_puzzles.size(),
        "time_elapsed": level_timer,
        "blocks_placed": blocks_placed,
        "engines_mastered": get_engines_mastered(),
        "patterns_implemented": get_patterns_implemented(),
        "optimizations_applied": get_optimizations_applied(),
        "performance_metrics": get_performance_metrics(),
        "development_achievements": get_development_achievements(),
        "game_projects": get_game_projects(),
        "architecture_quality": calculate_architecture_complexity(),
        "score": get_current_score()
    }

func get_engines_mastered() -> Dictionary:
    """Retorna engines que foram dominadas"""
    var engines = {
        "unity": {
            "version": "2023.1 LTS",
            "languages": ["C#"],
            "features": ["Physics", "UI", "Animation", "Shaders"],
            "projects": unity_projects.size()
        },
        "unreal_engine": {
            "version": "5.1",
            "languages": ["C++", "Blueprints"],
            "features": ["Nanite", "Lumen", "AI", "Materials"],
            "projects": unreal_projects.size()
        },
        "godot": {
            "version": "4.0",
            "languages": ["GDScript", "C#"],
            "features": ["2D/3D", "Signals", "Scene System"],
            "projects": godot_projects.size()
        }
    }
    
    # Adicionar engines baseadas no progresso
    if current_puzzle_index >= 0:
        engines["unity"]["mastery_level"] = "intermediate" if current_puzzle_index >= 1 else "basic"
    if current_puzzle_index >= 1:
        engines["unreal_engine"]["mastery_level"] = "intermediate" if current_puzzle_index >= 2 else "basic"
    if current_puzzle_index >= 2:
        engines["godot"]["mastery_level"] = "intermediate" if current_puzzle_index >= 3 else "basic"
    
    return engines

func get_patterns_implemented() -> Array:
    """Retorna padrões de design implementados"""
    var patterns = []
    
    # Adicionar padrões baseados no progresso nos puzzles
    for i in range(current_puzzle_index):
        var puzzle = available_puzzles[i]
        var title = puzzle.get("title", "")
        patterns.append("%s Implementation" % title)
    
    # Padrões específicos implementados
    if current_puzzle_index >= 3:
        patterns.append("Entity Component System (ECS)")
    
    if current_puzzle_index >= 4:
        patterns.append("State Machine Pattern")
        patterns.append("Behavior Tree Pattern")
    
    if current_puzzle_index >= 5:
        patterns.append("Object Pool Pattern")
        patterns.append("Memory Management Pattern")
    
    return patterns

func get_optimizations_applied() -> Array:
    """Retorna otimizações aplicadas"""
    var optimizations = []
    
    # Otimizações baseadas no progresso
    if current_puzzle_index >= 5:
        optimizations.append("Object Pooling Implementation")
        optimizations.append("Memory Management Optimization")
        optimizations.append("Performance Profiling")
        optimizations.append("Cache Optimization")
        optimizations.append("LOD System Implementation")
        optimizations.append("Occlusion Culling")
        optimizations.append("Multi-threading Optimization")
        optimizations.append("Renderer Optimization")
    
    return optimizations

func get_performance_metrics() -> Dictionary:
    """Retorna métricas de performance"""
    return {
        "average_fps": min(60, 30 + (current_puzzle_index * 5)),
        "memory_usage_mb": min(512, 100 + (moves_used * 8)),
        "cpu_usage_percent": min(80, 40 + (current_puzzle_index * 7)),
        "build_time_minutes": min(20, 5 + (current_puzzle_index * 2)),
        "optimization_level": "%d%%" % (40 + (current_puzzle_index * 10)),
        "pattern_efficiency": calculate_architecture_complexity()
    }

func get_development_achievements() -> Array:
    """Retorna conquistas de desenvolvimento alcançadas"""
    var achievements = []
    
    # Conquistas baseadas no progresso nos puzzles
    for i in range(current_puzzle_index):
        var puzzle = available_puzzles[i]
        var title = puzzle.get("title", "")
        achievements.append("Developer: %s Master" % title)
    
    # Conquistas especiais
    if moves_used <= target_moves * 0.8:
        achievements.append("Efficiency Master: Optimal Development")
    
    if current_puzzle_index >= 2:
        achievements.append("Multi-Engine Developer: Cross-Platform Expertise")
    
    if current_puzzle_index >= 5:
        achievements.append("Optimization Guru: Performance Specialist")
    
    if calculate_architecture_complexity() >= 80:
        achievements.append("Architecture Expert: Clean Code Master")
    
    return achievements

func get_game_projects() -> Array:
    """Retorna projetos de jogos criados"""
    var projects = []
    
    # Projetos simulados baseados no progresso
    if current_puzzle_index >= 0:
        projects.append({
            "name": "Platformer Game",
            "engine": "Unity",
            "status": "Completed",
            "features": ["Physics", "Animation", "UI"]
        })
    
    if current_puzzle_index >= 1:
        projects.append({
            "name": "First Person Shooter",
            "engine": "Unreal Engine",
            "status": "In Development",
            "features": ["Advanced Graphics", "AI", "Multiplayer"]
        })
    
    if current_puzzle_index >= 2:
        projects.append({
            "name": "2D Pixel Adventure",
            "engine": "Godot",
            "status": "Prototype",
            "features": ["Scene Management", "Signals", "GDScript"]
        })
    
    if current_puzzle_index >= 3:
        projects.append({
            "name": "ECS-Based Game Engine",
            "engine": "Custom",
            "status": "Research",
            "features": ["High Performance", "Data-Oriented", "Scalable"]
        })
    
    return projects

# Função de cleanup
func cleanup():
    """Limpa recursos do nível de game development"""
    is_timer_running = false
    
    # Limpar sistemas de game development
    unity_projects.clear()
    unreal_projects.clear()
    godot_projects.clear()
    game_systems.clear()
    
    # Remover todos os blocos
    for child in get_children():
        if child is LogicBlock:
            child.queue_free()
    
    print("Level 10: O Estúdio de Jogos - Limpeza concluída")
    print("Sua jornada como desenvolvedor de jogos foi épica!")
func _exit_tree():
    print("🧹 Level'${level_num}': Cleanup automático")
    concepts.clear()
    containers.clear()
    deployments.clear()
    services.clear()

func _initialize_concept_cache():
    _initialize_object_pool()
    print("📦 Level'${level_num}': Cache de conceitos inicializado")
    # Cache de conceitos para performance

func _initialize_object_pool():
    for i in _object_pool_size:
        _resource_pool.append({"id": "resource_" + str(i), "status": "available"})
    print("🎯 Level'${level_num}': Object pool inicializado")

func acquire_resource() -> Dictionary:
    return _resource_pool.pop_back() if _resource_pool.size() > 0 else {"id": "new_resource", "status": "created"}

func return_resource(resource: Dictionary):
    resource["status"] = "available"
    _resource_pool.append(resource)
