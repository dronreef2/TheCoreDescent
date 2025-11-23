extends Node
class_name LanguageAbilitySystem

# Sistema de Habilidades por Linguagem de Programação
# Implementa as habilidades especiais de cada linguagem conforme GDD

# Linguagens disponíveis
enum ProgrammingLanguage {
    PYTHON,
    JAVA,
    C_SHARP,
    JAVASCRIPT
}

# Configurações de cooldown (em segundos)
@export var ability_cooldown: Dictionary = {
    ProgrammingLanguage.PYTHON: 8.0,
    ProgrammingLanguage.JAVA: 12.0,
    ProgrammingLanguage.C_SHARP: 15.0,
    ProgrammingLanguage.JAVASCRIPT: 10.0
}

# Habilidade selecionada atualmente
var selected_language: ProgrammingLanguage = ProgrammingLanguage.PYTHON
var abilities: Dictionary = {}

# Sistema de cooldown
var last_used_time: Dictionary = {
    ProgrammingLanguage.PYTHON: -999.0,
    ProgrammingLanguage.JAVA: -999.0,
    ProgrammingLanguage.C_SHARP: -999.0,
    ProgrammingLanguage.JAVASCRIPT: -999.0
}

# Referências
var player: CharacterBody2D
var game_manager: Node

func _ready():
    setup_abilities()
    setup_references()

func setup_abilities():
    """Configura as habilidades específicas de cada linguagem"""
    
    # Python - Duck Typing: usar chave errada uma vez
    abilities[ProgrammingLanguage.PYTHON] = {
        "name": "Duck Typing",
        "description": "Permite usar uma chave/porta que não seja exatamente a correta uma vez",
        "icon": "🐍",
        "color": Color(52, 152, 219),
        "usable": false,
        "uses_remaining": 1,
        "max_uses": 1
    }
    
    # Java - Garbage Collector: remover obstáculo
    abilities[ProgrammingLanguage.JAVA] = {
        "name": "Garbage Collector", 
        "description": "Remove qualquer obstáculo físico (blocos de código, barriers)",
        "icon": "☕",
        "color": Color(231, 76, 60),
        "usable": true,
        "uses_remaining": 0,
        "max_uses": 0
    }
    
    # C# - .NET Framework: criar ponte
    abilities[ProgrammingLanguage.C_SHARP] = {
        "name": ".NET Framework",
        "description": "Cria uma ponte temporária sobre vazios/águas",
        "icon": "#",
        "color": Color(46, 204, 113),
        "usable": true,
        "uses_remaining": 0,
        "max_uses": 0
    }
    
    # JavaScript - Callback: teletransporte marcado
    abilities[ProgrammingLanguage.JAVASCRIPT] = {
        "name": "Callback",
        "description": "Teleporta para a posição mais recente marcada",
        "icon": "⚡",
        "color": Color(241, 196, 15),
        "usable": true,
        "uses_remaining": 0,
        "max_uses": 0
    }

func setup_references():
    """Configura referências para outros nós"""
    var gm = get_tree().get_root().get_node("Main").get_node("GameManager")
    game_manager = gm

func select_language(language: ProgrammingLanguage) -> bool:
    """Seleciona uma nova linguagem e verifica se é válida"""
    if selected_language != language:
        selected_language = language
        if game_manager and game_manager.has_method("update_language_display"):
            game_manager.update_language_display(language)
        return true
    return false

func get_selected_ability() -> Dictionary:
    """Retorna os dados da habilidade selecionada"""
    return abilities.get(selected_language, {})

func is_ability_available() -> bool:
    """Verifica se a habilidade selecionada está disponível para uso"""
    var ability = get_selected_ability()
    
    # Verifica cooldown
    var current_time = Time.get_ticks_msec() / 1000.0
    var last_used = last_used_time[selected_language]
    var cooldown = ability_cooldown[selected_language]
    
    if current_time - last_used < cooldown:
        return false
    
    # Verifica usos especiais (como Duck Typing)
    if ability.has("uses_remaining") and ability.uses_remaining <= 0:
        return false
        
    return ability.usable

func get_remaining_cooldown() -> float:
    """Retorna o tempo restante de cooldown em segundos"""
    var ability = get_selected_ability()
    var current_time = Time.get_ticks_msec() / 1000.0
    var last_used = last_used_time[selected_language]
    var cooldown = ability_cooldown[selected_language]
    
    var elapsed = current_time - last_used
    if elapsed >= cooldown:
        return 0.0
    return cooldown - elapsed

