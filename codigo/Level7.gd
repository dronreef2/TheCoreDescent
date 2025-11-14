# THE CORE DESCENT - NÍVEL 7: O ECOSSISTEMA MOBILE
# Arquivo: Level7.gd - Mobile Development e Cross-Platform

extends Node2D
class_name Level7

# Configurações do nível
@export var level_name: String = "O Ecossistema Mobile"
@export var level_description: String = "Desenvolva aplicações nativas e multiplataforma para iOS e Android"
@export var target_moves: int = 32  # Número ideal de movimentos
@export var grid_width: int = 32
@export var grid_height: int = 26

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
var start_position: Vector2i = Vector2i(2, 13)
var goal_position: Vector2i = Vector2i(29, 13)
var start_block: LogicBlock
var goal_block: LogicBlock

# Objetivo atual
var moves_used: int = 0
var blocks_placed: int = 0
var level_timer: float = 0.0
var is_timer_running: bool = false
var ability_used_count: Dictionary = {}
var native_components: Array = []
var cross_platform_features: Array = []
var platform_specific_code: Array = []
var app_store_optimization: Dictionary = {}
var push_notifications: Array = []
var biometric_auth: Array = []
var offline_capabilities: Array = []
var performance_optimizations: Array = []

# Puzzles disponíveis
var available_puzzles: Array[Dictionary] = []
var current_puzzle_index: int = 0

# UI Elements
var move_counter: Label
var timer_label: Label
var puzzle_info_label: Label
var progress_bar: ProgressBar
var platform_selector: OptionButton

# Sinais
signal level_completed
signal level_failed
signal puzzle_solved(puzzle_data: Dictionary)
signal move_made
signal ability_activated

