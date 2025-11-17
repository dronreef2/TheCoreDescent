# THE CORE DESCENT - NÍVEL 2: A FORJA DE PONTEIROS
# Arquivo: Level2.gd - Implementação do segundo nível com habilidades de programação

extends Node2D
class_name Level2

# Configurações do nível
@export var level_name: String = "A Forja de Ponteiros"
@export var level_description: String = "Domine conceitos básicos de ponteiros e referências em C/C++"
@export var target_moves: int = 12  # Número ideal de movimentos
@export var grid_width: int = 22
@export var grid_height: int = 16

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
var start_position: Vector2i = Vector2i(2, 8)
var goal_position: Vector2i = Vector2i(19, 8)
var start_block: LogicBlock
var goal_block: LogicBlock

# Objetivo atual
var moves_used: int = 0
var blocks_placed: int = 0
var level_timer: float = 0.0
var is_timer_running: bool = false
var ability_used_count: Dictionary = {}  # Contador de uso de habilidades

# Puzzles disponíveis
var available_puzzles: Array[Dictionary] = []
var current_puzzle_index: int = 0

# UI Elements
var move_counter: Label
var timer_label: Label
var puzzle_title: Label
var instructions_label: Label
var ability_counter: Label

func _ready():
	setup_level()
	setup_ui()
	load_available_puzzles()
	load_puzzle(0)

func setup_level():
	"""Configuração inicial do nível"""
	# Adicionar ao grupo de níveis
	add_to_group("levels")
	
	# Obter referências dos sistemas
	if get_tree().current_scene.has_method("get_game_manager"):
		game_manager = get_tree().current_scene.get_game_manager()
		drag_system = game_manager.get_drag_system()
		player = game_manager.get_player()
		ui_manager = game_manager.get_ui_manager()
		ability_system = game_manager.get_ability_system()

func setup_ui():
	"""Configura interface do usuário"""
	# Criar container para UI
	var ui_container = Control.new()
	ui_container.name = "UI"
	ui_container.anchor_left = 0
	ui_container.anchor_top = 0
	ui_container.anchor_right = 1
	ui_container.anchor_bottom = 0
	ui_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui_container.size_flags_vertical = Control.SIZE_FILL
	add_child(ui_container)
	
	# Título do nível
	puzzle_title = Label.new()
	puzzle_title.text = "PUZZLE 1: INTRODUÇÃO A PONTEIROS"
	puzzle_title.position = Vector2(20, 20)
	puzzle_title.modulate = Color(0.8, 0.4, 0.2)  # Laranja para C/C++
	ui_container.add_child(puzzle_title)
	
	# Contador de movimentos
	move_counter = Label.new()
	move_counter.text = "Movimentos: 0/" + str(target_moves)
	move_counter.position = Vector2(20, 50)
	ui_container.add_child(move_counter)
	
	# Timer
	timer_label = Label.new()
	timer_label.text = "Tempo: 0.0s"
	timer_label.position = Vector2(20, 80)
	ui_container.add_child(timer_label)
	
	# Contador de habilidades
	ability_counter = Label.new()
	ability_counter.text = "Habilidades C++: 0"
	ability_counter.position = Vector2(20, 110)
	ability_counter.modulate = Color.ORANGE
	ui_container.add_child(ability_counter)
	
	# Instruções
	instructions_label = Label.new()
	instructions_label.text = "Use as habilidades de programação para resolver desafios.\nC++: Use as teclas 1-4 para ativar habilidades específicas!"
	instructions_label.position = Vector2(20, 140)
	instructions_label.size = Vector2(450, 60)
	ui_container.add_child(instructions_label)

