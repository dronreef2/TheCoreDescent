# THE CORE DESCENT - NÍVEL 6: A ARQUITETURA WEB
# Arquivo: Level6.gd - Web Development e Full-Stack

extends Node2D
class_name Level6

# Configurações do nível
@export var level_name: String = "A Arquitetura Web"
@export var level_description: String = "Construa aplicações web modernas com tecnologias frontend e backend"
@export var target_moves: int = 28  # Número ideal de movimentos
@export var grid_width: int = 30
@export var grid_height: int = 24

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
var start_position: Vector2i = Vector2i(2, 12)
var goal_position: Vector2i = Vector2i(27, 12)
var start_block: LogicBlock
var goal_block: LogicBlock

# Objetivo atual
var moves_used: int = 0
var blocks_placed: int = 0
var level_timer: float = 0.0
var is_timer_running: bool = false
var ability_used_count: Dictionary = {}
var frontend_components: Array = []
var backend_services: Array = []
var api_endpoints: Array = []
var database_queries: Array = []
var responsive_breakpoints: Dictionary = {}
var security_layers: Array = []
var performance_optimizations: Array = []

# Puzzles disponíveis
var available_puzzles: Array[Dictionary] = []
var current_puzzle_index: int = 0

# UI Elements
var move_counter: Label
var timer_label: Label
var puzzle_info_label: Label
var progress_bar: ProgressBar

# Sinais
signal level_completed
signal level_failed
signal puzzle_solved(puzzle_data: Dictionary)
signal move_made
signal ability_activated

# Puzzles do nível - Foco em Web Development
func initialize_puzzles():
    available_puzzles = [
        {
            "id": "frontend_responsive",
            "title": "Frontend Responsivo",
            "description": "Implemente design responsivo com CSS Grid e Flexbox",
            "target_moves": 8,
            "start_position": Vector2i(2, 8),
            "goal_position": Vector2i(12, 16),
            "blocks_required": 5,
            "concepts": ["CSS Grid", "Flexbox", "Media Queries", "Mobile First", "Breakpoints"],
            "mechanics": {
                "viewport_adaptation": true,
                "grid_layout": true,
                "responsive_images": true,
                "touch_interactions": true
            },
            "obstacles": [
                {"type": "viewport_constraint", "position": Vector2i(8, 10), "size": Vector2i(6, 4)},
                {"type": "grid_line", "position": Vector2i(15, 6), "orientation": "vertical"},
                {"type": "responsive_breakpoint", "position": Vector2i(20, 12), "threshold": "768px"}
            ]
        },
        {
            "id": "frontend_state_management",
            "title": "Gerenciamento de Estado",
            "description": "Gerencie estado da aplicação com Redux/Vuex",
            "target_moves": 10,
            "start_position": Vector2i(3, 15),
            "goal_position": Vector2i(14, 9),
            "blocks_required": 6,
            "concepts": ["State Management", "Redux", "Vuex", "Actions", "Reducers", "Selectors"],
            "mechanics": {
                "state_immutable": true,
                "action_dispatch": true,
                "state_subscription": true,
                "time_travel_debugging": true
            },
            "obstacles": [
                {"type": "state_inconsistency", "position": Vector2i(7, 12), "severity": "medium"},
                {"type": "action_queue", "position": Vector2i(10, 14), "queue_size": 3},
                {"type": "state_persistence", "position": Vector2i(18, 11), "storage_type": "localStorage"}
            ]
        },
        {
            "id": "backend_api_rest",
            "title": "API RESTful",
            "description": "Desenvolva APIs REST com Node.js/Express",
            "target_moves": 12,
            "start_position": Vector2i(16, 7),
            "goal_position": Vector2i(27, 17),
            "blocks_required": 7,
            "concepts": ["REST API", "HTTP Methods", "Express.js", "Middleware", "Routing", "Error Handling"],
            "mechanics": {
                "http_methods": true,
                "middleware_chain": true,
                "request_validation": true,
                "response_formatting": true
            },
            "obstacles": [
                {"type": "route_conflict", "position": Vector2i(19, 9), "conflict_type": "method"},
                {"type": "middleware_dependencies", "position": Vector2i(22, 13), "dependencies": 4},
                {"type": "cors_policy", "position": Vector2i(25, 15), "allowed_origins": ["localhost:3000"]}
            ]
        },
        {
            "id": "database_optimization",
            "title": "Otimização de Banco",
            "description": "Otimize consultas SQL e NoSQL",
            "target_moves": 14,
            "start_position": Vector2i(4, 6),
            "goal_position": Vector2i(16, 18),
            "blocks_required": 8,
            "concepts": ["SQL Optimization", "Indexing", "Query Planning", "NoSQL", "Caching", "Connection Pooling"],
            "mechanics": {
                "index_optimization": true,
                "query_analysis": true,
                "cache_strategy": true,
                "connection_reuse": true
            },
            "obstacles": [
                {"type": "slow_query", "position": Vector2i(8, 8), "execution_time": "2.5s"},
                {"type": "missing_index", "position": Vector2i(11, 14), "table": "users"},
                {"type": "n_plus_one", "position": Vector2i(13, 10), "pattern": "query_per_item"}
            ]
        },
        {
            "id": "security_implementation",
            "title": "Segurança Web",
            "description": "Implemente autenticação e autorização seguras",
            "target_moves": 16,
            "start_position": Vector2i(20, 4),
            "goal_position": Vector2i(28, 20),
            "blocks_required": 9,
            "concepts": ["JWT", "OAuth", "HTTPS", "CSRF Protection", "XSS Prevention", "Rate Limiting"],
            "mechanics": {
                "token_validation": true,
                "session_management": true,
                "encryption": true,
                "threat_detection": true
            },
            "obstacles": [
                {"type": "expired_token", "position": Vector2i(22, 6), "lifetime": "15min"},
                {"type": "csrf_token", "position": Vector2i(24, 12), "validation_required": true},
                {"type": "rate_limit", "position": Vector2i(26, 16), "max_requests": 100}
            ]
        }
    ]

