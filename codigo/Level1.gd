# THE CORE DESCENT - EXEMPLO DE NÍVEL 1
# Arquivo: Level1.gd - Implementação do primeiro nível (REFATORADO)
# Agora estende BaseLevel para reduzir boilerplate

extends BaseLevel
class_name Level1

# Dados do nível (posições específicas deste nível)
var start_position: Vector2i = Vector2i(2, 7)
var goal_position: Vector2i = Vector2i(17, 7)
var start_block: LogicBlock
var goal_block: LogicBlock

# Sinais
signal puzzle_loaded(puzzle_index: int)
signal level_completed(puzzle_count: int)
signal puzzle_completed(score: Dictionary)

func _init():
	# Configurar metadados do nível
	level_name = "A Torre de Marfim"
	level_description = "Aprenda lógica básica com blocos de alto nível"
	target_moves = 8
	grid_width = 20
	grid_height = 15

# Override: Hook chamado após setup base completo
func _on_level_ready():
	load_available_puzzles()
	load_puzzle(0)

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
	
	# Atualizar UI via métodos base
	set_puzzle_title("PUZZLE " + str(puzzle_index + 1) + ": " + puzzle.name)
	set_instructions(puzzle.description)
	
	# Reset do nível via método base
	reset()
	
	# Configurar posições
	start_position = puzzle.start_pos
	goal_position = puzzle.goal_pos
	
	# Criar blocos especiais
	create_special_items(puzzle.special_items)
	
	# Criar blocos iniciais
	create_initial_blocks(puzzle.blocks_needed)
	
	# Posicionar jogador
	position_player_at_start()
	
	# Iniciar estado via método base
	start_level()
	
	emit_signal("puzzle_loaded", puzzle_index)

# Override: Método _process da base já cuida do timer
func _process(delta):
	super._process(delta)  # Chama implementação base (timer)
	
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
	var efficiency_score = 100 - (abs(blocks_placed - target_moves) * 5) if blocks_placed > 0 else 50
	
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