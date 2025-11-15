# THE CORE DESCENT - EXEMPLO DE NÍVEL 1
# Arquivo: Level1.gd - Implementação do primeiro nível

extends Node2D
class_name Level1

# Configurações do nível
@export var level_name: String = "A Torre de Marfim"
@export var level_description: String = "Aprenda lógica básica com blocos de alto nível"
@export var target_moves: int = 8  # Número ideal de movimentos
@export var grid_width: int = 20
@export var grid_height: int = 15

# Referências aos sistemas
var game_manager: Node
var drag_system: DragAndDropSystem
var player: PlayerController
var ui_manager: Node

# Estado do nível
enum LevelState { LOADING, PLAYING, COMPLETED, FAILED }
var current_state: LevelState = LevelState.LOADING

# Dados do nível
var start_position: Vector2i = Vector2i(2, 7)
var goal_position: Vector2i = Vector2i(17, 7)
var start_block: LogicBlock
var goal_block: LogicBlock

# Objetivo atual
var moves_used: int = 0
var blocks_placed: int = 0
var level_timer: float = 0.0
var is_timer_running: bool = false

# Puzzles disponíveis
var available_puzzles: Array[Dictionary] = []
var current_puzzle_index: int = 0

# UI Elements
var move_counter: Label
var timer_label: Label
var puzzle_title: Label
var instructions_label: Label

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
	puzzle_title.text = "PUZZLE 1: CAMINHO BÁSICO"
	puzzle_title.position = Vector2(20, 20)
	puzzle_title.modulate = Color.CYAN
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
	
	# Instruções
	instructions_label = Label.new()
	instructions_label.text = "Arraste os blocos para criar um caminho do início ao fim.\nO IF verifica se você coletou a chave azul!"
	instructions_label.position = Vector2(20, 120)
	instructions_label.size = Vector2(400, 60)
	ui_container.add_child(instructions_label)

