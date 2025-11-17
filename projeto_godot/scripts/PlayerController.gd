extends CharacterBody2D
class_name PlayerController

# Configurações de movimento
@export var move_speed: float = 150.0
@export var acceleration: float = 800.0
@export var friction: float = 400.0

# Configurações de habilidades
@export var ability_key: Key = Key.F  # Tecla para usar habilidade

# Referências
var animation_player: AnimationPlayer
var sprite: Sprite2D
var state_label: Label
var ability_system: LanguageAbilitySystem

# Estado do jogador
enum PlayerState { 
	IDLE, 
	MOVING, 
	EVALUATING, 
	EXECUTING, 
	BLOCKED, 
	SUCCESS, 
	FAILURE 
}

var current_state: PlayerState = PlayerState.IDLE
var target_position: Vector2 = Vector2.ZERO
var current_logic_block: LogicBlock = null

# Sistema de lógica/execução
var logic_path: Array[LogicBlock] = []
var path_index: int = 0
var is_executing_path: bool = false

# Feedback visual
var trail_effect: Line2D
var highlight_sprite: Sprite2D

# Controles e input
var input_enabled: bool = true

# Sistema de habilidades por linguagem
var language_ability_system: LanguageAbilitySystem
var advanced_ability_system: AdvancedLanguageAbilitySystem
var cooldown_indicator: Control

# Modos de habilidade (básico vs avançado)
var use_advanced_abilities: bool = true

func _ready():
	setup_visual()
	setup_animations()
	setup_input()
	setup_effects()
	add_to_group("player")

func setup_visual():
	"""Configura aparência do personagem"""
	# Sprite principal
	sprite = Sprite2D.new()
	sprite.texture = create_tracer_texture()
	sprite.modulate = Color.CYAN  # Cor característica do tracer
	add_child(sprite)
	
	# Label de estado (debug)
	state_label = Label.new()
	state_label.text = "IDLE"
	state_label.position = Vector2(-20, -30)
	state_label.modulate = Color.WHITE
	state_label.scale = Vector2(0.7, 0.7)
	add_child(state_label)

func create_tracer_texture() -> Texture2D:
	"""Cria textura do tracer programaticamente"""
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	
	# Fundo transparente
	for x in range(32):
		for y in range(32):
			image.set_pixel(x, y, Color.TRANSPARENT)
	
	# Desenhar círculo central (tracer)
	var center = Vector2(16, 16)
	var radius = 8
	
	for x in range(32):
		for y in range(32):
			var pos = Vector2(x, y)
			if pos.distance_to(center) <= radius:
				image.set_pixel(x, y, Color.CYAN)
	
	return ImageTexture.create_from_image(image)

func setup_animations():
	"""Configura sistema de animações"""
	animation_player = AnimationPlayer.new()
	add_child(animation_player)
	
	# Criar animações básicas
	create_basic_animations()

func create_basic_animations():
	"""Cria animações básicas do personagem"""
	# Animação de movimento
	var move_anim = Animation.new()
	move_anim.length = 0.3
	move_anim.loop_mode = Animation.LOOP_LINEAR
	
	# Track para posição
	var track = move_anim.add_track(Animation.TYPE_VALUE)
	move_anim.track_set_path(track, NodePath(".:position"))
	
	# Keyframes de movimento (serão configurados dinamicamente)
	animation_player.add_animation("move", move_anim)
	
	# Animação de execução
	var execute_anim = Animation.new()
	execute_anim.length = 0.5
	execute_anim.loop_mode = Animation.LOOP_NONE
	
	# Efeito de pulsação durante execução
	var scale_track = execute_anim.add_track(Animation.TYPE_VALUE)
	execute_anim.track_set_path(scale_track, NodePath(".:scale"))
	execute_anim.track_insert_key(scale_track, 0.0, Vector2.ONE)
	execute_anim.track_insert_key(scale_track, 0.25, Vector2.ONE * 1.2)
	execute_anim.track_insert_key(scale_track, 0.5, Vector2.ONE)
	
	animation_player.add_animation("execute", execute_anim)

