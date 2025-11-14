# THE CORE DESCENT - ARQUITETURA DE CÓDIGO  
# Arquivo: DragAndDropSystem.gd - Sistema de arrastar e soltar

extends Node

# Sistema de arrastar e soltar para blocos de lógica
class_name DragAndDropSystem

# Referências
var game_manager: Node
var camera: Camera2D

# Estado do sistema
var dragged_block: LogicBlock = null
var drag_offset: Vector2 = Vector2.ZERO
var original_position: Vector2 = Vector2.ZERO
var is_dragging: bool = false

# Configurações
@export var snap_threshold: float = 16.0
@export var grid_size: int = 32
@export var highlight_valid_snap: bool = true

# Visual feedback
var snap_preview: Sprite2D
var valid_snap_positions: Array[Vector2i] = []
var current_snap_position: Vector2i = Vector2i(-1, -1)

# Audio feedback
var audio_player: AudioStreamPlayer

func _ready():
	setup_references()
	setup_visual_feedback()
	setup_audio()
	connect_signals()

func setup_references():
	"""Configura referências para outros nós"""
	# Obter game manager
	if get_tree().current_scene.has_method("get_game_manager"):
		game_manager = get_tree().current_scene.get_game_manager()
	
	# Obter câmera
	camera = get_viewport().get_camera_2d()

func setup_visual_feedback():
	"""Configura elementos visuais para feedback"""
	# Criar preview de snap
	snap_preview = Sprite2D.new()
	snap_preview.modulate = Color.GREEN.with_alpha(0.3)
	snap_preview.z_index = 50
	snap_preview.visible = false
	add_child(snap_preview)

func setup_audio():
	"""Configura sistema de áudio para feedback"""
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)

func _input(event):
	"""Processa input do usuário"""
	if event is InputEventMouseButton:
		handle_mouse_button(event)
	elif event is InputEventMouseMotion:
		handle_mouse_motion(event)

func handle_mouse_button(event: InputEventMouseButton):
	"""Manipula cliques do mouse"""
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			attempt_pickup_block()
		else:
			attempt_drop_block()

func handle_mouse_motion(event: InputEventMouseMotion):
	"""Manipula movimento do mouse"""
	if is_dragging and dragged_block:
		update_drag_position()

func attempt_pickup_block():
	"""Tenta pegar um bloco"""
	var mouse_pos = get_global_mouse_position()
	
	# Verificar colisão com blocos
	var blocks = get_tree().get_nodes_in_group("logic_blocks")
	for block in blocks:
		if block.has_method("get_global_rect"):
			var block_rect = block.get_global_rect()
			if block_rect.has_point(mouse_pos):
				start_drag(block as LogicBlock)
				break

func start_drag(block: LogicBlock):
	"""Inicia operação de arrastar"""
	if not block or not block.is_draggable:
		return
		
	dragged_block = block
	is_dragging = true
	
	# Salvar posição original
	original_position = block.global_position
	
	# Calcular offset do mouse
	var mouse_pos = get_global_mouse_position()
	drag_offset = mouse_pos - block.global_position
	
	# Configurar estado do bloco
	dragged_block.current_state = LogicBlock.BlockState.DRAGGING
	dragged_block.z_index = 100
	
	# Mostrar preview de snap
	if highlight_valid_snap:
		show_snap_preview()
	
	# Tocar som de pick up
	play_sound("pickup")
	
	emit_signal("drag_started", block)

func update_drag_position():
	"""Atualiza posição durante arrastar"""
	if not dragged_block:
		return
		
	var mouse_pos = get_global_mouse_position()
	var target_pos = mouse_pos - drag_offset
	
	# Limitar movimento à área de jogo
	target_pos = clamp_to_game_area(target_pos)
	
	dragged_block.global_position = target_pos
	
	# Atualizar preview de snap
	if highlight_valid_snap:
		update_snap_preview()