# Puzzles do nível - Foco em Mobile Development
func initialize_puzzles():
    available_puzzles = [
        {
            "id": "native_ios_development",
            "title": "Desenvolvimento Nativo iOS",
            "description": "Implemente funcionalidades nativas do iOS com Swift",
            "target_moves": 10,
            "start_position": Vector2i(2, 8),
            "goal_position": Vector2i(12, 18),
            "blocks_required": 6,
            "concepts": ["Swift", "UIKit", "SwiftUI", "Core Data", "Auto Layout", "iOS SDK"],
            "mechanics": {
                "swift_syntax": true,
                "storyboard_design": true,
                "auto_layout_constraints": true,
                "core_data_persistence": true
            },
            "obstacles": [
                {"type": "memory_management", "position": Vector2i(6, 10), "retention": "strong"},
                {"type": "threading", "position": Vector2i(8, 14), "main_thread_required": true},
                {"type": "device_compatibility", "position": Vector2i(10, 16), "min_version": "iOS 14.0"}
            ]
        },
        {
            "id": "native_android_development",
            "title": "Desenvolvimento Nativo Android",
            "description": "Crie aplicações Android com Kotlin e Android SDK",
            "target_moves": 12,
            "start_position": Vector2i(4, 20),
            "goal_position": Vector2i(16, 6),
            "blocks_required": 7,
            "concepts": ["Kotlin", "Android SDK", "Jetpack", "RecyclerView", "Room Database", "Material Design"],
            "mechanics": {
                "kotlin_coroutines": true,
                "jetpack_compose": true,
                "room_database": true,
                "material_components": true
            },
            "obstacles": [
                {"type": "fragment_lifecycle", "position": Vector2i(8, 18), "states": ["onCreate", "onResume"]},
                {"type": "permissions", "position": Vector2i(11, 12), "required_permissions": ["CAMERA", "LOCATION"]},
                {"type": "device_fragments", "position": Vector2i(14, 8), "screen_sizes": ["phone", "tablet"]}
            ]
        },
        {
            "id": "cross_platform_react_native",
            "title": "React Native Cross-Platform",
            "description": "Desenvolva com React Native para múltiplas plataformas",
            "target_moves": 14,
            "start_position": Vector2i(14, 4),
            "goal_position": Vector2i(26, 20),
            "blocks_required": 8,
            "concepts": ["React Native", "JavaScript", "Native Modules", "Hot Reload", "Bridge Pattern", "Platform Specific"],
            "mechanics": {
                "component_reusability": true,
                "native_bridge": true,
                "platform_detection": true,
                "state_management": true
            },
            "obstacles": [
                {"type": "bridge_overhead", "position": Vector2i(18, 8), "performance_impact": "medium"},
                {"type": "platform_divergence", "position": Vector2i(21, 14), "differences": ["ios", "android"]},
                {"type": "third_party_modules", "position": Vector2i(24, 16), "compatibility": "mixed"}
            ]
        },
        {
            "id": "flutter_cross_platform",
            "title": "Flutter Multiplatform",
            "description": "Implemente com Flutter para iOS, Android e Web",
            "target_moves": 16,
            "start_position": Vector2i(6, 22),
            "goal_position": Vector2i(20, 4),
            "blocks_required": 9,
            "concepts": ["Dart", "Flutter Widgets", "Hot Reload", "Platform Channels", "Animations", "State Management"],
            "mechanics": {
                "widget_tree": true,
                "platform_channels": true,
                "animation_system": true,
                "dart_compilation": true
            },
            "obstacles": [
                {"type": "widget_performance", "position": Vector2i(10, 20), "rendering_cost": "high"},
                {"type": "platform_specific_ui", "position": Vector2i(14, 12), "platforms": ["ios", "android"]},
                {"type": "build_size", "position": Vector2i(17, 8), "size_limit": "50MB"}
            ]
        },
        {
            "id": "mobile_security_biometrics",
            "title": "Segurança e Biometria",
            "description": "Implemente autenticação biométrica e segurança mobile",
            "target_moves": 18,
            "start_position": Vector2i(22, 6),
            "goal_position": Vector2i(30, 22),
            "blocks_required": 10,
            "concepts": ["Biometric Auth", "Touch ID", "Face ID", "Keychain", "Certificate Pinning", "App Transport Security"],
            "mechanics": {
                "fingerprint_auth": true,
                "face_recognition": true,
                "secure_storage": true,
                "certificate_validation": true
            },
            "obstacles": [
                {"type": "biometric_compatibility", "position": Vector2i(25, 10), "supported_biometrics": ["fingerprint", "face"]},
                {"type": "secure_enclave", "position": Vector2i(27, 14), "hardware_required": true},
                {"type": "app_transport_security", "position": Vector2i(29, 18), "tls_version": "1.2+"}
            ]
        },
        {
            "id": "push_notifications_offline",
            "title": "Notificações e Offline",
            "description": "Implemente push notifications e funcionalidades offline",
            "target_moves": 20,
            "start_position": Vector2i(8, 2),
            "goal_position": Vector2i(24, 24),
            "blocks_required": 11,
            "concepts": ["Push Notifications", "FCM", "APNS", "Offline Sync", "Local Storage", "Background Processing"],
            "mechanics": {
                "notification_delivery": true,
                "background_sync": true,
                "local_data_persistence": true,
                "conflict_resolution": true
            },
            "obstacles": [
                {"type": "notification_delivery", "position": Vector2i(12, 6), "delivery_rate": "95%"},
                {"type": "offline_data_sync", "position": Vector2i(16, 18), "sync_frequency": "realtime"},
                {"type": "battery_optimization", "position": Vector2i(20, 12), "battery_impact": "low"}
            ]
        }
    ]

func _ready():
    print("Level 7: O Ecossistema Mobile - Iniciando...")
    
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
    print("Level 7 pronto para jogar!")

func setup_grid():
    """Configura a grade do tabuleiro mobile"""
    # Criar blocos de início e fim
    start_block = create_logic_block(start_position, "start", "Início do Desenvolvimento Mobile")
    goal_block = create_logic_block(goal_position, "goal", "Aplicativo Mobile Completo")
    
    # Adicionar obstáculos baseados no puzzle atual
    var current_puzzle = available_puzzles[current_puzzle_index]
    setup_puzzle_obstacles(current_puzzle.get("obstacles", []))