func _ready():
    print("Level 6: A Arquitetura Web - Iniciando...")
    
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
    print("Level 6 pronto para jogar!")

func setup_grid():
    """Configura a grade do tabuleiro"""
    # Criar blocos de início e fim
    start_block = create_logic_block(start_position, "start", "Inicio do Projeto Web")
    goal_block = create_logic_block(goal_position, "goal", "Aplicação Web Completa")
    
    # Adicionar obstáculos baseados no puzzle atual
    var current_puzzle = available_puzzles[current_puzzle_index]
    setup_puzzle_obstacles(current_puzzle.get("obstacles", []))

func setup_blocks():
    """Configura os blocos lógicos no tabuleiro"""
    # Implementação baseada nos conceitos do puzzle atual
    var current_puzzle = available_puzzles[current_puzzle_index]
    var concepts = current_puzzle.get("concepts", [])
    
    for concept in concepts:
        var position = get_random_valid_position()
        create_logic_block(position, "concept", concept)

func create_logic_block(position: Vector2i, block_type: String, data: String) -> LogicBlock:
    """Cria um bloco lógico na posição especificada"""
    var block = LogicBlock.new()
    block.position = position
    block.block_type = block_type
    block.data = data
    block.set("custom_data", {
        "level": 6,
        "concept": data,
        "web_context": true
    })
    
    add_child(block)
    return block

func setup_puzzle_obstacles(obstacles: Array):
    """Configura obstáculos específicos do puzzle"""
    for obstacle in obstacles:
        var obstacle_node = create_obstacle(obstacle)
        add_child(obstacle_node)

func create_obstacle(obstacle_data: Dictionary) -> Node:
    """Cria um obstáculo baseado nos dados fornecidos"""
    var obstacle_type = obstacle_data.get("type", "generic")
    var position = obstacle_data.get("position", Vector2i(0, 0))
    var obstacle = Node2D.new()
    obstacle.position = position * 32  # Converter para coordenadas do tabuleiro
    
    # Configurar propriedades específicas do obstáculo
    obstacle.set("obstacle_type", obstacle_type)
    obstacle.set("obstacle_data", obstacle_data)
    
    return obstacle