func load_available_puzzles():
	"""Carrega puzzles disponíveis para este nível"""
	available_puzzles = [
		{
			"name": "Ponteiro Simples",
			"description": "Use ponteiros para acessar dados protegidos por trás de barreiras",
			"blocks_needed": ["IF", "POINTER", "MOVE", "MOVE", "DEREFERENCE"],
			"start_pos": Vector2i(2, 8),
			"goal_pos": Vector2i(19, 8),
			"special_items": [
				{"type": "key", "color": "orange", "pos": Vector2i(6, 8), "protected": true, "barrier_type": "wall"},
				{"type": "pointer_target", "pos": Vector2i(8, 8), "accesses": "orange_key"},
				{"type": "gem", "pos": Vector2i(15, 8), "requires_pointer": true}
			],
			"solution_steps": [
				"Acessar chave protegida via ponteiro",
				"Desreferenciar ponteiro para obter chave",
				"Usar chave para abrir caminho",
				"Coletar gema protegida",
				"Completar nível"
			],
			"hints": [
				"Use POINTER para apontar para a chave laranja",
				"DEREFERENCE retorna o valor apontado",
				"Some barreiras só são acessíveis via ponteiros"
			]
		},
		{
			"name": "Ponteiro de Função",
			"description": "Use ponteiros de função para executar ações indiretas",
			"blocks_needed": ["POINTER_FUNC", "IF", "MOVE", "MOVE", "MOVE"],
			"start_pos": Vector2i(2, 8),
			"goal_pos": Vector2i(19, 8),
			"special_items": [
				{"type": "function_switch", "pos": Vector2i(5, 7), "action": "open_gate_a"},
				{"type": "function_switch", "pos": Vector2i(5, 9), "action": "open_gate_b"},
				{"type": "pointer_func", "pos": Vector2i(7, 8), "targets": ["function_switch_a", "function_switch_b"]},
				{"type": "gate", "color": "purple", "pos": Vector2i(12, 8), "opens_with": "function_action"}
			],
			"solution_steps": [
				"Apontar para função switch_a",
				"Executar função via ponteiro",
				"Apontar para função switch_b", 
				"Executar segunda função",
				"Passar pelo portão aberto"
			],
			"hints": [
				"Ponteiros de função apontam para código executável",
				"Execute ações remotas usando ponteiros de função",
				"Combinações de funções abrem caminhos especiais"
			]
		},
		{
			"name": "Referência Circular",
			"description": "Resolva dependências circulares usando referências",
			"blocks_needed": ["REFERENCE", "IF", "MOVE", "MOVE", "MOVE", "MOVE"],
			"start_pos": Vector2i(2, 8),
			"goal_pos": Vector2i(19, 8),
			"special_items": [
				{"type": "circular_lock", "pos": Vector2i(8, 8), "requires": "reference_chain"},
				{"type": "reference_node_a", "pos": Vector2i(6, 6), "points_to": "node_b"},
				{"type": "reference_node_b", "pos": Vector2i(6, 10), "points_to": "node_c"},
				{"type": "reference_node_c", "pos": Vector2i(10, 8), "points_to": "node_a"},
				{"type": "gem", "pos": Vector2i(17, 8), "requires_chain": true}
			],
			"solution_steps": [
				"Criar referência circular entre nós A->B->C->A",
				"Usar REFERENCE para quebrar ciclo",
				"Acessar fechadura desbloqueada",
				"Coletar gema protegida por referência",
				"Completar puzzle"
			],
			"hints": [
				"Referências resolvem dependências circulares",
				"Crie uma cadeia de referências que se complete",
				"Algumas fechaduras só abrem com referências corretas"
			]
		}
	]

func load_puzzle(puzzle_index: int):
	"""Carrega puzzle específico"""
	if puzzle_index >= available_puzzles.size():
		complete_level()
		return
	
	current_puzzle_index = puzzle_index
	var puzzle = available_puzzles[puzzle_index]
	
	# Atualizar UI
	puzzle_title.text = "PUZZLE " + str(puzzle_index + 1) + ": " + puzzle.name
	instructions_label.text = puzzle.description + "\nDica: " + puzzle.hints[0]
	
	# Reset do nível
	reset_level()
	
	# Configurar posições
	start_position = puzzle.start_pos
	goal_position = puzzle.goal_pos
	
	# Criar elementos especiais
	create_special_items(puzzle.special_items)
	
	# Criar blocos iniciais
	create_initial_blocks(puzzle.blocks_needed)
	
	# Posicionar jogador
	position_player_at_start()
	
	# Iniciar estado
	current_state = LevelState.PLAYING
	is_timer_running = true
	
	emit_signal("puzzle_loaded", puzzle_index)