func setup_blocks():
    """Configura os blocos lógicos no tabuleiro mobile"""
    var current_puzzle = available_puzzles[current_puzzle_index]
    var concepts = current_puzzle.get("concepts", [])
    
    # Adicionar blocos para cada conceito
    for concept in concepts:
        var position = get_random_valid_position()
        create_logic_block(position, "concept", concept)
    
    # Adicionar blocos específicos de plataforma
    add_platform_specific_blocks()

func create_logic_block(position: Vector2i, block_type: String, data: String) -> LogicBlock:
    """Cria um bloco lógico na posição especificada"""
    var block = LogicBlock.new()
    block.position = position
    block.block_type = block_type
    block.data = data
    block.set("custom_data", {
        "level": 7,
        "concept": data,
        "mobile_context": true,
        "platform": get_current_platform(),
        "performance_tier": get_performance_tier()
    })
    
    add_child(block)
    return block

func add_platform_specific_blocks():
    """Adiciona blocos específicos de plataforma"""
    var platforms = ["iOS", "Android", "Cross-Platform"]
    
    for platform in platforms:
        var position = get_random_valid_position()
        var block = create_logic_block(position, "platform", platform)
        block.set("platform", platform)

func setup_puzzle_obstacles(obstacles: Array):
    """Configura obstáculos específicos do puzzle mobile"""
    for obstacle in obstacles:
        var obstacle_node = create_mobile_obstacle(obstacle)
        add_child(obstacle_node)

func create_mobile_obstacle(obstacle_data: Dictionary) -> Node:
    """Cria um obstáculo mobile específico"""
    var obstacle_type = obstacle_data.get("type", "generic")
    var position = obstacle_data.get("position", Vector2i(0, 0))
    var obstacle = Node2D.new()
    obstacle.position = position * 32  # Converter para coordenadas do tabuleiro
    
    # Configurar propriedades específicas de mobile
    obstacle.set("obstacle_type", obstacle_type)
    obstacle.set("obstacle_data", obstacle_data)
    obstacle.set("platform_specific", is_platform_specific_obstacle(obstacle_type))
    
    return obstacle

func is_platform_specific_obstacle(obstacle_type: String) -> bool:
    """Verifica se o obstáculo é específico de plataforma"""
    var platform_specific_types = [
        "memory_management", "threading", "device_compatibility", 
        "fragment_lifecycle", "permissions", "device_fragments",
        "biometric_compatibility", "secure_enclave", "app_transport_security"
    ]
    return platform_specific_types.has(obstacle_type)

func setup_signals():
    """Configura as conexões de sinais"""
    if drag_system:
        drag_system.block_dropped.connect(_on_block_dropped)
    
    if player:
        player.move_completed.connect(_on_player_move_completed)
    
    if game_manager:
        game_manager.pause_requested.connect(_on_pause_requested)

func setup_ui():
    """Configura a interface do usuário mobile"""
    move_counter = Label.new()
    timer_label = Label.new()
    puzzle_info_label = Label.new()
    progress_bar = ProgressBar.new()
    platform_selector = OptionButton.new()
    
    # Adicionar opções de plataforma
    platform_selector.add_item("iOS")
    platform_selector.add_item("Android")
    platform_selector.add_item("Cross-Platform")
    platform_selector.add_item("Both Platforms")

func _process(delta: float):
    """Atualiza o estado do nível mobile"""
    if is_timer_running and current_state == LevelState.PLAYING:
        level_timer += delta
        update_timer_display()
    
    # Verificar condições específicas de mobile
    check_mobile_performance()
    check_platform_compatibility()
    
    # Verificar condições de vitória/derrota
    check_level_completion()
    check_level_failure()

func check_mobile_performance():
    """Verifica performance específica de mobile"""
    # Implementar métricas de performance mobile
    var memory_usage = calculate_memory_usage()
    var battery_impact = calculate_battery_impact()
    var network_efficiency = calculate_network_efficiency()
    
    # Alertar sobre problemas de performance
    if memory_usage > 100:  # MB
        print("Alto uso de memória detectado: %d MB" % memory_usage)
    
    if battery_impact > 0.8:  # Alto impacto
        print("Alto impacto na bateria detectado")

