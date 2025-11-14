# THE CORE DESCENT - ARQUITETURA DE CÓDIGO
# Arquivo: LogicBlock.gd - Classe base para blocos de lógica

extends Node2D
class_name LogicBlock

# Tipos de blocos disponíveis
enum BlockType { 
	IF, 
	ELSE, 
	FOR, 
	WHILE, 
	VARIABLE, 
	ASSIGN, 
	MOVE 
}

# Estados do bloco
enum BlockState { 
	IDLE, 
	DRAGGING, 
	SNAP_TO_GRID, 
	CONNECTED, 
	INVALID 
}

# Propriedades exportadas para editor
@export var block_type: BlockType = BlockType.IF
@export var grid_size: int = 32
@export var snap_threshold: float = 16.0
@export var visual_color: Color = Color.BLUE

# Propriedades internas
var current_state: BlockState = BlockState.IDLE
var grid_position: Vector2i = Vector2i.ZERO
var input_connections: Array[Vector2i] = []
var output_connections: Array[Vector2i] = []
var is_draggable: bool = true

# Componentes visuais
var sprite: Sprite2D
var collision_shape: CollisionShape2D
var connection_points: Node2D

# Referências
var game_manager: Node

func _ready():
	setup_visual()
	setup_connections()
	setup_collision()
	connect_signals()

func setup_visual():
	"""Configura a aparência visual do bloco"""
	sprite = Sprite2D.new()
	sprite.texture = load_block_texture()
	sprite.modulate = visual_color
	add_child(sprite)
	
	# Label com tipo do bloco
	var label = Label.new()
	label.text = get_block_type_name()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.position = Vector2(-20, -8)
	add_child(label)

func setup_connections():
	"""Configura pontos de conexão visual"""
	connection_points = Node2D.new()
	add_child(connection_points)
	
	# Adicionar pontos de conexão baseado no tipo
	match block_type:
		BlockType.IF:
			add_connection_point(Vector2(-16, 0), "input")  # Entrada
			add_connection_point(Vector2(16, -8), "true_output")  # Saída verdade
			add_connection_point(Vector2(16, 8), "false_output")  # Saída falsa
		BlockType.FOR, BlockType.WHILE:
			add_connection_point(Vector2(-16, 0), "input")  # Entrada
			add_connection_point(Vector2(16, 0), "output")  # Saída
			add_connection_point(Vector2(0, -16), "counter")  # Contador
		_:
			add_connection_point(Vector2(-16, 0), "input")  # Entrada
			add_connection_point(Vector2(16, 0), "output")  # Saída

func add_connection_point(position: Vector2, connection_type: String):
	"""Adiciona um ponto de conexão visual"""
	var point = ConnectionPoint.new()
	point.position = position
	point.connection_type = connection_type
	connection_points.add_child(point)

func setup_collision():
	"""Configura área de colisão para interações"""
	collision_shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(grid_size, grid_size)
	collision_shape.shape = rect
	add_child(collision_shape)

func connect_signals():
	"""Conecta sinais para interações"""
	# Se disponível, conectar com game manager
	if get_tree().current_scene.has_method("get_game_manager"):
		game_manager = get_tree().current_scene.get_game_manager()

func load_block_texture() -> Texture2D:
	"""Carrega textura baseada no tipo de bloco"""
	var textures = {
		BlockType.IF: "res://assets/textures/block_if.png",
		BlockType.ELSE: "res://assets/textures/block_else.png", 
		BlockType.FOR: "res://assets/textures/block_for.png",
		BlockType.WHILE: "res://assets/textures/block_while.png",
		BlockType.VARIABLE: "res://assets/textures/block_variable.png",
		BlockType.ASSIGN: "res://assets/textures/block_assign.png",
		BlockType.MOVE: "res://assets/textures/block_move.png"
	}
	
	var texture_path = textures.get(block_type, "res://assets/textures/block_default.png")
	return load(texture_path) if ResourceLoader.exists(texture_path) else create_default_texture()

func create_default_texture() -> Texture2D:
	"""Cria textura padrão se arquivo não existir"""
	var image = Image.create(grid_size, grid_size, false, Image.FORMAT_RGBA8)
	image.fill(visual_color)
	return ImageTexture.create_from_image(image)

