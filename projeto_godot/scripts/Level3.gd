# THE CORE DESCENT - NÍVEL 3: A BIBLIOTECA DE OBJETOS
# Arquivo: Level3.gd - Implementação do terceiro nível com conceitos OOP

extends Node2D
class_name Level3

# Configurações do nível
@export var level_name: String = "A Biblioteca de Objetos"
@export var level_description: String = "Explore orientação a objetos e gerenciamento de memória em Java/Python"
@export var target_moves: int = 15  # Número ideal de movimentos
@export var grid_width: int = 24
@export var grid_height: int = 18

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
var start_position: Vector2i = Vector2i(2, 9)
var goal_position: Vector2i = Vector2i(21, 9)
var start_block: LogicBlock
var goal_block: LogicBlock

# Objetivo atual
var moves_used: int = 0
var blocks_placed: int = 0
var level_timer: float = 0.0
var is_timer_running: bool = false
var ability_used_count: Dictionary = {}  # Contador de uso de habilidades
var objects_created: Array = []  # Objetos criados
var garbage_count: int = 0  # Contador de garbage collection

# Puzzles disponíveis
var available_puzzles: Array[Dictionary] = []
var current_puzzle_index: int = 0

# UI Elements
var move_counter: Label
var timer_label: Label
var puzzle_title: Label
var instructions_label: Label
var object_counter: Label
var garbage_counter: Label

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
	puzzle_title.text = "PUZZLE 1: HERANÇA E POLIMORFISMO"
	puzzle_title.position = Vector2(20, 20)
	puzzle_title.modulate = Color(0.2, 0.6, 1.0)  # Azul para Java
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
	
	# Contador de objetos
	object_counter = Label.new()
	object_counter.text = "Objetos: 0"
	object_counter.position = Vector2(20, 110)
	object_counter.modulate = Color.CYAN
	ui_container.add_child(object_counter)
	
	# Contador de garbage collection
	garbage_counter = Label.new()
	garbage_counter.text = "GC Executado: 0x"
	garbage_counter.position = Vector2(20, 140)
	garbage_counter.modulate = Color(0.5, 1.0, 0.5)  # Verde para Python
	ui_container.add_child(garbage_counter)
	
	# Instruções
	instructions_label = Label.new()
	instructions_label.text = "Use conceitos de OOP para resolver desafios.\nJava (teclas 1-4): Herança e Garbage Collection.\nPython (teclas 5-8): Duck Typing e Garbage Collection!"
	instructions_label.position = Vector2(20, 170)
	instructions_label.size = Vector2(500, 60)
	ui_container.add_child(instructions_label)