func check_platform_compatibility():
    """Verifica compatibilidade entre plataformas"""
    var current_puzzle = available_puzzles[current_puzzle_index]
    var mechanics = current_puzzle.get("mechanics", {})
    
    # Verificar se as funcionalidades são compatíveis
    for mechanic in mechanics.keys():
        if not is_mechanic_compatible(mechanic):
            print("Incompatibilidade detectada: %s" % mechanic)

func is_mechanic_compatible(mechanic: String) -> bool:
    """Verifica se um mechanic é compatível com a plataforma atual"""
    var platform = get_current_platform()
    
    var compatibility_matrix = {
        "swift_syntax": ["iOS"],
        "kotlin_coroutines": ["Android"],
        "flutter_widgets": ["iOS", "Android", "Web"],
        "react_native_components": ["iOS", "Android"],
        "biometric_auth": ["iOS", "Android"],
        "push_notifications": ["iOS", "Android"]
    }
    
    var compatible_platforms = compatibility_matrix.get(mechanic, ["iOS", "Android"])
    return compatible_platforms.has(platform) or compatible_platforms.has("Cross-Platform")

func update_timer_display():
    """Atualiza a exibição do timer"""
    var minutes = int(level_timer / 60)
    var seconds = int(level_timer % 60)
    if timer_label:
        timer_label.text = "Tempo: %02d:%02d | Plataforma: %s" % [minutes, seconds, get_current_platform()]

func check_level_completion():
    """Verifica se o nível foi completado"""
    if current_puzzle_index >= available_puzzles.size():
        current_state = LevelState.COMPLETED
        is_timer_running = false
        emit_signal("level_completed")
        print("Level 7 concluído! App mobile multi-plataforma criado!")
        return
    
    var current_puzzle = available_puzzles[current_puzzle_index]
    if is_puzzle_solved(current_puzzle):
        current_puzzle_index += 1
        if current_puzzle_index < available_puzzles.size():
            load_next_puzzle()
        emit_signal("puzzle_solved", current_puzzle)

func is_puzzle_solved(puzzle: Dictionary) -> bool:
    """Verifica se um puzzle mobile foi resolvido"""
    var mechanics = puzzle.get("mechanics", {})
    var platform = get_current_platform()
    
    var implemented_count = 0
    var required_count = mechanics.size()
    
    for mechanic in mechanics.keys():
        if mechanics[mechanic] == true and is_mechanic_compatible(mechanic):
            implemented_count += 1
    
    # Verificar se atende aos critérios específicos da plataforma
    var platform_requirements_met = check_platform_requirements(puzzle)
    
    return implemented_count >= required_count * 0.8 and platform_requirements_met

func check_platform_requirements(puzzle: Dictionary) -> bool:
    """Verifica requisitos específicos da plataforma"""
    var platform = get_current_platform()
    var obstacles = puzzle.get("obstacles", [])
    
    for obstacle in obstacles:
        if is_platform_specific_obstacle(obstacle.get("type", "")):
            if not meets_platform_requirement(obstacle, platform):
                return false
    
    return true

func meets_platform_requirement(obstacle: Dictionary, platform: String) -> bool:
    """Verifica se um requisito de plataforma foi atendido"""
    var requirement_type = obstacle.get("type", "")
    
    match requirement_type:
        "device_compatibility":
            return platform == "iOS"  # iOS-specific
        "permissions":
            return platform == "Android"  # Android-specific
        "biometric_compatibility":
            return platform in ["iOS", "Android"]
        "secure_enclave":
            return platform == "iOS"  # iOS hardware-specific
        _:
            return true

func load_next_puzzle():
    """Carrega o próximo puzzle mobile"""
    if current_puzzle_index >= available_puzzles.size():
        return
    
    var next_puzzle = available_puzzles[current_puzzle_index]
    
    # Resetar estado
    moves_used = 0
    blocks_placed = 0
    
    # Limpar componentes específicos da plataforma anterior
    clear_platform_components()
    
    # Atualizar UI
    update_puzzle_display(next_puzzle)
    
    # Configurar novo puzzle
    setup_puzzle_obstacles(next_puzzle.get("obstacles", []))