func get_block_type_name() -> String:
	"""Retorna nome amigável do tipo de bloco"""
	var names = {
		BlockType.IF: "IF",
		BlockType.ELSE: "ELSE", 
		BlockType.FOR: "FOR",
		BlockType.WHILE: "WHILE",
		BlockType.VARIABLE: "VAR",
		BlockType.ASSIGN: "=",
		BlockType.MOVE: "MOVE"
	}
	return names.get(block_type, "BLOCK")

func _input(event):
	"""Manipula input do usuário"""
	if not is_draggable:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_drag()
			else:
				end_drag()

func start_drag():
	"""Inicia operação de arrastar"""
	if current_state == BlockState.IDLE:
		current_state = BlockState.DRAGGING
		z_index = 100  # Trazer para frente
		emit_signal("drag_started", self)

func end_drag():
	"""Finaliza operação de arrastar"""
	if current_state == BlockState.DRAGGING:
		attempt_snap()
		z_index = 0  # Restaurar ordem normal
		emit_signal("drag_ended", self)

func attempt_snap():
	"""Tenta encaixar na grade"""
	var mouse_pos = get_global_mouse_position()
	var grid_pos = Vector2i(
		int(round(mouse_pos.x / grid_size)),
		int(round(mouse_pos.y / grid_size))
	)
	
	if is_valid_grid_position(grid_pos):
		snap_to_grid_position(grid_pos)
		current_state = BlockState.SNAP_TO_GRID
	else:
		current_state = BlockState.INVALID

func snap_to_grid_position(grid_pos: Vector2i):
	"""Move bloco para posição na grade"""
	grid_position = grid_pos
	global_position = Vector2(grid_pos.x * grid_size, grid_pos.y * grid_size)

func is_valid_grid_position(grid_pos: Vector2i) -> bool:
	"""Verifica se posição na grade é válida"""
	# Verificar limites da área de jogo
	var game_area = get_game_area_bounds()
	if grid_pos.x < 0 or grid_pos.y < 0:
		return false
	if grid_pos.x > game_area.x or grid_pos.y > game_area.y:
		return false
	
	# Verificar colisão com outros blocos
	return not has_block_collision(grid_pos)

func has_block_collision(grid_pos: Vector2i) -> bool:
	"""Verifica colisão com outros blocos na mesma posição"""
	# Implementar verificação de colisão
	# Por enquanto, sempre retornar false para protótipo
	return false

func get_game_area_bounds() -> Vector2i:
	"""Retorna limites da área de jogo"""
	# Configurar baseado no tamanho da tela ou nível
	return Vector2i(20, 15)  # 20x15 grids como exemplo

func can_connect(target_block: LogicBlock) -> bool:
	"""Verifica se pode conectar com outro bloco"""
	if not target_block:
		return false
	
	# Verificar compatibilidade de tipos
	return is_connection_compatible(target_block.block_type)

func is_connection_compatible(target_type: BlockType) -> bool:
	"""Verifica compatibilidade entre tipos de conexão"""
	match block_type:
		BlockType.IF:
			return target_type in [BlockType.ELSE, BlockType.MOVE]
		BlockType.FOR, BlockType.WHILE:
			return target_type == BlockType.MOVE
		_:
			return target_type != BlockType.IF  # Evitar loops IF-IF

func reset():
	"""Reset o bloco para estado inicial"""
	current_state = BlockState.IDLE
	grid_position = Vector2i.ZERO
	global_position = Vector2.ZERO
	z_index = 0

func get_debug_info() -> Dictionary:
	"""Retorna informações para debug"""
	return {
		"type": get_block_type_name(),
		"grid_pos": grid_position,
		"state": current_state,
		"connections": output_connections.size()
	}

# Sinais
signal drag_started(block: LogicBlock)
signal drag_ended(block: LogicBlock) 
signal block_snap(block: LogicBlock, grid_pos: Vector2i)
signal connection_made(block: LogicBlock, target: LogicBlock)

# Classe interna para pontos de conexão
class ConnectionPoint:
	extends Node2D
	
	var connection_type: String = "input"
	var is_active: bool = true
	
	func _ready():
		# Desenhar ponto de conexão visualmente
		update()
	
	func _draw():
		var color = Color.GREEN if is_active else Color.RED
		draw_circle(Vector2.ZERO, 4, color)
	
	func set_active(active: bool):
		is_active = active
		update()