func reset_level():
	"""Reseta estado do nível"""
	# Limpar blocos existentes
	clear_all_blocks()
	
	# Reset contadores
	moves_used = 0
	blocks_placed = 0
	level_timer = 0.0
	ability_used_count.clear()
	
	# Atualizar UI
	move_counter.text = "Movimentos: 0/" + str(target_moves)
	timer_label.text = "Tempo: 0.0s"
	update_ability_counter()
	
	# Resetar jogador
	if player:
		player.reset()

func clear_all_blocks():
	"""Remove todos os blocos do nível"""
	var blocks = get_tree().get_nodes_in_group("logic_blocks")
	for block in blocks:
		block.queue_free()

func update_ability_counter():
	"""Atualiza contador de habilidades usadas"""
	var total_uses = 0
	for lang in ability_used_count.keys():
		total_uses += ability_used_count[lang]
	ability_counter.text = "Habilidades C++: " + str(total_uses)

func create_special_items(items: Array):
	"""Cria itens especiais específicos do nível"""
	for item in items:
		match item.type:
			"key":
				create_key(item.color, item.pos, item.get("protected", false), item.get("barrier_type", ""))
			"pointer_target":
				create_pointer_target(item.pos, item.accesses)
			"gem":
				create_gem(item.pos, item.get("requires_pointer", false), item.get("requires_chain", false))
			"pointer_func":
				create_pointer_function(item.pos, item.targets)
			"function_switch":
				create_function_switch(item.pos, item.action)
			"gate":
				create_gate(item.color, item.pos, item.opens_with)
			"circular_lock":
				create_circular_lock(item.pos, item.requires)
			"reference_node":
				create_reference_node(item.pos, item.points_to)

func create_key(color: String, grid_pos: Vector2i, protected: bool = false, barrier_type: String = ""):
	"""Cria uma chave com proteção opcional"""
	var key = Node2D.new()
	key.name = "Key_" + color
	key.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	key.is_protected = protected
	key.barrier_type = barrier_type
	key.is_collected = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/key_" + color + ".png")
	sprite.modulate = get_color_by_name(color)
	if protected:
		sprite.modulate = sprite.modulate.darkened(0.3)
	key.add_child(sprite)
	
	# Área de colisão
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 12
	collision.shape = shape
	area.add_child(collision)
	area.connect("body_entered", Callable(self, "_on_key_collected"))
	key.add_child(area)
	
	add_child(key)

func create_pointer_target(grid_pos: Vector2i, accesses: String):
	"""Cria alvo que só pode ser acessado via ponteiro"""
	var target = Node2D.new()
	target.name = "PointerTarget_" + accesses
	target.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	target.accesses = accesses
	target.can_access = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/target.png")
	sprite.modulate = Color(1, 0.5, 0)  # Laranja para indicar ponteiro
	target.add_child(sprite)
	
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 15
	collision.shape = shape
	area.add_child(collision)
	area.connect("body_entered", Callable(self, "_on_pointer_access"))
	target.add_child(area)
	
	add_child(target)

func create_pointer_function(grid_pos: Vector2i, targets: Array):
	"""Cria ponteiro de função"""
	var ptr_func = Node2D.new()
	ptr_func.name = "PointerFunction"
	ptr_func.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	ptr_func.targets = targets
	ptr_func.is_active = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/pointer_func.png")
	sprite.modulate = Color.YELLOW
	ptr_func.add_child(sprite)
	
	# Área de ativação
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 20
	collision.shape = shape
	area.add_child(collision)
	area.connect("body_entered", Callable(self, "_on_pointer_func_used"))
	ptr_func.add_child(area)
	
	add_child(ptr_func)