func clear_platform_components():
    """Limpa componentes específicos da plataforma anterior"""
    # Implementar limpeza de componentes mobile
    pass

func update_puzzle_display(puzzle: Dictionary):
    """Atualiza a exibição do puzzle mobile"""
    if puzzle_info_label:
        puzzle_info_label.text = "%s: %s (Plataforma: %s)" % [
            puzzle.get("title", ""), 
            puzzle.get("description", ""), 
            get_current_platform()
        ]
    
    if progress_bar:
        var progress = float(current_puzzle_index) / float(available_puzzles.size())
        progress_bar.value = progress * 100

# Manipuladores de eventos
func _on_block_dropped(block: LogicBlock, position: Vector2i):
    """Manipula quando um bloco é solto no contexto mobile"""
    blocks_placed += 1
    moves_used += 1
    emit_signal("move_made")
    
    # Validação específica para mobile
    var current_puzzle = available_puzzles[current_puzzle_index]
    validate_mobile_block_placement(block, current_puzzle)

func _on_player_move_completed():
    """Manipula quando o jogador completa um movimento"""
    emit_signal("move_made")
    check_level_completion()

func _on_pause_requested():
    """Manipula pedidos de pausa"""
    is_timer_running = !is_timer_running

func validate_mobile_block_placement(block: LogicBlock, puzzle: Dictionary):
    """Valida se o bloco foi colocado corretamente no contexto mobile"""
    var concepts = puzzle.get("concepts", [])
    var block_concept = block.get("custom_data", {}).get("concept", "")
    var block_platform = block.get("custom_data", {}).get("platform", "")
    
    # Verificar compatibilidade de plataforma
    var current_platform = get_current_platform()
    var is_platform_compatible = (block_platform == current_platform) or (block_platform == "Cross-Platform")
    
    # Verificar relevância do conceito
    var is_valid_concept = concepts.has(block_concept) or "generic" in concepts
    
    if not is_platform_compatible:
        print("Aviso: Bloco %s pode não ser compatível com %s" % [block_concept, current_platform])
    
    if not is_valid_concept:
        block.highlight_as_invalid()

# Funções utilitárias específicas de mobile
func get_current_platform() -> String:
    """Retorna a plataforma atual (simulada)"""
    # Em um jogo real, isso seria baseado na seleção do jogador
    return "Cross-Platform"

func get_performance_tier() -> String:
    """Retorna o tier de performance do dispositivo"""
    # Simulado - em um app real, seria baseado no hardware
    return "high"

func calculate_memory_usage() -> int:
    """Calcula uso de memória (simulado)"""
    return int(moves_used * 2.5)  # MB simulados

func calculate_battery_impact() -> float:
    """Calcula impacto na bateria (simulado)"""
    return float(moves_used * 0.01)

func calculate_network_efficiency() -> float:
    """Calcula eficiência de rede (simulado)"""
    return 1.0 - (float(moves_used) * 0.005)

# Funções de interface pública
func get_current_score() -> Dictionary:
    """Retorna a pontuação atual do nível mobile"""
    var time_score = max(0, 1200 - int(level_timer * 10))
    var efficiency_score = max(0, (target_moves * 100) - (moves_used * 12))
    var concept_score = calculate_mobile_concept_score()
    var platform_score = calculate_platform_score()
    
    return {
        "time_score": time_score,
        "efficiency_score": efficiency_score,
        "concept_score": concept_score,
        "platform_score": platform_score,
        "total_score": time_score + efficiency_score + concept_score + platform_score
    }

func calculate_mobile_concept_score() -> int:
    """Calcula pontuação baseada em conceitos mobile implementados"""
    var total_concepts = 0
    var mastered_concepts = 0
    
    for puzzle in available_puzzles:
        var concepts = puzzle.get("concepts", [])
        total_concepts += concepts.size()
        
        # Verificar conceitos implementados
        mastered_concepts += int(concepts.size() * 0.75)  # 75% implementado para mobile
    
    if total_concepts > 0:
        return int((mastered_concepts * 100) / total_concepts)
    return 0