func setup_input():
	"""Configura sistema de input"""
	# Input já é processado automaticamente pelo _input()

func setup_effects():
	"""Configura efeitos visuais"""
	# Trail effect para mostrar caminho
	trail_effect = Line2D.new()
	trail_effect.width = 2.0
	trail_effect.default_color = Color.CYAN.with_alpha(0.5)
	trail_effect.z_index = -1  # Atrás do personagem
	add_child(trail_effect)
	
	# Highlight sprite para indicar bloco ativo
	highlight_sprite = Sprite2D.new()
	highlight_sprite.modulate = Color.YELLOW.with_alpha(0.3)
	highlight_sprite.visible = false
	add_child(highlight_sprite)

func _physics_process(delta):
	"""Processa física e movimento"""
	update_state()
	handle_movement(delta)
	process_logic_execution(delta)
	update_visual_feedback()

func update_state():
	"""Atualiza estado do jogador baseado na situação"""
	match current_state:
		PlayerState.IDLE:
			if target_position != Vector2.ZERO:
				current_state = PlayerState.MOVING
				animation_player.play("move")
		
		PlayerState.MOVING:
			if velocity.length() < 1.0:
				# Chegou ao destino
				arrive_at_target()
		
		PlayerState.EVALUATING:
			# Aguardando avaliação do bloco atual
			pass
		
		PlayerState.EXECUTING:
			# Executando ação do bloco atual
			pass

func handle_movement(delta):
	"""Manipula movimento do personagem"""
	match current_state:
		PlayerState.IDLE, PlayerState.EVALUATING:
			# Aplicar fricção
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
		PlayerState.MOVING:
			# Mover em direção ao alvo
			var direction = (target_position - global_position).normalized()
			velocity = velocity.move_toward(direction * move_speed, acceleration * delta)
		
		_:
			# Outros estados - parar movimento
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()

func arrive_at_target():
	"""Called quando personagem chega ao destino"""
	current_state = PlayerState.EVALUATING
	target_position = Vector2.ZERO
	
	# Verificar se há bloco na posição atual
	var block = get_block_at_position(global_position)
	if block:
		evaluate_block(block)
	else:
		# Sem bloco - voltar ao idle
		current_state = PlayerState.IDLE

func get_block_at_position(position: Vector2) -> LogicBlock:
	"""Encontra bloco na posição especificada"""
	var blocks = get_tree().get_nodes_in_group("logic_blocks")
	
	for block in blocks:
		var block_pos = block.global_position
		var distance = position.distance_to(block_pos)
		if distance < 40:  # Threshold de proximidade
			return block
	
	return null

func evaluate_block(block: LogicBlock):
	"""Avalia bloco e determina próximo passo"""
	current_logic_block = block
	
	# Highlight do bloco atual
	highlight_current_block(block)
	
	# Simular delay de avaliação
	await get_tree().create_timer(0.2).timeout
	
	# Determinar próxima ação baseada no tipo de bloco
	match block.block_type:
		LogicBlock.BlockType.IF:
			evaluate_conditional_block(block)
		LogicBlock.BlockType.FOR:
			evaluate_loop_block(block)
		LogicBlock.BlockType.WHILE:
			evaluate_loop_block(block)
		LogicBlock.BlockType.MOVE:
			execute_move_block(block)
		_:
			# Outros tipos - comportamento padrão
			execute_default_block(block)

func evaluate_conditional_block(block: LogicBlock):
	"""Avalia bloco condicional (IF)"""
	# Simular avaliação de condição
	var condition_result = simulate_condition_evaluation()
	
	var target_block = null
	if condition_result:
		# Condição verdadeira - seguir saída "true"
		target_block = get_connected_block(block, "true_output")
	else:
		# Condição falsa - seguir saída "false" ou ELSE
		target_block = get_connected_block(block, "false_output")
		if not target_block:
			target_block = get_connected_block(block, "else_output")
	
	if target_block:
		move_to_block(target_block)
	else:
		# Sem conexão válida - parada ou falha
		current_state = PlayerState.SUCCESS  # Para protótipo, consideremos sucesso