func create_function_switch(grid_pos: Vector2i, action: String):
	"""Cria switch que executa uma ação específica"""
	var switch = Node2D.new()
	switch.name = "FunctionSwitch_" + action
	switch.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	switch.action = action
	switch.is_activated = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/switch.png")
	sprite.modulate = Color.CYAN
	switch.add_child(sprite)
	
	add_child(switch)

func create_gate(color: String, grid_pos: Vector2i, opens_with: String):
	"""Cria portão que abre com ação específica"""
	var gate = Node2D.new()
	gate.name = "Gate_" + color
	gate.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	gate.required_action = opens_with
	gate.is_open = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/gate_" + color + ".png")
	sprite.modulate = get_color_by_name(color)
	gate.add_child(sprite)
	
	add_child(gate)

func create_circular_lock(grid_pos: Vector2i, requires: String):
	"""Cria fechadura que requer referência circular"""
	var lock = Node2D.new()
	lock.name = "CircularLock"
	lock.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	lock.requires = requires
	lock.is_unlocked = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/circular_lock.png")
	sprite.modulate = Color.PURPLE
	lock.add_child(sprite)
	
	add_child(lock)

func create_reference_node(grid_pos: Vector2i, points_to: String):
	"""Cria nó de referência"""
	var node = Node2D.new()
	node.name = "ReferenceNode_" + points_to
	node.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	node.points_to = points_to
	node.is_active = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/reference_node.png")
	sprite.modulate = Color.GREEN
	node.add_child(sprite)
	
	add_child(node)

func create_gem(grid_pos: Vector2i, requires_pointer: bool = false, requires_chain: bool = false):
	"""Cria gema com requisitos especiais"""
	var gem = Node2D.new()
	gem.name = "Gem"
	gem.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	gem.requires_pointer = requires_pointer
	gem.requires_chain = requires_chain
	gem.is_collected = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/gem.png")
	if requires_pointer or requires_chain:
		sprite.modulate = Color(1, 0.84, 0, 0.7)  # Transparente se protegida
	else:
		sprite.modulate = Color.GOLD
	gem.add_child(sprite)
	
	# Área de colisão
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 10
	collision.shape = shape
	area.add_child(collision)
	area.connect("body_entered", Callable(self, "_on_gem_collected"))
	gem.add_child(area)
	
	add_child(gem)

func get_color_by_name(color_name: String) -> Color:
	"""Converte nome de cor para Color object"""
	var colors = {
		"blue": Color.BLUE,
		"red": Color.RED,
		"green": Color.GREEN,
		"yellow": Color.YELLOW,
		"purple": Color.PURPLE,
		"orange": Color(1, 0.5, 0)
	}
	return colors.get(color_name, Color.WHITE)

func create_initial_blocks(blocks_needed: Array):
	"""Cria blocos iniciais disponíveis para o jogador"""
	var palette_position = Vector2(50, 220)
	
	var block_spawners = {
		"IF": LogicBlock.BlockType.IF,
		"ELSE": LogicBlock.BlockType.ELSE,
		"FOR": LogicBlock.BlockType.FOR,
		"WHILE": LogicBlock.BlockType.WHILE,
		"VARIABLE": LogicBlock.BlockType.VARIABLE,
		"MOVE": LogicBlock.BlockType.MOVE,
		"ASSIGN": LogicBlock.BlockType.ASSIGN,
		"POINTER": LogicBlock.BlockType.POINTER,
		"DEREFERENCE": LogicBlock.BlockType.DEREFERENCE,
		"POINTER_FUNC": LogicBlock.BlockType.POINTER_FUNC,
		"REFERENCE": LogicBlock.BlockType.REFERENCE
	}
	
	var x_offset = 0
	for block_type_name in blocks_needed:
		if block_spawners.has(block_type_name):
			var block_type = block_spawners[block_type_name]
			var block = create_spawner_block(block_type, palette_position + Vector2(x_offset, 0))
			x_offset += 55

func create_spawner_block(block_type: LogicBlock.BlockType, position: Vector2) -> LogicBlock:
	"""Cria bloco no spawner (paleta)"""
	var block = LogicBlock.new()
	block.block_type = block_type
	block.position = position
	block.is_spawner = true
	block.z_index = 10
	
	add_child(block)
	block.add_to_group("logic_blocks")
	
	return block