func attempt_drop_block():
	"""Tenta soltar o bloco"""
	if not is_dragging or not dragged_block:
		return
		
	var snap_position = get_optimal_snap_position()
	
	if snap_position != Vector2i(-1, -1):
		# Snap bem-sucedido
		complete_snap(snap_position)
	else:
		# Voltar à posição original
		cancel_drag()

func complete_snap(grid_pos: Vector2i):
	"""Completa operação de snap"""
	# Mover bloco para posição final
	var world_pos = Vector2(grid_pos.x * grid_size, grid_pos.y * grid_size)
	dragged_block.global_position = world_pos
	dragged_block.grid_position = grid_pos
	dragged_block.current_state = LogicBlock.BlockState.SNAP_TO_GRID
	
	# Limpar referências
	dragged_block.z_index = 0
	dragged_block = null
	is_dragging = false
	
	# Esconder preview
	hide_snap_preview()
	
	# Tocar som de drop
	play_sound("drop")
	
	emit_signal("block_snapped", grid_pos)

func cancel_drag():
	"""Cancela operação de arrastar"""
	if dragged_block:
		# Voltar à posição original
		dragged_block.global_position = original_position
		dragged_block.current_state = LogicBlock.BlockState.IDLE
		dragged_block.z_index = 0
		dragged_block = null
	
	is_dragging = false
	hide_snap_preview()
	
	# Tocar som de cancel
	play_sound("cancel")

func get_optimal_snap_position() -> Vector2i:
	"""Encontra a melhor posição de snap para o bloco arrastado"""
	var mouse_pos = get_global_mouse_position()
	
	# Calcular posição aproximada na grade
	var grid_x = int(round(mouse_pos.x / grid_size))
	var grid_y = int(round(mouse_pos.y / grid_size))
	
	var candidate_pos = Vector2i(grid_x, grid_y)
	
	# Verificar se posição é válida
	if is_valid_snap_position(candidate_pos):
		return candidate_pos
	
	# Se posição principal inválida, buscar posições próximas
	return find_nearest_valid_position(candidate_pos)

func is_valid_snap_position(grid_pos: Vector2i) -> bool:
	"""Verifica se posição na grade é válida para snap"""
	# Verificar limites
	var game_bounds = get_game_area_bounds()
	if grid_pos.x < 0 or grid_pos.y < 0:
		return false
	if grid_pos.x > game_bounds.x or grid_pos.y > game_bounds.y:
		return false
	
	# Verificar se há outro bloco nessa posição
	var blocks = get_tree().get_nodes_in_group("logic_blocks")
	for block in blocks:
		if block != dragged_block and block.grid_position == grid_pos:
			return false
	
	return true

func find_nearest_valid_position(center: Vector2i) -> Vector2i:
	"""Encontra posição válida mais próxima usando busca em espiral"""
	var max_radius = 3  # Buscar em raio máximo de 3
	
	for radius in range(1, max_radius + 1):
		for dx in range(-radius, radius + 1):
			for dy in range(-radius, radius + 1):
				if abs(dx) == radius or abs(dy) == radius:
					var candidate = center + Vector2i(dx, dy)
					if is_valid_snap_position(candidate):
						return candidate
	
	return Vector2i(-1, -1)  # Nenhuma posição válida encontrada

func show_snap_preview():
	"""Mostra preview de posições válidas de snap"""
	if not snap_preview:
		return
		
	snap_preview.visible = true
	valid_snap_positions.clear()
	
	# Calcular área de preview baseada no mouse
	var mouse_pos = get_global_mouse_position()
	var center_grid = Vector2i(
		int(round(mouse_pos.x / grid_size)),
		int(round(mouse_pos.y / grid_size))
	)
	
	# Mostrar posições válidas em área 3x3
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var grid_pos = center_grid + Vector2i(dx, dy)
			if is_valid_snap_position(grid_pos):
				valid_snap_positions.append(grid_pos)
				draw_snap_preview_point(grid_pos)