func load_available_puzzles():
	"""Carrega puzzles disponíveis para este nível"""
	available_puzzles = [
		{
			"name": "Caminho Básico",
			"description": "Use um bloco IF para verificar se tem a chave",
			"blocks_needed": ["IF", "MOVE", "MOVE"],
			"start_pos": Vector2i(2, 7),
			"goal_pos": Vector2i(17, 7),
			"special_items": [{"type": "key", "color": "blue", "pos": Vector2i(8, 7)}],
			"solution_steps": [
				"Coletar chave azul",
				"IF chave_coletada",
				"Mover para o caminho direto",
				"Mover até o fim"
			]
		},
		{
			"name": "Loop Simples",
			"description": "Use um FOR para coletar múltiplas chaves",
			"blocks_needed": ["FOR", "MOVE", "MOVE", "MOVE"],
			"start_pos": Vector2i(2, 7),
			"goal_pos": Vector2i(17, 7),
			"special_items": [
				{"type": "key", "color": "red", "pos": Vector2i(5, 6)},
				{"type": "key", "color": "red", "pos": Vector2i(5, 8)},
				{"type": "key", "color": "red", "pos": Vector2i(9, 7)}
			],
			"solution_steps": [
				"FOR 3x: Coletar chaves vermelhas",
				"Mover para baixo",
				"Mover para direita",
				"Mover até o fim"
			]
		},
		{
			"name": "Condição Dupla",
			"description": "Combine IF e ELSE para caminhos alternativos",
			"blocks_needed": ["IF", "ELSE", "MOVE", "MOVE", "MOVE"],
			"start_pos": Vector2i(2, 7),
			"goal_pos": Vector2i(17, 7),
			"special_items": [
				{"type": "key", "color": "green", "pos": Vector2i(6, 6)},
				{"type": "door", "color": "red", "pos": Vector2i(10, 7), "requires": "blue"}
			],
			"solution_steps": [
				"Verificar se tem chave azul",
				"IF: usar chave para abrir porta vermelha",
				"ELSE: pegar chave verde e ir por cima",
				"Mover ao longo do caminho escolhido",
				"Mover até o fim"
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
	instructions_label.text = puzzle.description
	
	# Reset do nível
	reset_level()
	
	# Configurar posições
	start_position = puzzle.start_pos
	goal_position = puzzle.goal_pos
	
	# Criar blocos especiais
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
	
	# Atualizar UI
	move_counter.text = "Movimentos: 0/" + str(target_moves)
	timer_label.text = "Tempo: 0.0s"
	
	# Resetar jogador
	if player:
		player.reset()

func clear_all_blocks():
	"""Remove todos os blocos do nível"""
	var blocks = get_tree().get_nodes_in_group("logic_blocks")
	for block in blocks:
		block.queue_free()

func create_special_items(items: Array):
	"""Cria itens especiais (chaves, portas, etc.)"""
	for item in items:
		match item.type:
			"key":
				create_key(item.color, item.pos)
			"door":
				create_door(item.color, item.pos, item.get("requires", ""))
			"gem":
				create_gem(item.pos)

func create_key(color: String, grid_pos: Vector2i):
	"""Cria uma chave coletável"""
	var key = Node2D.new()
	key.name = "Key_" + color
	key.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/key_" + color + ".png")
	sprite.modulate = get_color_by_name(color)
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

func create_door(color: String, grid_pos: Vector2i, required_key: String = ""):
	"""Cria uma porta bloqueadora"""
	var door = Node2D.new()
	door.name = "Door_" + color
	door.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	door.required_key = required_key
	door.is_open = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/door_" + color + ".png")
	sprite.modulate = get_color_by_name(color)
	door.add_child(sprite)
	
	add_child(door)

func create_gem(grid_pos: Vector2i):
	"""Cria uma gema coletável"""
	var gem = Node2D.new()
	gem.name = "Gem"
	gem.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/gem.png")
	sprite.modulate = Color.GOLD
	gem.add_child(sprite)
	
	add_child(gem)

func get_color_by_name(color_name: String) -> Color:
	"""Converte nome de cor para Color object"""
	var colors = {
		"blue": Color.BLUE,
		"red": Color.RED,
		"green": Color.GREEN,
		"yellow": Color.YELLOW,
		"purple": Color.PURPLE
	}
	return colors.get(color_name, Color.WHITE)

func create_initial_blocks(blocks_needed: Array):
	"""Cria blocos iniciais disponíveis para o jogador"""
	var palette_position = Vector2(50, 200)  # Posição da paleta de blocos
	
	var block_spawners = {
		"IF": LogicBlock.BlockType.IF,
		"ELSE": LogicBlock.BlockType.ELSE,
		"FOR": LogicBlock.BlockType.FOR,
		"WHILE": LogicBlock.BlockType.WHILE,
		"VARIABLE": LogicBlock.BlockType.VARIABLE,
		"MOVE": LogicBlock.BlockType.MOVE,
		"ASSIGN": LogicBlock.BlockType.ASSIGN
	}
	
	var x_offset = 0
	for block_type_name in blocks_needed:
		if block_spawners.has(block_type_name):
			var block_type = block_spawners[block_type_name]
			var block = create_spawner_block(block_type, palette_position + Vector2(x_offset, 0))
			x_offset += 50

func create_spawner_block(block_type: LogicBlock.BlockType, position: Vector2) -> LogicBlock:
	"""Cria bloco no spawner (paleta)"""
	var block = LogicBlock.new()
	block.block_type = block_type
	block.position = position
	block.is_spawner = true  # Marca como bloco da paleta
	block.z_index = 10  # Acima de outros blocos
	
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
	
	# Calcular pontuação
	var score = calculate_puzzle_score()
	
	# Mostrar resultado
	show_puzzle_completion(score)
	
	# Aguardar antes de carregar próximo puzzle
	await get_tree().create_timer(2.0).timeout
	
	load_puzzle(current_puzzle_index + 1)

func calculate_puzzle_score() -> Dictionary:
	"""Calcula pontuação baseada em performance"""
	var time_score = max(0, 100 - int(level_timer))
	var moves_score = max(0, 100 - (moves_used * 10))
	var efficiency_score = blocks_placed > 0 ? 100 - (abs(blocks_placed - target_moves) * 5) : 50
	
	return {
		"time": time_score,
		"moves": moves_score,
		"efficiency": efficiency_score,
		"total": (time_score + moves_score + efficiency_score) / 3
	}

func show_puzzle_completion(score: Dictionary):
	"""Mostra tela de completion do puzzle"""
	var completion_panel = Control.new()
	completion_panel.name = "CompletionPanel"
	completion_panel.anchor_left = 0.3
	completion_panel.anchor_top = 0.3
	completion_panel.anchor_right = 0.7
	completion_panel.anchor_bottom = 0.7
	completion_panel.modulate = Color.BLACK.with_alpha(0.8)
	add_child(completion_panel)
	
	# Título
	var title = Label.new()
	title.text = "PUZZLE COMPLETADO!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.position = Vector2(0, -50)
	completion_panel.add_child(title)
	
	# Pontuação
	var score_text = Label.new()
	score_text.text = "Pontuação Total: " + str(int(score.total))
	score_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_text.position = Vector2(0, -10)
	completion_panel.add_child(score_text)
	
	# Detalhes
	var details = Label.new()
	details.text = "Tempo: " + str(int(score.time)) + " | Movimentos: " + str(int(score.moves)) + " | Eficiência: " + str(int(score.efficiency))
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
	final_panel.modulate = Color(0, 0.2, 0.4, 0.9)
	add_child(final_panel)
	
	# Título
	var title = Label.new()
	title.text = "TORRE DE MARFIM - CONCLUÍDA!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.position = Vector2(0, -80)
	title.modulate = Color.CYAN
	final_panel.add_child(title)
	
	# Informações
	var info = Label.new()
	info.text = "Você dominou os conceitos básicos de lógica de programação!\n\nPróximo nível: A Forja de Ponteiros (C/C++)"
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	info.position = Vector2(0, 0)
	final_panel.add_child(info)

# Event handlers
func _on_key_collected(body: Node):
	"""Called quando jogador coleta uma chave"""
	if body.is_in_group("player"):
		var key_node = body.get_parent()
		if key_node.name.begins_with("Key_"):
			# Marcar chave como coletada
			key_node.queue_free()
			
			# Feedback visual
			show_feedback("Chave coletada!", Color.YELLOW)

func _on_door_opened():
	"""Called quando porta é aberta"""
	show_feedback("Porta aberta!", Color.GREEN)

func show_feedback(message: String, color: Color):
	"""Mostra feedback temporário"""
	var feedback = Label.new()
	feedback.text = message
	feedback.modulate = color
	feedback.position = Vector2(200, 100)
	add_child(feedback)
	
	# Animar e remover
	var tween = create_tween()
	tween.tween_property(feedback, "position", Vector2(200, 80), 1.0).set_trans(Tween.TRANS_SINE)
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
		"state": LevelState.keys()[current_state]
	}

# Sinais
signal puzzle_loaded(puzzle_index: int)
signal level_completed(puzzle_count: int)
signal puzzle_completed(score: Dictionary)