func calculate_platform_score() -> int:
    """Calcula pontuação baseada na compatibilidade de plataforma"""
    var current_platform = get_current_platform()
    var platform_bonus = 0
    
    match current_platform:
        "iOS":
            platform_bonus = 50
        "Android":
            platform_bonus = 50
        "Cross-Platform":
            platform_bonus = 100  # Bonus por compatibilidade multiplataforma
        _:
            platform_bonus = 25
    
    return platform_bonus

func get_level_stats() -> Dictionary:
    """Retorna estatísticas detalhadas do nível mobile"""
    return {
        "level": 7,
        "name": level_name,
        "description": level_description,
        "target_moves": target_moves,
        "moves_used": moves_used,
        "puzzles_completed": current_puzzle_index,
        "total_puzzles": available_puzzles.size(),
        "time_elapsed": level_timer,
        "blocks_placed": blocks_placed,
        "current_platform": get_current_platform(),
        "concepts_mastered": get_mastered_concepts(),
        "mobile_technologies": get_mobile_technologies(),
        "platform_compatibility": get_platform_compatibility(),
        "performance_metrics": get_performance_metrics(),
        "score": get_current_score()
    }

func get_mastered_concepts() -> Array:
    """Retorna conceitos mobile que foram dominados"""
    var mastered = []
    
    for i in range(current_puzzle_index):
        var puzzle = available_puzzles[i]
        var concepts = puzzle.get("concepts", [])
        mastered.append_array(concepts)
    
    return mastered

func get_mobile_technologies() -> Dictionary:
    """Retorna tecnologias mobile que foram utilizadas"""
    return {
        "native_ios": ["Swift", "UIKit", "SwiftUI", "Core Data", "Auto Layout"],
        "native_android": ["Kotlin", "Android SDK", "Jetpack", "Room", "Material Design"],
        "cross_platform": ["React Native", "Flutter", "Xamarin", "Ionic"],
        "tools": ["Xcode", "Android Studio", "VS Code", "Expo", "Firebase"],
        "services": ["FCM", "APNS", "Analytics", "Crashlytics", "App Store Connect"]
    }

func get_platform_compatibility() -> Dictionary:
    """Retorna compatibilidade entre plataformas"""
    return {
        "supported_platforms": ["iOS", "Android", "Web"],
        "cross_platform_frameworks": ["React Native", "Flutter"],
        "native_features": {
            "biometric_auth": ["iOS", "Android"],
            "push_notifications": ["iOS", "Android"],
            "offline_storage": ["iOS", "Android"],
            "camera_access": ["iOS", "Android"]
        },
        "platform_specific_features": {
            "iOS": ["App Store Optimization", "iCloud Sync", "Siri Integration"],
            "Android": ["Google Play Optimization", "Android Auto", "Google Assistant"]
        }
    }

func get_performance_metrics() -> Dictionary:
    """Retorna métricas de performance mobile"""
    return {
        "memory_usage_mb": calculate_memory_usage(),
        "battery_impact": calculate_battery_impact(),
        "network_efficiency": calculate_network_efficiency(),
        "load_time": "2.1s",
        "render_performance": "60fps",
        "bundle_size": "15MB",
        "startup_time": "1.2s"
    }

func get_random_valid_position() -> Vector2i:
    """Retorna uma posição válida aleatória no tabuleiro mobile"""
    var attempts = 0
    var max_attempts = 100
    
    while attempts < max_attempts:
        var x = randi_range(1, grid_width - 2)
        var y = randi_range(1, grid_height - 2)
        var position = Vector2i(x, y)
        
        if is_position_available(position):
            return position
        
        attempts += 1
    
    return Vector2i(6, 13)

func is_position_available(position: Vector2i) -> bool:
    """Verifica se uma posição está disponível"""
    # Implementar verificação de colisões mobile
    return true

# Função de cleanup
func cleanup():
    """Limpa recursos do nível mobile"""
    is_timer_running = false
    
    # Remover todos os blocos
    for child in get_children():
        if child is LogicBlock:
            child.queue_free()
    
    print("Level 7: O Ecossistema Mobile - Limpeza concluída")