func use_ability(target_position: Vector2 = Vector2.ZERO) -> bool:
    """Usa a habilidade selecionada"""
    if not is_ability_available():
        return false
    
    var ability = get_selected_ability()
    var success = false
    
    match selected_language:
        ProgrammingLanguage.PYTHON:
            success = _use_python_duck_typing(target_position)
        ProgrammingLanguage.JAVA:
            success = _use_java_garbage_collector(target_position)
        ProgrammingLanguage.C_SHARP:
            success = _use_csharp_net_framework(target_position)
        ProgrammingLanguage.JAVASCRIPT:
            success = _use_javascript_callback(target_position)
    
    if success:
        last_used_time[selected_language] = Time.get_ticks_msec() / 1000.0
        
        # Decrementa usos especiais
        if ability.has("uses_remaining"):
            ability.uses_remaining -= 1
            if ability.uses_remaining <= 0:
                ability.usable = false
        
        # Feedback visual
        _show_ability_feedback(ability.color)
        
        # Notifica o GameManager
        if game_manager and game_manager.has_method("on_ability_used"):
            game_manager.on_ability_used(selected_language, success)
    
    return success

func _use_python_duck_typing(target_position: Vector2) -> bool:
    """Python - Duck Typing: permite passar por porta/chave incorreta uma vez"""
    if not game_manager:
        return false
        
    var has_interaction = _check_door_or_gate_interaction(target_position)
    if has_interaction:
        # Marca a interação como temporariamente permitida
        if game_manager.has_method("mark_interaction_allowed"):
            game_manager.mark_interaction_allowed(target_position)
        
        # Consome o uso único do Duck Typing
        var ability = abilities[ProgrammingLanguage.PYTHON]
        ability.usable = false
        ability.uses_remaining = 0
        
        print("Python Duck Typing: Interação incorreta permitida temporariamente")
        return true
    return false

func _use_java_garbage_collector(target_position: Vector2) -> bool:
    """Java - Garbage Collector: remove obstáculos físicos"""
    if not game_manager:
        return false
        
    # Procura por obstáculos na área
    var obstacles = game_manager.get_overlapping_objects(target_position, "obstacle")
    
    if obstacles.size() > 0:
        # Remove o primeiro obstáculo encontrado
        var obstacle = obstacles[0]
        if obstacle and obstacle.has_method("queue_free"):
            obstacle.queue_free()
            print("Java Garbage Collector: Obstáculo removido")
            return true
    
    return false

func _use_csharp_net_framework(target_position: Vector2) -> bool:
    """C# - .NET Framework: cria ponte sobre vazios/águas"""
    if not game_manager:
        return false
        
    # Verifica se há um vazio/água que precisa de ponte
    var needs_bridge = _check_gap_or_water(target_position)
    
    if needs_bridge:
        # Cria uma ponte temporária
        var bridge = _create_temporary_bridge(target_position)
        if bridge:
            # Remove a ponte após alguns segundos
            var timer = Timer.new()
            timer.wait_time = 15.0  # A ponte dura 15 segundos
            timer.one_shot = true
            add_child(timer)
            timer.timeout.connect(func():
                if bridge and bridge.is_inside_tree():
                    bridge.queue_free()
            )
            timer.start()
            
            print("C# .NET Framework: Ponte criada temporariamente")
            return true
    
    return false

func _use_javascript_callback(target_position: Vector2) -> bool:
    """JavaScript - Callback: teleporte para posição marcada"""
    if not game_manager:
        return false
        
    # Verifica se existe uma posição marcada
    if game_manager.has_method("get_marked_position"):
        var marked_pos = game_manager.get_marked_position()
        if marked_pos != Vector2.ZERO:
            # Teleporta o jogador para a posição marcada
            if player:
                player.global_position = marked_pos
                print("JavaScript Callback: Teleporte para posição marcada")
                return true
    
    # Se não há posição marcada, marca a posição atual
    if game_manager.has_method("set_marked_position"):
        game_manager.set_marked_position(target_position)
        print("JavaScript Callback: Posição atual marcada para futuro teletransporte")
        return true  # Considera sucesso marcar a posição
    
    return false

func _check_door_or_gate_interaction(position: Vector2) -> bool:
    """Verifica se há uma porta/gate que está bloqueando o jogador"""
    # Implementação simplificada - em versão completa seria mais robusta
    var world_2d = _get_world_2d()
    if world_2d == null:
        return false
    var query = PhysicsRayQueryParameters2D.create(position, position + Vector2(1, 0))
    query.collision_mask = 1  # Layer 1 - obstáculos
    var result = world_2d.direct_space_state.intersect_ray(query)
    
    return result.size() > 0