func setup_signals():
    """Configura as conexões de sinais"""
    # Conectar com o sistema de drag and drop
    if drag_system:
        drag_system.block_dropped.connect(_on_block_dropped)
    
    # Conectar com o player
    if player:
        player.move_completed.connect(_on_player_move_completed)
    
    # Conectar com o game manager
    if game_manager:
        game_manager.pause_requested.connect(_on_pause_requested)

func setup_ui():
    """Configura a interface do usuário"""
    # Esta função seria implementada com a UI do Godot
    # Por enquanto, apenas inicializa as variáveis
    move_counter = Label.new()
    timer_label = Label.new()
    puzzle_info_label = Label.new()
    progress_bar = ProgressBar.new()

func _process(delta: float):
    """Atualiza o estado do nível"""
    if is_timer_running and current_state == LevelState.PLAYING:
        level_timer += delta
        update_timer_display()
    
    # Verificar condições de vitória/derrota
    check_level_completion()
    check_level_failure()

func update_timer_display():
    """Atualiza a exibição do timer"""
    var minutes = int(level_timer / 60)
    var seconds = int(level_timer % 60)
    if timer_label:
        timer_label.text = "Tempo: %02d:%02d" % [minutes, seconds]

func check_level_completion():
    """Verifica se o nível foi completado"""
    if current_puzzle_index >= available_puzzles.size():
        # Todos os puzzles foram resolvidos
        current_state = LevelState.COMPLETED
        is_timer_running = false
        emit_signal("level_completed")
        print("Level 6 concluído! Parabéns!")
        return
    
    # Verificar se o puzzle atual foi resolvido
    var current_puzzle = available_puzzles[current_puzzle_index]
    if is_puzzle_solved(current_puzzle):
        current_puzzle_index += 1
        if current_puzzle_index < available_puzzles.size():
            # Carregar próximo puzzle
            load_next_puzzle()
        emit_signal("puzzle_solved", current_puzzle)

func check_level_failure():
    """Verifica condições de falha"""
    if moves_used > target_moves * 1.5:  # 50% de tolerância
        current_state = LevelState.FAILED
        is_timer_running = false
        emit_signal("level_failed")
        print("Level 6 falhou! Movimentos excedidos.")

func is_puzzle_solved(puzzle: Dictionary) -> bool:
    """Verifica se um puzzle foi resolvido"""
    # Lógica de verificação baseada nos mechanics do puzzle
    var mechanics = puzzle.get("mechanics", {})
    
    # Verificar se todos os mechanics foram implementados
    var implemented_count = 0
    var required_count = mechanics.size()
    
    for mechanic in mechanics.keys():
        if mechanics[mechanic] == true:
            implemented_count += 1
    
    return implemented_count >= required_count * 0.8  # 80% de implementação

func load_next_puzzle():
    """Carrega o próximo puzzle"""
    if current_puzzle_index >= available_puzzles.size():
        return
    
    var next_puzzle = available_puzzles[current_puzzle_index]
    
    # Resetar estado
    moves_used = 0
    blocks_placed = 0
    
    # Atualizar UI
    update_puzzle_display(next_puzzle)
    
    # Configurar novo puzzle
    setup_puzzle_obstacles(next_puzzle.get("obstacles", []))

func update_puzzle_display(puzzle: Dictionary):
    """Atualiza a exibição do puzzle atual"""
    if puzzle_info_label:
        puzzle_info_label.text = "%s: %s" % [puzzle.get("title", ""), puzzle.get("description", "")]
    
    if progress_bar:
        var progress = float(current_puzzle_index) / float(available_puzzles.size())
        progress_bar.value = progress * 100

# Manipuladores de eventos
func _on_block_dropped(block: LogicBlock, position: Vector2i):
    """Manipula quando um bloco é solto"""
    blocks_placed += 1
    moves_used += 1
    emit_signal("move_made")
    
    # Verificar se o bloco é válido para o puzzle atual
    var current_puzzle = available_puzzles[current_puzzle_index]
    validate_block_placement(block, current_puzzle)

func _on_player_move_completed():
    """Manipula quando o jogador completa um movimento"""
    emit_signal("move_made")
    check_level_completion()