func evaluate_loop_block(block: LogicBlock):
	"""Avalia bloco de loop (FOR/WHILE)"""
	match block.block_type:
		LogicBlock.BlockType.FOR:
			execute_for_loop(block)
		LogicBlock.BlockType.WHILE:
			execute_while_loop(block)

func execute_for_loop(block: LogicBlock):
	"""Executa loop FOR"""
	var iterations = 3  # Default para protótipo
	
	for i in range(iterations):
		# Executar corpo do loop
		var body_block = get_connected_block(block, "body_output")
		if body_block:
			await execute_block_sequence(body_block)
	
	# Depois do loop, continuar para próximo bloco
	var next_block = get_connected_block(block, "output")
	if next_block:
		move_to_block(next_block)
	else:
		current_state = PlayerState.SUCCESS

func execute_while_loop(block: LogicBlock):
	"""Executa loop WHILE"""
	var max_iterations = 5  # Prevenir loops infinitos
	
	while simulate_while_condition() and max_iterations > 0:
		max_iterations -= 1
		
		# Executar corpo do loop
		var body_block = get_connected_block(block, "body_output")
		if body_block:
			await execute_block_sequence(body_block)
	
	# Continuar após o loop
	var next_block = get_connected_block(block, "output")
	if next_block:
		move_to_block(next_block)
	else:
		current_state = PlayerState.SUCCESS

func execute_move_block(block: LogicBlock):
	"""Executa bloco de movimento simples"""
	# Movimento direto para próximo bloco
	var target_block = get_connected_block(block, "output")
	if target_block:
		move_to_block(target_block)
	else:
		current_state = PlayerState.SUCCESS

func execute_default_block(block: LogicBlock):
	"""Executa bloco com comportamento padrão"""
	# Para variáveis, assignments, etc.
	var target_block = get_connected_block(block, "output")
	if target_block:
		move_to_block(target_block)
	else:
		current_state = PlayerState.IDLE

func move_to_block(target_block: LogicBlock):
	"""Move personagem para bloco específico"""
	target_position = target_block.global_position
	current_state = PlayerState.MOVING
	
	# Atualizar trail
	add_to_trail(global_position)

func execute_block_sequence(start_block: LogicBlock):
	"""Executa sequência de blocos starting from start_block"""
	var current = start_block
	var visited = []
	
	while current and not visited.has(current):
		visited.append(current)
		evaluate_block(current)
		
		# Aguardar processamento do bloco atual
		await get_tree().create_timer(0.1).timeout
		current = get_next_block_in_sequence(current)

func get_next_block_in_sequence(current_block: LogicBlock) -> LogicBlock:
	"""Determina próximo bloco na sequência"""
	# Lógica simplificada - encontrar bloco mais próximo na direção
	var blocks = get_tree().get_nodes_in_group("logic_blocks")
	var nearest_block = null
	var nearest_distance = INF
	
	for block in blocks:
		if block != current_block:
			var distance = block.global_position.distance_to(current_block.global_position)
			if distance < 64 and distance < nearest_distance:  # Threshold de proximidade
				nearest_distance = distance
				nearest_block = block
	
	return nearest_block

func get_connected_block(block: LogicBlock, connection_type: String) -> LogicBlock:
	"""Encontra bloco conectado via tipo de conexão específico"""
	var blocks = get_tree().get_nodes_in_group("logic_blocks")
	
	for other_block in blocks:
		if other_block != block:
			# Verificar se este bloco está conectado ao bloco atual
			# Implementação simplificada - em versão real seria mais robusta
			if is_blocks_connected(block, other_block):
				return other_block
	
	return null