func update_snap_preview():
	"""Atualiza preview de snap baseado na posição atual"""
	if not snap_preview.visible:
		return
		
	var optimal_pos = get_optimal_snap_position()
	
	if optimal_pos != current_snap_position:
		current_snap_position = optimal_pos
		update_snap_preview_visual()

func update_snap_preview_visual():
	"""Atualiza aparência visual do preview"""
	if not snap_preview:
		return
		
	if current_snap_position != Vector2i(-1, -1):
		# Posição válida - mostrar verde
		var world_pos = Vector2(current_snap_position.x * grid_size, current_snap_position.y * grid_size)
		snap_preview.global_position = world_pos + Vector2(grid_size/2, grid_size/2)
		snap_preview.modulate = Color.GREEN.with_alpha(0.5)
	else:
		# Posição inválida - mostrar vermelho
		snap_preview.modulate = Color.RED.with_alpha(0.3)

func hide_snap_preview():
	"""Esconde preview de snap"""
	if snap_preview:
		snap_preview.visible = false
	current_snap_position = Vector2i(-1, -1)
	valid_snap_positions.clear()

func draw_snap_preview_point(grid_pos: Vector2i):
	"""Desenha ponto de preview para uma posição na grade"""
	# Implementação simplificada - em versão real usaria TileMap
	var world_pos = Vector2(grid_pos.x * grid_size, grid_pos.y * grid_size)
	# Adicionar lógica de desenho aqui

func clamp_to_game_area(position: Vector2) -> Vector2:
	"""Limita posição à área de jogo"""
	var bounds = get_game_area_bounds()
	var max_x = bounds.x * grid_size
	var max_y = bounds.y * grid_size
	
	return Vector2(
		clamp(position.x, 0, max_x),
		clamp(position.y, 0, max_y)
	)

func get_game_area_bounds() -> Vector2i:
	"""Retorna limites da área de jogo"""
	# Configurar baseado no tamanho da tela ou nível
	return Vector2i(20, 15)  # 20x15 grids

func get_global_mouse_position() -> Vector2:
	"""Retorna posição global do mouse"""
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	
	# Converter para posição global se necessário
	if camera:
		return camera.get_global_mouse_position()
	
	return mouse_pos

func play_sound(sound_type: String):
	"""Toca som de feedback"""
	# Implementar sistema de áudio baseado no tipo
	match sound_type:
		"pickup":
			# Tocar som de pegar
			pass
		"drop":
			# Tocar som de soltar
			pass
		"cancel":
			# Tocar som de cancelar
			pass

func cleanup():
	"""Limpa recursos do sistema"""
	hide_snap_preview()
	if dragged_block:
		dragged_block.current_state = LogicBlock.BlockState.IDLE
		dragged_block = null
	is_dragging = false

# Sinais
signal drag_started(block: LogicBlock)
signal drag_ended(block: LogicBlock)
signal block_snapped(grid_pos: Vector2i)
signal invalid_drop(block: LogicBlock)

# Métodos públicos para controle externo
func set_block_draggable(block: LogicBlock, draggable: bool):
	"""Controla se um bloco pode ser arrastado"""
	if block:
		block.is_draggable = draggable

func clear_all_blocks():
	"""Remove todos os blocos da área de jogo"""
	var blocks = get_tree().get_nodes_in_group("logic_blocks")
	for block in blocks:
		block.queue_free()

func get_block_count() -> int:
	"""Retorna número de blocos na área"""
	return get_tree().get_nodes_in_group("logic_blocks").size()

func get_blocks_in_grid_area() -> Array:
	"""Retorna array de blocos organizados por posição na grade"""
	var blocks = get_tree().get_nodes_in_group("logic_blocks")
	var grid_blocks = {}
	
	for block in blocks:
		var pos = block.grid_position
		if not grid_blocks.has(pos):
			grid_blocks[pos] = []
		grid_blocks[pos].append(block)
	
	return grid_blocks