func _check_gap_or_water(position: Vector2) -> bool:
    """Verifica se há um gap ou água que precisa de ponte"""
    # Verifica se há vazio abaixo ou água no tile
    var world_2d = _get_world_2d()
    if world_2d == null:
        return false
    var space_state = world_2d.direct_space_state
    var query = PhysicsRayQueryParameters2D.create(
        position, 
        position + Vector2(0, 100)  # Olha 100 pixels para baixo
    )
    query.collision_mask = 2  # Layer 2 - chão
    
    var result = space_state.intersect_ray(query)
    return result.is_empty()  # Se não há chão, há um gap

func _get_world_2d() -> World2D:
    """Retorna referência segura ao World2D para nós que não herdam de Node2D"""
    if player:
        return player.get_world_2d()
    var viewport = get_viewport()
    if viewport:
        return viewport.get_world_2d()
    return null

func _create_temporary_bridge(position: Vector2) -> Node2D:
    """Cria uma ponte temporária"""
    var bridge = Node2D.new()
    bridge.name = "TemporaryBridge"
    bridge.position = position
    
    # Visual da ponte
    var sprite = Sprite2D.new()
    sprite.texture = _create_bridge_texture()
    bridge.add_child(sprite)
    
    # Colisão da ponte
    var collision = CollisionShape2D.new()
    var rect_shape = RectangleShape2D.new()
    rect_shape.size = Vector2(64, 8)  # Largura 64, altura 8
    collision.shape = rect_shape
    bridge.add_child(collision)
    
    # Adiciona ao mundo
    get_tree().get_root().add_child(bridge)
    
    return bridge

func _create_bridge_texture() -> Texture2D:
    """Cria uma textura simples para a ponte"""
    var image = Image.create(64, 8, false, Image.FORMAT_RGBA8)
    image.fill(Color(139, 69, 19))  # Cor marrom
    
    var texture = ImageTexture.create_from_image(image)
    return texture

func _show_ability_feedback(color: Color):
    """Mostra feedback visual quando uma habilidade é usada"""
    # Cria um efeito visual temporário
    var effect = Sprite2D.new()
    effect.modulate = color
    effect.modulate.a = 0.7
    
    # Sprite de efeito
    var circle_texture = _create_circle_texture(32, color)
    effect.texture = circle_texture
    effect.scale = Vector2(2, 2)
    
    # Posiciona no jogador se disponível
    if player:
        effect.global_position = player.global_position
    else:
        effect.position = Vector2(640, 360)  # Centro da tela
    
    # Adiciona ao mundo
    get_tree().get_root().add_child(effect)
    
    # Anima e remove
    var tween = create_tween()
    tween.tween_property(effect, "modulate:a", 0.0, 1.0)
    tween.tween_property(effect, "scale", Vector2(0.5, 0.5), 0.5)
    tween.finished.connect(func(): effect.queue_free())
    tween.play()

func _create_circle_texture(radius: int, color: Color) -> Texture2D:
    """Cria uma textura de círculo simples"""
    var size = radius * 2
    var image = Image.create(size, size, false, Image.FORMAT_RGBA8)
    image.fill(Color.TRANSPARENT)
    
    var center = Vector2(radius, radius)
    for x in range(size):
        for y in range(size):
            var point = Vector2(x, y)
            if point.distance_to(center) <= radius:
                image.set_pixel(x, y, color)
    
    var texture = ImageTexture.create_from_image(image)
    return texture

func reset_abilities():
    """Reseta as habilidades para estado inicial (usado ao reiniciar nível)"""
    for lang in abilities.keys():
        var ability = abilities[lang]
        ability.usable = true
        ability.uses_remaining = ability.max_uses
        
        if lang == ProgrammingLanguage.PYTHON:
            ability.uses_remaining = 1
            ability.usable = true

func get_language_info(language: ProgrammingLanguage) -> Dictionary:
    """Retorna informações sobre uma linguagem específica"""
    return abilities.get(language, {})

func get_all_languages_info() -> Dictionary:
    """Retorna informações sobre todas as linguagens"""
    return abilities.duplicate()

func set_player_reference(player_ref: CharacterBody2D):
    """Define a referência do jogador para uso interno"""
    player = player_ref