func is_blocks_connected(block1: LogicBlock, block2: LogicBlock) -> bool:
	"""Verifica se dois blocos estão conectados"""
	# Lógica simplificada para protótipo
	# Em versão real seria baseado nas conexões reais dos blocos
	var distance = block1.global_position.distance_to(block2.global_position)
	return distance < 64  # Proximidade como indicação de conexão

func simulate_condition_evaluation() -> bool:
	"""Simula avaliação de condição (placeholder para lógica real)"""
	return randi() % 2 == 0  # 50% chance para protótipo

func simulate_while_condition() -> bool:
	"""Simula condição de loop WHILE"""
	return randi() % 3 != 0  # 66% chance para protótipo

func highlight_current_block(block: LogicBlock):
	"""Destaque visual do bloco atual"""
	highlight_sprite.global_position = block.global_position
	highlight_sprite.visible = true
	
	# Auto-hide após delay
	await get_tree().create_timer(1.0).timeout
	highlight_sprite.visible = false

func show_feedback(message: String, color: Color):
	"""Mostra feedback visual/sonoro"""
	# Implementar feedback visual
	state_label.text = message
	state_label.modulate = color

func add_to_trail(position: Vector2):
	"""Adiciona ponto ao trail do personagem"""
	if trail_effect.points.size() > 50:  # Limitar tamanho
		trail_effect.remove_point(0)
	trail_effect.add_point(position)

func update_visual_feedback():
	"""Atualiza feedback visual baseado no estado"""
	# Atualizar label de estado
	state_label.text = PlayerState.keys()[current_state]
	
	# Colorir baseado no estado
	match current_state:
		PlayerState.IDLE:
			state_label.modulate = Color.WHITE
		PlayerState.MOVING:
			state_label.modulate = Color.CYAN
		PlayerState.EXECUTING:
			state_label.modulate = Color.YELLOW
		PlayerState.SUCCESS:
			state_label.modulate = Color.GREEN
		PlayerState.FAILURE:
			state_label.modulate = Color.RED

func start_level():
	"""Inicia execução do nível"""
	current_state = PlayerState.IDLE
	logic_path.clear()
	path_index = 0
	
	# Posicionar na posição inicial
	var start_pos = get_level_start_position()
	if start_pos:
		global_position = start_pos

func get_level_start_position() -> Vector2:
	"""Retorna posição inicial do nível"""
	# Configurar baseado no nível atual
	return Vector2(64, 64)  # Posição padrão para protótipo

func get_start_block() -> LogicBlock:
	"""Encontra bloco de início do nível"""
	var blocks = get_tree().get_nodes_in_group("logic_blocks")
	
	# Fallback: primeiro bloco encontrado
		# Retorna primeiro bloco válido
	return blocks[0] if blocks.size() > 0 else null

func reset():
	"""Reseta personagem para estado inicial"""
	current_state = PlayerState.IDLE
	target_position = Vector2.ZERO
	current_logic_block = null
	logic_path.clear()
	path_index = 0
	is_executing_path = false
	
	# Limpar efeitos visuais
	trail_effect.clear_points()
	highlight_sprite.visible = false
	state_label.text = "IDLE"

# Métodos públicos para controle externo
func set_input_enabled(enabled: bool):
	"""Controla se input está habilitado"""
	input_enabled = enabled

func get_current_state() -> PlayerState:
	"""Retorna estado atual do jogador"""
	return current_state

func force_move_to(target: Vector2):
	"""Força movimento para posição específica"""
	target_position = target

# Sistema de Habilidades por Linguagem
func set_language_ability_system(ability_sys: LanguageAbilitySystem):
	"""Define o sistema de habilidades"""
	language_ability_system = ability_sys
	ability_system = ability_sys  # Para compatibilidade
	
	# Define referência do jogador no sistema de habilidades
	if ability_sys:
		ability_sys.set_player_reference(self)

func set_cooldown_indicator(indicator: Control):
	"""Define o indicador de cooldown"""
	cooldown_indicator = indicator