func _on_pause_requested():
    """Manipula pedidos de pausa"""
    is_timer_running = !is_timer_running

func validate_block_placement(block: LogicBlock, puzzle: Dictionary):
    """Valida se o bloco foi colocado corretamente"""
    var concepts = puzzle.get("concepts", [])
    var block_concept = block.get("custom_data", {}).get("concept", "")
    
    # Verificar se o conceito do bloco é relevante para o puzzle
    var is_valid_concept = concepts.has(block_concept) or "generic" in concepts
    
    if not is_valid_concept:
        # Bloco inválido - implementar feedback visual
        block.highlight_as_invalid()

# Funções utilitárias
func get_random_valid_position() -> Vector2i:
    """Retorna uma posição válida aleatória no tabuleiro"""
    var attempts = 0
    var max_attempts = 100
    
    while attempts < max_attempts:
        var x = randi_range(1, grid_width - 2)
        var y = randi_range(1, grid_height - 2)
        var position = Vector2i(x, y)
        
        # Verificar se a posição está livre
        if is_position_available(position):
            return position
        
        attempts += 1
    
    # Fallback para posição padrão
    return Vector2i(5, 12)

func is_position_available(position: Vector2i) -> bool:
    """Verifica se uma posição está disponível"""
    # Implementar verificação de colisões
    return true  # Simplificado por enquanto

# Funções de interface pública
func get_current_score() -> Dictionary:
    """Retorna a pontuação atual do nível"""
    var time_score = max(0, 1000 - int(level_timer * 10))
    var efficiency_score = max(0, (target_moves * 100) - (moves_used * 10))
    var concept_score = calculate_concept_score()
    
    return {
        "time_score": time_score,
        "efficiency_score": efficiency_score,
        "concept_score": concept_score,
        "total_score": time_score + efficiency_score + concept_score
    }

func calculate_concept_score() -> int:
    """Calcula pontuação baseada em conceitos implementados"""
    var total_concepts = 0
    var mastered_concepts = 0
    
    for puzzle in available_puzzles:
        var concepts = puzzle.get("concepts", [])
        total_concepts += concepts.size()
        
        # Verificar conceitos implementados (simplificado)
        mastered_concepts += int(concepts.size() * 0.7)  # 70% implementado
    
    if total_concepts > 0:
        return int((mastered_concepts * 100) / total_concepts)
    return 0

func get_level_stats() -> Dictionary:
    """Retorna estatísticas detalhadas do nível"""
    return {
        "level": 6,
        "name": level_name,
        "description": level_description,
        "target_moves": target_moves,
        "moves_used": moves_used,
        "puzzles_completed": current_puzzle_index,
        "total_puzzles": available_puzzles.size(),
        "time_elapsed": level_timer,
        "blocks_placed": blocks_placed,
        "concepts_mastered": get_mastered_concepts(),
        "web_technologies": get_web_technologies(),
        "score": get_current_score()
    }

func get_mastered_concepts() -> Array:
    """Retorna conceitos que foram dominados"""
    var mastered = []
    
    for i in range(current_puzzle_index):
        var puzzle = available_puzzles[i]
        var concepts = puzzle.get("concepts", [])
        mastered.append_array(concepts)
    
    return mastered

func get_web_technologies() -> Dictionary:
    """Retorna tecnologias web que foram utilizadas"""
    return {
        "frontend": ["HTML5", "CSS3", "JavaScript ES6+", "React/Vue", "CSS Grid", "Flexbox"],
        "backend": ["Node.js", "Express.js", "REST APIs", "Middleware"],
        "database": ["SQL", "NoSQL", "Query Optimization", "Indexing"],
        "security": ["JWT", "OAuth", "HTTPS", "CSRF", "XSS Protection"],
        "tools": ["Git", "Webpack", "NPM", "Chrome DevTools"]
    }

# Função de cleanup
func cleanup():
    """Limpa recursos do nível"""
    is_timer_running = false
    
    # Remover todos os blocos
    for child in get_children():
        if child is LogicBlock:
            child.queue_free()
    
    print("Level 6: A Arquitetura Web - Limpeza concluída")