func position_player_at_start():
	"""Posiciona jogador no início do nível"""
	if player:
		var start_world_pos = Vector2(start_position.x * 32, start_position.y * 32)
		player.global_position = start_world_pos

func _process(delta):
	"""Processa lógica do nível"""
	if is_timer_running:
		level_timer += delta
		timer_label.text = "Tempo: " + str(round(level_timer * 10) / 10) + "s"
	
	# Verificar condições de vitória/derrota
	check_level_completion()

func check_level_completion():
	"""Verifica se nível foi completado"""
	if current_state != LevelState.PLAYING:
		return
	
	# Verificar se jogador chegou ao objetivo
	if player and player.global_position.distance_to(Vector2(goal_position.x * 32, goal_position.y * 32)) < 20:
		complete_current_puzzle()

func complete_current_puzzle():
	"""Completa puzzle atual e avança para próximo"""
	current_state = LevelState.COMPLETED
	is_timer_running = false
	
	# Calcular pontuação (inclui uso de habilidades)
	var score = calculate_puzzle_score()
	
	# Mostrar resultado
	show_puzzle_completion(score)
	
	# Aguardar antes de carregar próximo puzzle
	await get_tree().create_timer(2.0).timeout
	
	load_puzzle(current_puzzle_index + 1)

func calculate_puzzle_score() -> Dictionary:
	"""Calcula pontuação baseada em performance e uso de habilidades"""
	var time_score = max(0, 100 - int(level_timer))
	var moves_score = max(0, 100 - (moves_used * 10))
	var efficiency_score = 100 - (abs(blocks_placed - target_moves) * 4) if blocks_placed > 0 else 50
	var ability_score = max(0, 100 - (ability_used_count.get("cpp", 0) * 5))
	
	return {
		"time": time_score,
		"moves": moves_score,
		"efficiency": efficiency_score,
		"abilities": ability_score,
		"total": (time_score + moves_score + efficiency_score + ability_score) / 4
	}

func show_puzzle_completion(score: Dictionary):
	"""Mostra tela de completion do puzzle"""
	var completion_panel = Control.new()
	completion_panel.name = "CompletionPanel"
	completion_panel.anchor_left = 0.3
	completion_panel.anchor_top = 0.3
	completion_panel.anchor_right = 0.7
	completion_panel.anchor_bottom = 0.7
	completion_panel.modulate = Color(0, 0, 0, 0.8)
	add_child(completion_panel)
	
	# Título
	var title = Label.new()
	title.text = "PUZZLE COMPLETADO!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.position = Vector2(0, -50)
	title.modulate = Color(0.8, 0.4, 0.2)
	completion_panel.add_child(title)
	
	# Pontuação
	var score_text = Label.new()
	score_text.text = "Pontuação Total: " + str(int(score.total))
	score_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_text.position = Vector2(0, -10)
	completion_panel.add_child(score_text)
	
	# Detalhes
	var details = Label.new()
	details.text = "Tempo: " + str(int(score.time)) + " | Movimentos: " + str(int(score.moves)) + "\nEficiência: " + str(int(score.efficiency)) + " | Habilidades: " + str(int(score.abilities))
	details.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	details.position = Vector2(0, 20)
	completion_panel.add_child(details)

func complete_level():
	"""Completa todo o nível"""
	current_state = LevelState.COMPLETED
	is_timer_running = false
	
	emit_signal("level_completed", current_puzzle_index)
	
	# Mostrar tela final do nível
	show_level_completion()

func show_level_completion():
	"""Mostra completion screen do nível completo"""
	var final_panel = Control.new()
	final_panel.name = "FinalPanel"
	final_panel.anchor_left = 0.2
	final_panel.anchor_top = 0.2
	final_panel.anchor_right = 0.8
	final_panel.anchor_bottom = 0.8
	final_panel.modulate = Color(0.8, 0.4, 0.2, 0.9)
	add_child(final_panel)
	
	# Título
	var title = Label.new()
	title.text = "A FORJA DE PONTEIROS - CONCLUÍDA!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.position = Vector2(0, -80)
	title.modulate = Color.ORANGE
	final_panel.add_child(title)
	
	# Informações
	var info = Label.new()
	info.text = "Você dominou os conceitos de ponteiros em C/C++!\n\nPróximo nível: A Biblioteca de Objetos (Java/Python)"
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	info.position = Vector2(0, 0)
	final_panel.add_child(info)