func _unhandled_input(event):
	"""Processa input do jogador"""
	if not input_enabled:
		return
		
	# Tecla de habilidade
	if event.is_action_pressed("ui_select") or (event.is_pressed() and event.keycode == ability_key):
		_use_current_ability()

func _use_current_ability():
	"""Usa a habilidade atual"""
	if not language_ability_system:
		return
		
	# Verifica se a habilidade está disponível
	if not language_ability_system.is_ability_available():
		# Feedback de cooldown ativo
		_show_ability_unavailable_feedback()
		return
		
	# Usa a habilidade na posição atual do jogador
	var success = language_ability_system.use_ability(global_position)
	
	if success:
		# Feedback de sucesso da habilidade
		_show_ability_used_feedback()
	else:
		# Feedback de falha
		_show_ability_failed_feedback()

func _show_ability_unavailable_feedback():
	"""Mostra feedback quando habilidade não está disponível"""
	if sprite:
		# Efeito visual vermelho temporário
		var original_modulate = sprite.modulate
		sprite.modulate = Color(1, 0.3, 0.3)
		
		var tween = create_tween()
		tween.tween_interval(0.2)
		tween.tween_property(sprite, "modulate", original_modulate, 0.2)
		tween.play()

func _show_ability_used_feedback():
	"""Mostra feedback quando habilidade é usada com sucesso"""
	if sprite:
		# Efeito visual verde temporário
		var original_modulate = sprite.modulate
		sprite.modulate = Color(0.5, 1, 0.5)
		
		var tween = create_tween()
		tween.tween_interval(0.3)
		tween.tween_property(sprite, "modulate", original_modulate, 0.3)
		tween.play()
		
		# Atualiza estado no label se existir
		if state_label:
			state_label.text = "ABILITY_USED"

func _show_ability_failed_feedback():
	"""Mostra feedback quando habilidade falha"""
	if sprite:
		# Efeito visual amarelo temporário
		var original_modulate = sprite.modulate
		sprite.modulate = Color(1, 1, 0.3)
		
		var tween = create_tween()
		tween.tween_interval(0.2)
		tween.tween_property(sprite, "modulate", original_modulate, 0.2)
		tween.play()

func get_current_language() -> String:
	"""Retorna a linguagem atual selecionada"""
	if not language_ability_system:
		return "N/A"
		
	var selected_lang = language_ability_system.selected_language
	match selected_lang:
		LanguageAbilitySystem.ProgrammingLanguage.PYTHON:
			return "Python"
		LanguageAbilitySystem.ProgrammingLanguage.JAVA:
			return "Java"
		LanguageAbilitySystem.ProgrammingLanguage.C_SHARP:
			return "C#"
		LanguageAbilitySystem.ProgrammingLanguage.JAVASCRIPT:
			return "JavaScript"
		_:
			return "Unknown"

func reset_language_abilities():
	"""Reseta as habilidades da linguagem para estado inicial"""
	if language_ability_system:
		language_ability_system.reset_abilities()
	if advanced_ability_system:
		advanced_ability_system.reset_all_progress()

# === SISTEMA AVANÇADO (SPRINT 3) ===

func set_advanced_ability_system(ability_sys: AdvancedLanguageAbilitySystem):
	"""Define o sistema avançado de habilidades"""
	advanced_ability_system = ability_sys
	# Também define no sistema básico para compatibilidade
	if ability_sys:
		language_ability_system = ability_sys
		ability_sys.set_player_reference(self)

func toggle_ability_mode():
	"""Alterna entre modo básico e avançado"""
	use_advanced_abilities = not use_advanced_abilities
	var mode = "AVANÇADO" if use_advanced_abilities else "BÁSICO"
	print("🔄 Modo de habilidades alterado para: ", mode)

func _use_current_ability():
	"""Usa a habilidade atual (básico ou avançado)"""
	if use_advanced_abilities and advanced_ability_system:
		_use_advanced_ability()
	else:
		_use_basic_ability()