func load_available_puzzles():
	"""Carrega puzzles disponíveis para este nível"""
	available_puzzles = [
		{
			"name": "Hierarquia de Classes",
			"description": "Use herança para acessar métodos de classes base",
			"blocks_needed": ["INHERIT", "POLYMORPH", "MOVE", "MOVE", "MOVE", "SUPER"],
			"start_pos": Vector2i(2, 9),
			"goal_pos": Vector2i(21, 9),
			"special_items": [
				{"type": "base_class", "name": "Vehicle", "pos": Vector2i(5, 9), "methods": ["move_forward", "get_speed"]},
				{"type": "derived_class", "name": "Car", "pos": Vector2i(7, 8), "inherits": "Vehicle", "methods": ["honk"]},
				{"type": "derived_class", "name": "Boat", "pos": Vector2i(7, 10), "inherits": "Vehicle", "methods": ["sail"]},
				{"type": "polymorphic_gate", "pos": Vector2i(12, 9), "accepts": "Vehicle", "requires_method": "move_forward"},
				{"type": "gem", "pos": Vector2i(19, 9), "requires_inheritance": true}
			],
			"solution_steps": [
				"Criar classe base Vehicle com método move_forward",
				"Herdar em classes Car e Boat",
				"Usar polimorfismo para acessar método da classe base",
				"Abrir portão que aceita qualquer Vehicle",
				"Coletar gema protegida por herança"
			],
			"hints": [
				"Classes derivadas herdam métodos de suas classes pai",
				"Polimorfismo permite chamar métodos da classe base",
				"Super chama implementações da classe pai"
			],
			"languages": ["java"]
		},
		{
			"name": "Duck Typing Dinâmico",
			description": "Use duck typing para trabalhar com objetos flexíveis",
			"blocks_needed": ["DUCK_TYPE", "IF", "MOVE", "MOVE", "MOVE", "MOVE"],
			"start_pos": Vector2i(2, 9),
			"goal_pos": Vector2i(21, 9),
			"special_items": [
				{"type": "duck_typed_object", "name": "DuckSimulator", "pos": Vector2i(6, 9), "methods": ["quack", "swim"]},
				{"type": "duck_typed_object", "name": "Robot", "pos": Vector2i(8, 8), "methods": ["quack", "beep"]},
				{"type": "duck_typed_object", "name": "Dog", "pos": Vector2i(8, 10), "methods": ["quack", "bark"]},
				{"type": "interface_check", "pos": Vector2i(11, 9), "requires": "quack_method"},
				{"type": "dynamic_door", "pos": Vector2i(15, 9), "opens_with": "any_quack"}
			],
			"solution_steps": [
				"Verificar se objetos têm método quack (duck typing)",
				"Usar objeto que implementa quack para abrir porta",
				"Ignorar outros métodos - só importa quack!",
				"Aproveitar flexibilidade do duck typing"
			],
			"hints": [
				"Duck typing: 'Se anda como pato e faz quack como pato...'",
				"Não importa o tipo real, só os métodos disponíveis",
				"Objetos diferentes podem ter mesmos métodos"
			],
			"languages": ["python"]
		},
		{
			"name": "Gerenciamento de Memória",
			"description": "Use garbage collection para limpar objetos inúteis",
			"blocks_needed": ["CREATE_OBJ", "GARBAGE_COLLECT", "IF", "MOVE", "MOVE", "MOVE"],
			"start_pos": Vector2i(2, 9),
			"goal_pos": Vector2i(21, 9),
			"special_items": [
				{"type": "memory_pool", "pos": Vector2i(6, 9), "size": 5, "filled": 2},
				{"type": "temporary_object", "name": "TempData", "pos": Vector2i(5, 8), "lifetime": 3},
				{"type": "temporary_object", "name": "TempBuffer", "pos": Vector2i(5, 10), "lifetime": 2},
				{"type": "memory_leak", "pos": Vector2i(8, 9), "blocks_access": true},
				{"type": "gc_trigger", "pos": Vector2i(10, 9), "threshold": 70},
				{"type": "clean_memory_gate", "pos": Vector2i(16, 9), "requires_clean": 80}
			],
			"solution_steps": [
				"Criar objetos temporários na pool de memória",
				"Monitorar uso de memória",
				"Executar garbage collection quando necessário",
				"Abrir portão que requer memória limpa",
				"Completar nível com memória otimizada"
			],
			"hints": [
				"Garbage collection limpa objetos não utilizados",
				"Objetos temporários devem ser removidos",
				"Manter uso de memória baixo é essencial"
			],
			"languages": ["java", "python"]
		},
		{
			"name": "Polimorfismo Avançado",
			"description": "Combine herança e interfaces para flexibilidade máxima",
			"blocks_needed": ["INTERFACE", "IMPLEMENTS", "POLYMORPH", "MOVE", "MOVE", "MOVE", "MOVE"],
			"start_pos": Vector2i(2, 9),
			"goal_pos": Vector2i(21, 9),
			"special_items": [
				{"type": "interface", "name": "Drawable", "pos": Vector2i(5, 8), "methods": ["draw", "resize"]},
				{"type": "interface", "name": "Movable", "pos": Vector2i(5, 10), "methods": ["move", "stop"]},
				{"type": "class_implementing", "name": "Sprite", "pos": Vector2i(8, 9), "implements": ["Drawable", "Movable"]},
				{"type": "class_implementing", "name": "Shape", "pos": Vector2i(10, 9), "implements": ["Drawable"]},
				{"type": "polymorphic_container", "pos": Vector2i(14, 9), "accepts": "IDrawable"},
				{"type": "gem", "pos": Vector2i(19, 9), "requires_polymorphism": true}
			],
			"solution_steps": [
				"Definir interfaces Drawable e Movable",
				"Implementar interfaces em diferentes classes",
				"Usar polimorfismo para tratar objetos uniformemente",
				"Abrir container que aceita qualquer Drawable",
				"Coletar gema com máximo polimorfismo"
			],
			"hints": [
				"Interfaces definem contratos, não implementações",
				"Classes podem implementar múltiplas interfaces",
				"Polimorfismo permite tratar objetos diferentes de forma igual"
			],
			"languages": ["java"]
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
	var hint_text = puzzle.hints[0] if puzzle.hints.size() > 0 else ""
	instructions_label.text = puzzle.description + "\nDica: " + hint_text
	
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
	
	# Limpar objetos criados
	for obj in objects_created:
		if is_instance_valid(obj):
			obj.queue_free()
	objects_created.clear()
	
	# Reset contadores
	moves_used = 0
	blocks_placed = 0
	level_timer = 0.0
	ability_used_count.clear()
	garbage_count = 0
	
	# Atualizar UI
	move_counter.text = "Movimentos: 0/" + str(target_moves)
	timer_label.text = "Tempo: 0.0s"
	update_counters()

func clear_all_blocks():
	"""Remove todos os blocos do nível"""
	var blocks = get_tree().get_nodes_in_group("logic_blocks")
	for block in blocks:
		block.queue_free()

func update_counters():
	"""Atualiza todos os contadores"""
	object_counter.text = "Objetos: " + str(objects_created.size())
	garbage_counter.text = "GC Executado: " + str(garbage_count) + "x"

func create_special_items(items: Array):
	"""Cria itens especiais específicos do nível"""
	for item in items:
		match item.type:
			"base_class":
				create_base_class(item.name, item.pos, item.methods)
			"derived_class":
				create_derived_class(item.name, item.pos, item.inherits, item.methods)
			"polymorphic_gate":
				create_polymorphic_gate(item.pos, item.accepts, item.requires_method)
			"duck_typed_object":
				create_duck_typed_object(item.name, item.pos, item.methods)
			"interface_check":
				create_interface_check(item.pos, item.requires)
			"dynamic_door":
				create_dynamic_door(item.pos, item.opens_with)
			"memory_pool":
				create_memory_pool(item.pos, item.size, item.filled)
			"temporary_object":
				create_temporary_object(item.name, item.pos, item.lifetime)
			"memory_leak":
				create_memory_leak(item.pos)
			"gc_trigger":
				create_gc_trigger(item.pos, item.threshold)
			"clean_memory_gate":
				create_clean_memory_gate(item.pos, item.requires_clean)
			"interface":
				create_interface_definition(item.name, item.pos, item.methods)
			"class_implementing":
				create_implementing_class(item.name, item.pos, item.implements)
			"polymorphic_container":
				create_polymorphic_container(item.pos, item.accepts)
			"gem":
				create_gem(item.pos, item.get("requires_inheritance", false), item.get("requires_polymorphism", false))

func create_base_class(name: String, grid_pos: Vector2i, methods: Array):
	"""Cria classe base para herança"""
	var base_class = Node2D.new()
	base_class.name = "BaseClass_" + name
	base_class.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	base_class.class_name = name
	base_class.methods = methods
	base_class.is_base = true
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/base_class.png")
	sprite.modulate = Color(0.2, 0.6, 1.0)  # Azul para Java
	base_class.add_child(sprite)
	
	# Adicionar método labels
	for i in range(methods.size()):
		var method_label = Label.new()
		method_label.text = methods[i]
		method_label.position = Vector2(0, 20 + i * 15)
		method_label.modulate = Color.WHITE
		base_class.add_child(method_label)
	
	add_child(base_class)

func create_derived_class(name: String, grid_pos: Vector2i, inherits: String, methods: Array):
	"""Cria classe derivada"""
	var derived_class = Node2D.new()
	derived_class.name = "DerivedClass_" + name
	derived_class.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	derived_class.class_name = name
	derived_class.inherits = inherits
	derived_class.methods = methods
	derived_class.is_derived = true
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/derived_class.png")
	sprite.modulate = Color(0.4, 0.8, 1.0)  # Azul mais claro
	derived_class.add_child(sprite)
	
	# Herança visual
	var inheritance_line = Line2D.new()
	inheritance_line.points = [Vector2(0, -20), Vector2(-20, -40), Vector2(-60, -40)]
	inheritance_line.default_color = Color.YELLOW
	inheritance_line.width = 2
	derived_class.add_child(inheritance_line)
	
	# Labels de métodos
	for i in range(methods.size()):
		var method_label = Label.new()
		method_label.text = methods[i]
		method_label.position = Vector2(0, 20 + i * 15)
		method_label.modulate = Color.WHITE
		derived_class.add_child(method_label)
	
	add_child(derived_class)

func create_polymorphic_gate(grid_pos: Vector2i, accepts: String, requires_method: String):
	"""Cria portão que aceita objetos da hierarquia"""
	var gate = Node2D.new()
	gate.name = "PolymorphicGate"
	gate.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	gate.accepts_type = accepts
	gate.requires_method = requires_method
	gate.is_open = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/polymorphic_gate.png")
	sprite.modulate = Color(0.3, 0.7, 1.0)
	gate.add_child(sprite)
	
	# Label do tipo aceito
	var type_label = Label.new()
	type_label.text = accepts
	type_label.position = Vector2(-15, -20)
	type_label.modulate = Color.CYAN
	gate.add_child(type_label)
	
	add_child(gate)

func create_duck_typed_object(name: String, grid_pos: Vector2i, methods: Array):
	"""Cria objeto com duck typing"""
	var duck_obj = Node2D.new()
	duck_obj.name = "DuckObject_" + name
	duck_obj.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	duck_obj.object_name = name
	duck_obj.methods = methods
	duck_obj.has_quack = methods.has("quack")
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/duck_object.png")
	sprite.modulate = Color(0.5, 1.0, 0.5)  # Verde para Python
	duck_obj.add_child(sprite)
	
	# Label do objeto
	var name_label = Label.new()
	name_label.text = name
	name_label.position = Vector2(-15, -20)
	name_label.modulate = Color.WHITE
	duck_obj.add_child(name_label)
	
	add_child(duck_obj)

func create_interface_check(grid_pos: Vector2i, requires: String):
	"""Cria verificador de interface"""
	var checker = Node2D.new()
	checker.name = "InterfaceChecker"
	checker.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	checker.requires_method = requires
	checker.is_satisfied = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/interface_check.png")
	sprite.modulate = Color(1, 1, 0)  # Amarelo
	checker.add_child(sprite)
	
	# Label do método requerido
	var method_label = Label.new()
	method_label.text = requires
	method_label.position = Vector2(-20, -25)
	method_label.modulate = Color.YELLOW
	checker.add_child(method_label)
	
	add_child(checker)

func create_dynamic_door(grid_pos: Vector2i, opens_with: String):
	"""Cria porta que abre com ação dinâmica"""
	var door = Node2D.new()
	door.name = "DynamicDoor"
	door.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	door.opens_with_action = opens_with
	door.is_open = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/dynamic_door.png")
	sprite.modulate = Color(0.8, 0.4, 0.8)  # Roxo
	door.add_child(sprite)
	
	add_child(door)

func create_memory_pool(grid_pos: Vector2i, size: int, filled: int):
	"""Cria pool de memória"""
	var pool = Node2D.new()
	pool.name = "MemoryPool"
	pool.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	pool.max_size = size
	pool.current_size = filled
	pool.usage_percent = (float(filled) / float(size)) * 100
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/memory_pool.png")
	sprite.modulate = Color(0.5, 1.0, 0.5)
	pool.add_child(sprite)
	
	# Visualização do uso
	var usage_bar = ColorRect.new()
	usage_bar.size = Vector2(24, 4)
	usage_bar.position = Vector2(-12, 15)
	if pool.usage_percent > 70:
		usage_bar.modulate = Color.RED
	elif pool.usage_percent > 40:
		usage_bar.modulate = Color.YELLOW
	else:
		usage_bar.modulate = Color.GREEN
	pool.add_child(usage_bar)
	
	add_child(pool)

func create_temporary_object(name: String, grid_pos: Vector2i, lifetime: int):
	"""Cria objeto temporário"""
	var temp_obj = Node2D.new()
	temp_obj.name = "TempObject_" + name
	temp_obj.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	temp_obj.object_name = name
	temp_obj.lifetime = lifetime
	temp_obj.time_left = lifetime
	temp_obj.is_temporary = true
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/temp_object.png")
	sprite.modulate = Color(1, 0.5, 0.5)  # Rosa claro
	temp_obj.add_child(sprite)
	
	# Timer para life time
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.connect("timeout", Callable(self, "_on_temp_object_expired").bind(temp_obj))
	temp_obj.add_child(timer)
	timer.start()
	
	add_child(temp_obj)

func create_memory_leak(grid_pos: Vector2i):
	"""Cria vazamento de memória"""
	var leak = Node2D.new()
	leak.name = "MemoryLeak"
	leak.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	leak.is_blocking = true
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/memory_leak.png")
	sprite.modulate = Color(1, 0, 0)  # Vermelho para indicar problema
	leak.add_child(sprite)
	
	add_child(leak)

func create_gc_trigger(grid_pos: Vector2i, threshold: int):
	"""Cria gatilho de garbage collection"""
	var trigger = Node2D.new()
	trigger.name = "GCTrigger"
	trigger.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	trigger.threshold = threshold
	trigger.is_activated = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/gc_trigger.png")
	sprite.modulate = Color(0.5, 1.0, 0.5)
	trigger.add_child(sprite)
	
	# Label do threshold
	var threshold_label = Label.new()
	threshold_label.text = str(threshold) + "%"
	threshold_label.position = Vector2(-10, -20)
	threshold_label.modulate = Color.GREEN
	trigger.add_child(threshold_label)
	
	add_child(trigger)

func create_clean_memory_gate(grid_pos: Vector2i, requires_clean: int):
	"""Cria portão que requer memória limpa"""
	var gate = Node2D.new()
	gate.name = "CleanMemoryGate"
	gate.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	gate.requires_clean_percent = requires_clean
	gate.is_open = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/clean_gate.png")
	sprite.modulate = Color(0, 1, 0)  # Verde para limpo
	gate.add_child(sprite)
	
	add_child(gate)

func create_interface_definition(name: String, grid_pos: Vector2i, methods: Array):
	"""Cria definição de interface"""
	var interface = Node2D.new()
	interface.name = "Interface_" + name
	interface.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	interface.interface_name = name
	interface.methods = methods
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/interface.png")
	sprite.modulate = Color(0.2, 0.6, 1.0)
	interface.add_child(sprite)
	
	# Label da interface
	var name_label = Label.new()
	name_label.text = "I" + name
	name_label.position = Vector2(-10, -20)
	name_label.modulate = Color.CYAN
	interface.add_child(name_label)
	
	add_child(interface)

func create_implementing_class(name: String, grid_pos: Vector2i, implements: Array):
	"""Cria classe que implementa interfaces"""
	var impl_class = Node2D.new()
	impl_class.name = "ImplementingClass_" + name
	impl_class.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	impl_class.class_name = name
	impl_class.implements = implements
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/implementing_class.png")
	sprite.modulate = Color(0.4, 0.8, 1.0)
	impl_class.add_child(sprite)
	
	# Label da classe
	var name_label = Label.new()
	name_label.text = name
	name_label.position = Vector2(-15, -20)
	name_label.modulate = Color.WHITE
	impl_class.add_child(name_label)
	
	add_child(impl_class)

func create_polymorphic_container(grid_pos: Vector2i, accepts: String):
	"""Cria container polimórfico"""
	var container = Node2D.new()
	container.name = "PolymorphicContainer"
	container.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	container.accepts_type = accepts
	container.contents = []
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/poly_container.png")
	sprite.modulate = Color(0.3, 0.7, 1.0)
	container.add_child(sprite)
	
	# Label do tipo aceito
	var type_label = Label.new()
	type_label.text = accepts
	type_label.position = Vector2(-20, -25)
	type_label.modulate = Color.CYAN
	container.add_child(type_label)
	
	add_child(container)

func create_gem(grid_pos: Vector2i, requires_inheritance: bool = false, requires_polymorphism: bool = false):
	"""Cria gema com requisitos OOP"""
	var gem = Node2D.new()
	gem.name = "Gem"
	gem.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	gem.requires_inheritance = requires_inheritance
	gem.requires_polymorphism = requires_polymorphism
	gem.is_collected = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/gem.png")
	if requires_inheritance or requires_polymorphism:
		sprite.modulate = Color(1, 0.84, 0, 0.7)
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

func create_initial_blocks(blocks_needed: Array):
	"""Cria blocos iniciais disponíveis para o jogador"""
	var palette_position = Vector2(50, 250)
	
	var block_spawners = {
		"IF": LogicBlock.BlockType.IF,
		"ELSE": LogicBlock.BlockType.ELSE,
		"FOR": LogicBlock.BlockType.FOR,
		"WHILE": LogicBlock.BlockType.WHILE,
		"VARIABLE": LogicBlock.BlockType.VARIABLE,
		"MOVE": LogicBlock.BlockType.MOVE,
		"ASSIGN": LogicBlock.BlockType.ASSIGN,
		"INHERIT": LogicBlock.BlockType.INHERIT,
		"POLYMORPH": LogicBlock.BlockType.POLYMORPH,
		"SUPER": LogicBlock.BlockType.SUPER,
		"DUCK_TYPE": LogicBlock.BlockType.DUCK_TYPE,
		"CREATE_OBJ": LogicBlock.BlockType.CREATE_OBJ,
		"GARBAGE_COLLECT": LogicBlock.BlockType.GARBAGE_COLLECT,
		"INTERFACE": LogicBlock.BlockType.INTERFACE,
		"IMPLEMENTS": LogicBlock.BlockType.IMPLEMENTS
	}
	
	var x_offset = 0
	for block_type_name in blocks_needed:
		if block_spawners.has(block_type_name):
			var block_type = block_spawners[block_type_name]
			var block = create_spawner_block(block_type, palette_position + Vector2(x_offset, 0))
			x_offset += 60

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
	
	# Calcular pontuação (inclui otimização de memória e OOP)
	var score = calculate_puzzle_score()
	
	# Mostrar resultado
	show_puzzle_completion(score)
	
	# Aguardar antes de carregar próximo puzzle
	await get_tree().create_timer(2.0).timeout
	
	load_puzzle(current_puzzle_index + 1)

func calculate_puzzle_score() -> Dictionary:
	"""Calcula pontuação baseada em performance e conceitos OOP"""
	var time_score = max(0, 100 - int(level_timer))
	var moves_score = max(0, 100 - (moves_used * 10))
	var efficiency_score = 100 - (abs(blocks_placed - target_moves) * 3) if blocks_placed > 0 else 50
	var oop_score = calculate_oop_score()
	var memory_score = max(0, 100 - (garbage_count * 10))
	
	return {
		"time": time_score,
		"moves": moves_score,
		"efficiency": efficiency_score,
		"oop_concepts": oop_score,
		"memory_management": memory_score,
		"total": (time_score + moves_score + efficiency_score + oop_score + memory_score) / 5
	}

func calculate_oop_score() -> int:
	"""Calcula pontuação baseada em conceitos OOP usados"""
	var oop_score = 50  # Base score
	
	# Bonus por herança usada
	if ability_used_count.has("inheritance_used"):
		oop_score += min(30, ability_used_count["inheritance_used"] * 10)
	
	# Bonus por polimorfismo
	if ability_used_count.has("polymorphism_used"):
		oop_score += min(20, ability_used_count["polymorphism_used"] * 10)
	
	return min(100, oop_score)

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
	title.text = "PUZZLE OOP COMPLETADO!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.position = Vector2(0, -50)
	title.modulate = Color(0.2, 0.6, 1.0)
	completion_panel.add_child(title)
	
	# Pontuação
	var score_text = Label.new()
	score_text.text = "Pontuação Total: " + str(int(score.total))
	score_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_text.position = Vector2(0, -10)
	completion_panel.add_child(score_text)
	
	# Detalhes
	var details = Label.new()
	details.text = "Tempo: " + str(int(score.time)) + " | Movimentos: " + str(int(score.moves)) + "\nOOP: " + str(int(score.oop_concepts)) + " | Memória: " + str(int(score.memory_management))
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
	final_panel.modulate = Color(0.2, 0.6, 1.0, 0.9)
	add_child(final_panel)
	
	# Título
	var title = Label.new()
	title.text = "A BIBLIOTECA DE OBJETOS - CONCLUÍDA!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.position = Vector2(0, -80)
	title.modulate = Color.CYAN
	final_panel.add_child(title)
	
	# Informações
	var info = Label.new()
	info.text = "Você dominou os conceitos de OOP e gerenciamento de memória!\n\nPróximo nível: O Desenvolvedor Full-Stack (Integração)"
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	info.position = Vector2(0, 0)
	final_panel.add_child(info)

# Event handlers
func _on_temp_object_expired(temp_obj: Node):
	"""Called quando objeto temporário expira"""
	if is_instance_valid(temp_obj):
		temp_obj.queue_free()
		objects_created.erase(temp_obj)
		show_feedback("Objeto temporário removido!", Color.GREEN)

func _on_gem_collected(body: Node):
	"""Called quando gema é coletada"""
	if body.is_in_group("player"):
		var gem_node = body.get_parent()
		if not gem_node.is_collected:
			# Verificar requisitos OOP
			var can_collect = true
			if gem_node.requires_inheritance:
				can_collect = check_inheritance_used()
			elif gem_node.requires_polymorphism:
				can_collect = check_polymorphism_used()
			
			if can_collect:
				gem_node.is_collected = true
				gem_node.queue_free()
				show_feedback("Gema OOP coletada!", Color.GOLD)

func check_inheritance_used() -> bool:
	"""Verifica se herança foi usada corretamente"""
	return ability_used_count.has("inheritance_used") and ability_used_count["inheritance_used"] > 0

func check_polymorphism_used() -> bool:
	"""Verifica se polimorfismo foi usado corretamente"""
	return ability_used_count.has("polymorphism_used") and ability_used_count["polymorphism_used"] > 0

func show_feedback(message: String, color: Color):
	"""Mostra feedback temporário"""
	var feedback = Label.new()
	feedback.text = message
	feedback.modulate = color
	feedback.position = Vector2(200, 150)
	add_child(feedback)
	
	# Animar e remover
	var tween = create_tween()
	tween.tween_property(feedback, "position", Vector2(200, 130), 1.0).set_trans(Tween.TRANS_SINE)
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
		"objects_created": objects_created.size(),
		"garbage_collections": garbage_count,
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