# Event handlers
func _on_key_collected(body: Node):
	"""Called quando jogador coleta uma chave"""
	if body.is_in_group("player"):
		var key_node = body.get_parent()
		if key_node.name.begins_with("Key_") and not key_node.is_collected:
			key_node.is_collected = true
			key_node.queue_free()
			show_feedback("Chave coletada!", Color.YELLOW)

func _on_pointer_access(body: Node):
	"""Called quando jogador tenta acessar via ponteiro"""
	if body.is_in_group("player"):
		var target_node = body.get_parent()
		# Verificar se jogador tem habilidade de ponteiro ativa
		if ability_system and ability_system.has_method("is_ability_active"):
			if ability_system.is_ability_active("cpp", 1):  # Ponteiro C++
				target_node.can_access = true
				show_feedback("Acesso via ponteiro!", Color.ORANGE)
				ability_used_count["cpp"] = ability_used_count.get("cpp", 0) + 1
				update_ability_counter()
			else:
				show_feedback("Requer ponteiro!", Color.RED)

func _on_pointer_func_used(body: Node):
	"""Called quando ponteiro de função é usado"""
	if body.is_in_group("player"):
		var ptr_func_node = body.get_parent()
		if not ptr_func_node.is_active:
			ptr_func_node.is_active = true
			ptr_func_node.modulate = Color.WHITE
			show_feedback("Função executada via ponteiro!", Color.YELLOW)
			ability_used_count["cpp"] = ability_used_count.get("cpp", 0) + 1
			update_ability_counter()

func _on_gem_collected(body: Node):
	"""Called quando gema é coletada"""
	if body.is_in_group("player"):
		var gem_node = body.get_parent()
		if not gem_node.is_collected:
			# Verificar requisitos
			var can_collect = true
			if gem_node.requires_pointer:
				can_collect = ability_system and ability_system.has_method("is_ability_active") and ability_system.is_ability_active("cpp", 1)
			elif gem_node.requires_chain:
				can_collect = check_reference_chain_complete()
			
			if can_collect:
				gem_node.is_collected = true
				gem_node.queue_free()
				show_feedback("Gema especial coletada!", Color.GOLD)

func check_reference_chain_complete() -> bool:
	"""Verifica se cadeia de referências está completa"""
	# Implementação simplificada - em versão real verificaria todos os nós
	return true  # Placeholder

func show_feedback(message: String, color: Color):
	"""Mostra feedback temporário"""
	var feedback = Label.new()
	feedback.text = message
	feedback.modulate = color
	feedback.position = Vector2(200, 120)
	add_child(feedback)
	
	# Animar e remover
	var tween = create_tween()
	tween.tween_property(feedback, "position", Vector2(200, 100), 1.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(feedback, "modulate", Color.TRANSPARENT, 0.5)
	tween.tween_callback(feedback.queue_free)

# Métodos públicos
func get_level_info() -> Dictionary:
	"""Retorna informações do nível"""
	return {
		"name": level_name,
		"description": level_description,
		"current_puzzle": current_puzzle_index + 1,
		"total_puzzles": available_puzzles.size(),
		"moves_used": moves_used,
		"time_elapsed": level_timer,
		"abilities_used": ability_used_count,
		"state": LevelState.keys()[current_state]
	}

# Sinais
signal puzzle_loaded(puzzle_index: int)
signal level_completed(puzzle_count: int)
signal puzzle_completed(score: Dictionary)
func _exit_tree():
    print("🧹 Level'${level_num}': Cleanup automático")
    concepts.clear()
    containers.clear()
    deployments.clear()
    services.clear()