func _use_basic_ability():
	"""Usa habilidade básica (método original)"""
	if not language_ability_system:
		return
		
	# Verifica se a habilidade está disponível
	if not language_ability_system.is_ability_available():
		_show_ability_unavailable_feedback()
		return
		
	# Usa a habilidade na posição atual do jogador
	var success = language_ability_system.use_ability(global_position)
	
	if success:
		_show_ability_used_feedback()
	else:
		_show_ability_failed_feedback()

func _use_advanced_ability():
	"""Usa habilidade avançada (Sprint 3)"""
	if not advanced_ability_system:
		return
		
	# Verifica se a habilidade avançada está disponível
	if not advanced_ability_system.is_ability_available():
		_show_ability_unavailable_feedback()
		return
		
	# Usa a habilidade avançada na posição atual do jogador
	var success = advanced_ability_system.use_advanced_ability(global_position)
	
	if success:
		_show_advanced_ability_used_feedback()
	else:
		_show_ability_failed_feedback()

func _show_advanced_ability_used_feedback():
	"""Mostra feedback para habilidade avançada usada"""
	if sprite:
		# Efeito especial para habilidades avançadas
		var original_modulate = sprite.modulate
		var advanced_color = Color(1, 0.8, 0.2)  # Dourado para avançado
		
		# Animação especial
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", advanced_color, 0.1)
		tween.tween_property(sprite, "scale", Vector2(1.1, 1.1), 0.1)
		tween.tween_property(sprite, "modulate", original_modulate, 0.3)
		tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.2)
		tween.play()
		
		# Atualiza estado
		if state_label:
			state_label.text = "ADVANCED_ABILITY"

func get_advanced_stats() -> Dictionary:
	"""Retorna estatísticas avançadas do jogador"""
	var stats = {}
	
	if advanced_ability_system:
		stats = advanced_ability_system.get_language_stats()
	
	# Adiciona informações do jogador
	stats["player_info"] = {
		"current_language": get_current_language(),
		"advanced_mode": use_advanced_abilities,
		"current_state": current_state
	}
	
	return stats

# === CONTROLES AVANÇADOS ===

func _unhandled_input(event):
	"""Processa input do jogador com controles avançados"""
	if not input_enabled:
		return
		
	# Tecla de habilidade (original)
	if event.is_action_pressed("ui_select") or (event.is_pressed() and event.keycode == ability_key):
		_use_current_ability()
	
	# Controles avançados (Shift + teclas)
	if event.is_pressed() and event.keycode == Key.SHIFT:
		# Shift + F: Alternar modo de habilidade
		if Input.is_key_pressed(Key.F):
			toggle_ability_mode()
			get_viewport().set_input_as_handled()
		
		# Shift + M: Mostrar maestria
		elif Input.is_key_pressed(Key.M):
			var gm = get_tree().get_root().get_node("Main").get_node("GameManager")
			if gm and gm.has_method("show_mastery_overview"):
				gm.show_mastery_overview()
			get_viewport().set_input_as_handled()
		
		# Shift + U: Mostrar melhorias
		elif Input.is_key_pressed(Key.U):
			var gm = get_tree().get_root().get_node("Main").get_node("GameManager")
			if gm and gm.has_method("show_language_upgrades"):
				gm.show_language_upgrades()
			get_viewport().set_input_as_handled()
		
		# Shift + S: Mostrar estatísticas
		elif Input.is_key_pressed(Key.S):
			var gm = get_tree().get_root().get_node("Main").get_node("GameManager")
			if gm and gm.has_method("show_global_statistics"):
				gm.show_global_statistics()
			get_viewport().set_input_as_handled()
		
		# Shift + I: Mostrar info avançada
		elif Input.is_key_pressed(Key.I):
			var gm = get_tree().get_root().get_node("Main").get_node("GameManager")
			if gm and gm.has_method("show_advanced_language_info"):
				gm.show_advanced_language_info()
			get_viewport().set_input_as_handled()
	current_state = PlayerState.MOVING