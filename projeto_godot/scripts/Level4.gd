# THE CORE DESCENT - NÍVEL 4: A ARQUITETURA CONCORRENTE
# Arquivo: Level4.gd - Implementação do quarto nível com conceitos avançados

extends Node2D
class_name Level4

# Configurações do nível
@export var level_name: String = "A Arquitetura Concorrente"
@export var level_description: String = "Domine concorrência, threads e padrões de design em C#/JavaScript"
@export var target_moves: int = 18  # Número ideal de movimentos
@export var grid_width: int = 26
@export var grid_height: int = 20

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
var start_position: Vector2i = Vector2i(2, 10)
var goal_position: Vector2i = Vector2i(23, 10)
var start_block: LogicBlock
var goal_block: LogicBlock

# Objetivo atual
var moves_used: int = 0
var blocks_placed: int = 0
var level_timer: float = 0.0
var is_timer_running: bool = false
var ability_used_count: Dictionary = {}  # Contador de uso de habilidades
var active_threads: Array = []  # Threads ativas
var thread_synchronization: Dictionary = {}  # Sincronização entre threads
var design_patterns_used: Array = []  # Padrões de design usados
var async_tasks_running: int = 0  # Tasks async em execução

# Puzzles disponíveis
var available_puzzles: Array[Dictionary] = []
var current_puzzle_index: int = 0

# UI Elements
var move_counter: Label
var timer_label: Label
var puzzle_title: Label
var instructions_label: Label
var thread_counter: Label
var pattern_counter: Label
var async_counter: Label

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
	puzzle_title.text = "PUZZLE 1: THREADING E SINCRONIZAÇÃO"
	puzzle_title.position = Vector2(20, 20)
	puzzle_title.modulate = Color(0.6, 0.2, 0.8)  # Roxo para C#
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
	
	# Contador de threads
	thread_counter = Label.new()
	thread_counter.text = "Threads Ativas: 0"
	thread_counter.position = Vector2(20, 110)
	thread_counter.modulate = Color(0.6, 0.2, 0.8)
	ui_container.add_child(thread_counter)
	
	# Contador de padrões
	pattern_counter = Label.new()
	pattern_counter.text = "Padrões: 0"
	pattern_counter.position = Vector2(20, 140)
	pattern_counter.modulate = Color(0.2, 0.8, 1.0)  # Azul para JavaScript
	ui_container.add_child(pattern_counter)
	
	# Contador de async
	async_counter = Label.new()
	async_counter.text = "Tasks Async: 0"
	async_counter.position = Vector2(20, 170)
	async_counter.modulate = Color(0.2, 0.8, 1.0)
	ui_container.add_child(async_counter)
	
	# Instruções
	instructions_label = Label.new()
	instructions_label.text = "Use conceitos avançados de programação.\nC# (teclas 1-4): Threads, Lock, Task.\nJavaScript (teclas 5-8): Async/Await, Promise, Callback!"
	instructions_label.position = Vector2(20, 200)
	instructions_label.size = Vector2(550, 60)
	ui_container.add_child(instructions_label)

func load_available_puzzles():
	"""Carrega puzzles disponíveis para este nível"""
	available_puzzles = [
		{
			"name": "Produtor-Consumidor",
			"description": "Implemente padrão produtor-consumidor com threads sincronizadas",
			"blocks_needed": ["THREAD", "LOCK", "SEMAPHORE", "MOVE", "MOVE", "MOVE", "MOVE", "SYNCHRONIZE"],
			"start_pos": Vector2i(2, 10),
			"goal_pos": Vector2i(23, 10),
			"special_items": [
				{"type": "producer_thread", "pos": Vector2i(6, 9), "produces": "data"},
				{"type": "consumer_thread", "pos": Vector2i(6, 11), "consumes": "data"},
				{"type": "shared_buffer", "pos": Vector2i(8, 10), "capacity": 3, "current": 0},
				{"type": "semaphore_prod", "pos": Vector2i(7, 9), "count": 3},
				{"type": "semaphore_cons", "pos": Vector2i(7, 11), "count": 0},
				{"type": "mutex_lock", "pos": Vector2i(9, 10), "is_locked": false},
				{"type": "thread_barrier", "pos": Vector2i(15, 10), "threads_required": 2},
				{"type": "gem", "pos": Vector2i(21, 10), "requires_threads": true}
			],
			"solution_steps": [
				"Criar thread produtora que gera dados",
				"Criar thread consumidora que processa dados",
				"Usar semáforos para controle de acesso",
				"Implementar locks para seção crítica",
				"Sincronizar threads na barreira",
				"Coletar gema com thread completa"
			],
			"hints": [
				"Produtor aumenta semáforo vazio, diminui cheio",
				"Consumidor aumenta semáforo cheio, diminui vazio",
				"Mutex protege acesso ao buffer compartilhado"
			],
			"languages": ["csharp"]
		},
		{
			"name": "Async/Await em Cascata",
			"description": "Use async/await para operações assíncronas em JavaScript",
			"blocks_needed": ["ASYNC", "AWAIT", "PROMISE", "CALLBACK", "MOVE", "MOVE", "MOVE", "MOVE"],
			"start_pos": Vector2i(2, 10),
			"goal_pos": Vector2i(23, 10),
			"special_items": [
				{"type": "async_task", "name": "fetch_data", "pos": Vector2i(6, 9), "duration": 2000},
				{"type": "async_task", "name": "process_data", "pos": Vector2i(6, 11), "duration": 1500},
				{"type": "async_task", "name": "save_result", "pos": Vector2i(8, 10), "duration": 1000},
				{"type": "promise_chain", "pos": Vector2i(10, 10), "tasks": ["fetch_data", "process_data", "save_result"]},
				{"type": "callback_hell", "pos": Vector2i(12, 10), "nested_level": 3},
				{"type": "async_gate", "pos": Vector2i(17, 10), "requires_all_tasks": true},
				{"type": "gem", "pos": Vector2i(21, 10), "requires_async": true}
			],
			"solution_steps": [
				"Criar task async para buscar dados",
				"Aguardar resultado antes de processar",
				"Cadeia de promises para operações sequenciais",
				"Evitar callback hell com async/await",
				"Abrir portão após completar todas as tasks",
				"Coletar gema de operações async"
			],
			"hints": [
				"Async/await torna código assíncrono mais legível",
				"Promise.all() aguarda múltiplas promises",
				"Evite aninhar callbacks (callback hell)"
			],
			"languages": ["javascript"]
		},
		{
			"name": "Observer Pattern",
			"description": "Implemente padrão Observer para sistema de notificações",
			"blocks_needed": ["OBSERVER", "SUBJECT", "NOTIFY", "MOVE", "MOVE", "MOVE", "MOVE", "SUBSCRIBE"],
			"start_pos": Vector2i(2, 10),
			"goal_pos": Vector2i(23, 10),
			"special_items": [
				{"type": "subject", "name": "EventManager", "pos": Vector2i(6, 10), "observers": []},
				{"type": "observer", "name": "Logger", "pos": Vector2i(8, 8), "event": "user_action"},
				{"type": "observer", "name": "UIUpdater", "pos": Vector2i(8, 12), "event": "data_change"},
				{"type": "observer", "name": "Validator", "pos": Vector2i(10, 8), "event": "user_action"},
				{"type": "notification_center", "pos": Vector2i(12, 10), "broadcasts": ["user_action", "data_change"]},
				{"type": "observer_gate", "pos": Vector2i(18, 10), "requires_pattern": "observer"},
				{"type": "gem", "pos": Vector2i(21, 10), "requires_observer": true}
			],
			"solution_steps": [
				"Criar subject (EventManager) que mantém lista de observadores",
				"Registrar observadores (Logger, UIUpdater, Validator)",
				"Subject notifica observadores quando evento ocorre",
				"Cada observador reage ao evento de sua forma",
				"Abrir portão que requer padrão Observer",
				"Coletar gema com design pattern completo"
			],
			"hints": [
				"Observer pattern: Subject mantém lista de observadores",
				"Quando evento ocorre, subject notifica todos observadores",
				"Observadores são desacoplados do subject"
			],
			"languages": ["csharp", "javascript"]
		},
		{
			"name": "Factory Pattern Complexo",
			"description": "Implemente factory pattern para criação dinâmica de objetos",
			"blocks_needed": ["FACTORY", "CREATE_OBJECT", "IF", "MOVE", "MOVE", "MOVE", "MOVE", "FACTORY_METHOD"],
			"start_pos": Vector2i(2, 10),
			"goal_pos": Vector2i(23, 10),
			"special_items": [
				{"type": "abstract_factory", "name": "UIFactory", "pos": Vector2i(6, 10), "products": ["Button", "TextField", "Panel"]},
				{"type": "concrete_factory", "name": "WebUI", "pos": Vector2i(8, 8), "type": "web", "creates": ["WebButton", "WebTextField"]},
				{"type": "concrete_factory", "name": "DesktopUI", "pos": Vector2i(8, 12), "type": "desktop", "creates": ["DesktopButton", "DesktopTextField"]},
				{"type": "client", "pos": Vector2i(10, 10), "needs": "UI_Element", "platform": "auto"},
				{"type": "product_registry", "pos": Vector2i(12, 10), "products": ["UI_Element", "Button", "TextField"]},
				{"type": "dynamic_creation", "pos": Vector2i(16, 10), "creates_based_on": "platform"},
				{"type": "gem", "pos": Vector2i(21, 10), "requires_factory": true}
			],
			"solution_steps": [
				"Criar fábrica abstrata para elementos UI",
				"Implementar fábricas concretas para Web e Desktop",
				"Cliente usa fábrica apropriada baseado na plataforma",
				"Criação dinâmica de objetos baseado em contexto",
				"Sistema flexível para múltiplas plataformas"
			],
			"hints": [
				"Factory pattern encapsula criação de objetos",
				"Cliente não conhece classes concretas",
				"Fábricas concretas implementam interface comum"
			],
			"languages": ["csharp"]
		},
		{
			"name": "Deadlock Prevention",
			"description": "Resolva deadlock usando algoritmos de prevenção",
			"blocks_needed": ["DEADLOCK_PREVENT", "RESOURCE_ORDER", "LOCK_TIMEOUT", "MOVE", "MOVE", "MOVE", "MOVE", "DEADLOCK_DETECT"],
			"start_pos": Vector2i(2, 10),
			"goal_pos": Vector2i(23, 10),
			"special_items": [
				{"type": "resource_a", "pos": Vector2i(6, 9), "locked_by": null, "priority": 1},
				{"type": "resource_b", "pos": Vector2i(6, 11), "locked_by": null, "priority": 2},
				{"type": "thread_1", "pos": Vector2i(8, 9), "needs": ["resource_a", "resource_b"], "order": 1},
				{"type": "thread_2", "pos": Vector2i(8, 11), "needs": ["resource_b", "resource_a"], "order": 2},
				{"type": "deadlock_checker", "pos": Vector2i(10, 10), "algorithm": "bankers"},
				{"type": "resource_manager", "pos": Vector2i(12, 10), "enforces_order": true},
				{"type": "timeout_mechanism", "pos": Vector2i(14, 10), "timeout": 5000},
				{"type": "gem", "pos": Vector2i(21, 10), "requires_no_deadlock": true}
			],
			"solution_steps": [
				"Detectar situação de deadlock potencial",
				"Implementar ordenação de recursos",
				"Usar timeout para evitar deadlock",
				"Empregar algoritmo do banqueiro",
				"Garantir acesso seguro a recursos",
				"Coletar gema sem deadlock"
			],
			"hints": [
				"Deadlock: threads esperam recursos bloqueados por outras",
				"Sempre pegar recursos na mesma ordem",
				"Use timeout para evitar esperas infinitas"
			],
			"languages": ["csharp"]
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
	
	# Limpar threads e sincronização
	for thread in active_threads:
		if is_instance_valid(thread):
			thread.queue_free()
	active_threads.clear()
	thread_synchronization.clear()
	design_patterns_used.clear()
	async_tasks_running = 0
	
	# Reset contadores
	moves_used = 0
	blocks_placed = 0
	level_timer = 0.0
	ability_used_count.clear()
	
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
	thread_counter.text = "Threads Ativas: " + str(active_threads.size())
	pattern_counter.text = "Padrões: " + str(design_patterns_used.size())
	async_counter.text = "Tasks Async: " + str(async_tasks_running)

func create_special_items(items: Array):
	"""Cria itens especiais específicos do nível"""
	for item in items:
		match item.type:
			"producer_thread":
				create_producer_thread(item.pos, item.produces)
			"consumer_thread":
				create_consumer_thread(item.pos, item.consumes)
			"shared_buffer":
				create_shared_buffer(item.pos, item.capacity, item.current)
			"semaphore_prod":
				create_semaphore(item.pos, item.count, "producer")
			"semaphore_cons":
				create_semaphore(item.pos, item.count, "consumer")
			"mutex_lock":
				create_mutex_lock(item.pos)
			"thread_barrier":
				create_thread_barrier(item.pos, item.threads_required)
			"async_task":
				create_async_task(item.name, item.pos, item.duration)
			"promise_chain":
				create_promise_chain(item.pos, item.tasks)
			"callback_hell":
				create_callback_hell(item.pos, item.nested_level)
			"async_gate":
				create_async_gate(item.pos, item.requires_all_tasks)
			"subject":
				create_subject(item.name, item.pos, item.observers)
			"observer":
				create_observer(item.name, item.pos, item.event)
			"notification_center":
				create_notification_center(item.pos, item.broadcasts)
			"observer_gate":
				create_observer_gate(item.pos, item.requires_pattern)
			"abstract_factory":
				create_abstract_factory(item.name, item.pos, item.products)
			"concrete_factory":
				create_concrete_factory(item.name, item.pos, item.type, item.creates)
			"client":
				create_factory_client(item.pos, item.needs, item.platform)
			"product_registry":
				create_product_registry(item.pos, item.products)
			"dynamic_creation":
				create_dynamic_creation(item.pos, item.creates_based_on)
			"resource_a", "resource_b":
				create_resource(item.type, item.pos, item.locked_by, item.priority)
			"thread_1", "thread_2":
				create_thread_process(item.type, item.pos, item.needs, item.order)
			"deadlock_checker":
				create_deadlock_checker(item.pos, item.algorithm)
			"resource_manager":
				create_resource_manager(item.pos, item.enforces_order)
			"timeout_mechanism":
				create_timeout_mechanism(item.pos, item.timeout)
			"gem":
				create_gem(item.pos, get_gem_requirements(item))

func create_producer_thread(grid_pos: Vector2i, produces: String):
	"""Cria thread produtora"""
	var producer = Node2D.new()
	producer.name = "ProducerThread"
	producer.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	producer.produces_type = produces
	producer.is_active = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/producer_thread.png")
	sprite.modulate = Color(0.6, 0.2, 0.8)  # Roxo para C#
	producer.add_child(sprite)
	
	# Label do tipo produzido
	var type_label = Label.new()
	type_label.text = "→" + produces
	type_label.position = Vector2(-15, -20)
	type_label.modulate = Color.WHITE
	producer.add_child(type_label)
	
	add_child(producer)

func create_consumer_thread(grid_pos: Vector2i, consumes: String):
	"""Cria thread consumidora"""
	var consumer = Node2D.new()
	consumer.name = "ConsumerThread"
	consumer.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	consumer.consumes_type = consumes
	consumer.is_active = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/consumer_thread.png")
	sprite.modulate = Color(0.6, 0.2, 0.8)
	consumer.add_child(sprite)
	
	# Label do tipo consumido
	var type_label = Label.new()
	type_label.text = consumes + "→"
	type_label.position = Vector2(-15, -20)
	type_label.modulate = Color.WHITE
	consumer.add_child(type_label)
	
	add_child(consumer)

func create_shared_buffer(grid_pos: Vector2i, capacity: int, current: int):
	"""Cria buffer compartilhado"""
	var buffer = Node2D.new()
	buffer.name = "SharedBuffer"
	buffer.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	buffer.capacity = capacity
	buffer.current_items = current
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/shared_buffer.png")
	sprite.modulate = Color.YELLOW
	buffer.add_child(sprite)
	
	# Visualização do buffer
	var fill_ratio = float(current) / float(capacity)
	var fill_bar = ColorRect.new()
	fill_bar.size = Vector2(20, 3)
	fill_bar.position = Vector2(-10, 15)
	if fill_ratio > 0.8:
		fill_bar.modulate = Color.RED
	elif fill_ratio > 0.5:
		fill_bar.modulate = Color.YELLOW
	else:
		fill_bar.modulate = Color.GREEN
	buffer.add_child(fill_bar)
	
	add_child(buffer)

func create_semaphore(grid_pos: Vector2i, count: int, type: String):
	"""Cria semáforo"""
	var semaphore = Node2D.new()
	semaphore.name = "Semaphore_" + type
	semaphore.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	semaphore.count = count
	semaphore.type = type
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/semaphore.png")
	sprite.modulate = Color(0.6, 0.2, 0.8)
	semaphore.add_child(sprite)
	
	# Contador
	var count_label = Label.new()
	count_label.text = str(count)
	count_label.position = Vector2(-5, -20)
	count_label.modulate = Color.WHITE
	semaphore.add_child(count_label)
	
	add_child(semaphore)

func create_mutex_lock(grid_pos: Vector2i):
	"""Cria lock mutex"""
	var mutex = Node2D.new()
	mutex.name = "MutexLock"
	mutex.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	mutex.is_locked = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/mutex_lock.png")
	sprite.modulate = Color.RED if mutex.is_locked else Color.GREEN
	mutex.add_child(sprite)
	
	add_child(mutex)

func create_thread_barrier(grid_pos: Vector2i, threads_required: int):
	"""Cria barreira de sincronização"""
	var barrier = Node2D.new()
	barrier.name = "ThreadBarrier"
	barrier.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	barrier.required_threads = threads_required
	barrier.current_threads = 0
	barrier.is_synchronized = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/thread_barrier.png")
	sprite.modulate = Color.CYAN
	barrier.add_child(sprite)
	
	# Contador de threads
	var thread_label = Label.new()
	thread_label.text = str(barrier.current_threads) + "/" + str(threads_required)
	thread_label.position = Vector2(-15, -20)
	thread_label.modulate = Color.WHITE
	barrier.add_child(thread_label)
	
	add_child(barrier)

func create_async_task(name: String, grid_pos: Vector2i, duration: int):
	"""Cria task assíncrona"""
	var task = Node2D.new()
	task.name = "AsyncTask_" + name
	task.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	task.task_name = name
	task.duration = duration
	task.is_running = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/async_task.png")
	sprite.modulate = Color(0.2, 0.8, 1.0)  # Azul para JavaScript
	task.add_child(sprite)
	
	# Label da task
	var task_label = Label.new()
	task_label.text = name
	task_label.position = Vector2(-20, -20)
	task_label.modulate = Color.WHITE
	task.add_child(task_label)
	
	add_child(task)

func create_promise_chain(grid_pos: Vector2i, tasks: Array):
	"""Cria cadeia de promises"""
	var chain = Node2D.new()
	chain.name = "PromiseChain"
	chain.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	chain.tasks = tasks
	chain.current_index = 0
	chain.is_complete = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/promise_chain.png")
	sprite.modulate = Color(0.2, 0.8, 1.0)
	chain.add_child(sprite)
	
	# Visualização da cadeia
	for i in range(min(tasks.size(), 4)):
		var task_indicator = ColorRect.new()
		task_indicator.size = Vector2(6, 6)
		task_indicator.position = Vector2(-12 + i * 8, 15)
		task_indicator.modulate = Color.GRAY
		chain.add_child(task_indicator)
	
	add_child(chain)

func create_callback_hell(grid_pos: Vector2i, nested_level: int):
	"""Cria exemplo de callback hell"""
	var hell = Node2D.new()
	hell.name = "CallbackHell"
	hell.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	hell.nested_level = nested_level
	hell.is_hell = true
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/callback_hell.png")
	sprite.modulate = Color.RED  # Vermelho para indicar problema
	hell.add_child(sprite)
	
	# Indicador de profundidade
	var depth_label = Label.new()
	depth_label.text = "Lv." + str(nested_level)
	depth_label.position = Vector2(-10, -20)
	depth_label.modulate = Color.WHITE
	hell.add_child(depth_label)
	
	add_child(hell)

func create_async_gate(grid_pos: Vector2i, requires_all_tasks: bool):
	"""Cria portão que requer tasks async"""
	var gate = Node2D.new()
	gate.name = "AsyncGate"
	gate.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	gate.requires_all = requires_all_tasks
	gate.tasks_completed = 0
	gate.is_open = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/async_gate.png")
	sprite.modulate = Color(0.2, 0.8, 1.0)
	gate.add_child(sprite)
	
	add_child(gate)

func create_subject(name: String, grid_pos: Vector2i, observers: Array):
	"""Cria subject do padrão Observer"""
	var subject = Node2D.new()
	subject.name = "Subject_" + name
	subject.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	subject.subject_name = name
	subject.observers = observers.duplicate()
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/subject.png")
	sprite.modulate = Color(0.6, 0.2, 0.8)
	subject.add_child(sprite)
	
	add_child(subject)

func create_observer(name: String, grid_pos: Vector2i, event: String):
	"""Cria observer do padrão Observer"""
	var observer = Node2D.new()
	observer.name = "Observer_" + name
	observer.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	observer.observer_name = name
	observer.subscribed_event = event
	observer.is_active = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/observer.png")
	sprite.modulate = Color(0.4, 0.6, 1.0)
	observer.add_child(sprite)
	
	# Label do evento
	var event_label = Label.new()
	event_label.text = event
	event_label.position = Vector2(-15, -20)
	event_label.modulate = Color.WHITE
	observer.add_child(event_label)
	
	add_child(observer)

func create_notification_center(grid_pos: Vector2i, broadcasts: Array):
	"""Cria centro de notificações"""
	var center = Node2D.new()
	center.name = "NotificationCenter"
	center.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	center.broadcast_events = broadcasts.duplicate()
	center.is_active = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/notification_center.png")
	sprite.modulate = Color.YELLOW
	center.add_child(sprite)
	
	add_child(center)

func create_observer_gate(grid_pos: Vector2i, requires_pattern: String):
	"""Cria portão que requer padrão Observer"""
	var gate = Node2D.new()
	gate.name = "ObserverGate"
	gate.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	gate.requires_pattern = requires_pattern
	gate.is_open = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/observer_gate.png")
	sprite.modulate = Color(0.6, 0.2, 0.8)
	gate.add_child(sprite)
	
	add_child(gate)

func create_abstract_factory(name: String, grid_pos: Vector2i, products: Array):
	"""Cria fábrica abstrata"""
	var factory = Node2D.new()
	abstract_factory.name = "AbstractFactory_" + name
	abstract_factory.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	abstract_factory.factory_name = name
	abstract_factory.products = products.duplicate()
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/abstract_factory.png")
	sprite.modulate = Color(0.6, 0.2, 0.8)
	abstract_factory.add_child(sprite)
	
	add_child(abstract_factory)

func create_concrete_factory(name: String, grid_pos: Vector2i, type: String, creates: Array):
	"""Cria fábrica concreta"""
	var factory = Node2D.new()
	concrete_factory.name = "ConcreteFactory_" + name
	concrete_factory.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	concrete_factory.factory_name = name
	concrete_factory.type = type
	concrete_factory.creates = creates.duplicate()
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/concrete_factory.png")
	sprite.modulate = Color(0.7, 0.3, 0.9)
	concrete_factory.add_child(sprite)
	
	# Label do tipo
	var type_label = Label.new()
	type_label.text = type
	type_label.position = Vector2(-15, -20)
	type_label.modulate = Color.WHITE
	concrete_factory.add_child(type_label)
	
	add_child(concrete_factory)

func create_factory_client(grid_pos: Vector2i, needs: String, platform: String):
	"""Cria cliente da factory"""
	var client = Node2D.new()
	client.name = "FactoryClient"
	client.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	client.needs = needs
	client.platform = platform
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/factory_client.png")
	sprite.modulate = Color(0.5, 0.7, 1.0)
	client.add_child(sprite)
	
	add_child(client)

func create_product_registry(grid_pos: Vector2i, products: Array):
	"""Cria registro de produtos"""
	var registry = Node2D.new()
	registry.name = "ProductRegistry"
	registry.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	registry.products = products.duplicate()
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/product_registry.png")
	sprite.modulate = Color.GOLD
	registry.add_child(sprite)
	
	add_child(registry)

func create_dynamic_creation(grid_pos: Vector2i, creates_based_on: String):
	"""Cria sistema de criação dinâmica"""
	var creation = Node2D.new()
	creation.name = "DynamicCreation"
	creation.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	creation.based_on = creates_based_on
	creation.is_active = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/dynamic_creation.png")
	sprite.modulate = Color(0.8, 0.4, 0.9)
	creation.add_child(sprite)
	
	add_child(creation)

func create_resource(resource_type: String, grid_pos: Vector2i, locked_by: String, priority: int):
	"""Cria recurso do sistema"""
	var resource = Node2D.new()
	resource.name = "Resource_" + resource_type.to_upper()
	resource.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	resource.resource_type = resource_type
	resource.locked_by = locked_by
	resource.priority = priority
	resource.is_locked = resource.locked_by != null
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/resource.png")
	sprite.modulate = Color.RED if resource.is_locked else Color.GREEN
	resource.add_child(sprite)
	
	# Prioridade
	var priority_label = Label.new()
	priority_label.text = "P" + str(priority)
	priority_label.position = Vector2(-8, -20)
	priority_label.modulate = Color.WHITE
	resource.add_child(priority_label)
	
	add_child(resource)

func create_thread_process(thread_type: String, grid_pos: Vector2i, needs: Array, order: int):
	"""Cria processo thread"""
	var thread = Node2D.new()
	thread.name = "Thread_" + thread_type
	thread.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	thread.thread_type = thread_type
	thread.needs_resources = needs.duplicate()
	thread.order = order
	thread.is_blocked = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/thread_process.png")
	sprite.modulate = Color(0.6, 0.2, 0.8)
	thread.add_child(sprite)
	
	# Ordem
	var order_label = Label.new()
	order_label.text = "#" + str(order)
	order_label.position = Vector2(-8, -20)
	order_label.modulate = Color.WHITE
	thread.add_child(order_label)
	
	add_child(thread)

func create_deadlock_checker(grid_pos: Vector2i, algorithm: String):
	"""Cria verificador de deadlock"""
	var checker = Node2D.new()
	checker.name = "DeadlockChecker"
	checker.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	checker.algorithm = algorithm
	checker.is_monitoring = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/deadlock_checker.png")
	sprite.modulate = Color.ORANGE
	checker.add_child(sprite)
	
	# Algoritmo
	var algo_label = Label.new()
	algo_label.text = algorithm
	algo_label.position = Vector2(-20, -20)
	algo_label.modulate = Color.WHITE
	checker.add_child(algo_label)
	
	add_child(checker)

func create_resource_manager(grid_pos: Vector2i, enforces_order: bool):
	"""Cria gerenciador de recursos"""
	var manager = Node2D.new()
	manager.name = "ResourceManager"
	manager.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	manager.enforces_order = enforces_order
	manager.is_active = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/resource_manager.png")
	sprite.modulate = Color.BLUE
	manager.add_child(sprite)
	
	add_child(manager)

func create_timeout_mechanism(grid_pos: Vector2i, timeout: int):
	"""Cria mecanismo de timeout"""
	var timeout_mech = Node2D.new()
	timeout_mech.name = "TimeoutMechanism"
	timeout_mech.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	timeout_mech.timeout_ms = timeout
	timeout_mech.is_active = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/timeout_mechanism.png")
	sprite.modulate = Color(1, 0.5, 0)
	timeout_mech.add_child(sprite)
	
	# Timeout em segundos
	var timeout_label = Label.new()
	timeout_label.text = str(timeout / 1000) + "s"
	timeout_label.position = Vector2(-10, -20)
	timeout_label.modulate = Color.WHITE
	timeout_mech.add_child(timeout_label)
	
	add_child(timeout_mech)

func get_gem_requirements(item: Dictionary) -> Dictionary:
	"""Extrai requisitos de gema do item"""
	return {
		"requires_threads": item.get("requires_threads", false),
		"requires_async": item.get("requires_async", false),
		"requires_observer": item.get("requires_observer", false),
		"requires_factory": item.get("requires_factory", false),
		"requires_no_deadlock": item.get("requires_no_deadlock", false)
	}

func create_gem(grid_pos: Vector2i, requirements: Dictionary):
	"""Cria gema com requisitos complexos"""
	var gem = Node2D.new()
	gem.name = "Gem"
	gem.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	gem.requirements = requirements
	gem.is_collected = false
	gem.requirements_met = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/gem.png")
	
	# Cor baseada nos requisitos
	var has_complex_req = any(requirements.values())
	if has_complex_req:
		sprite.modulate = Color.GOLD.with_alpha(0.8)  # Dourado para requisitos especiais
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
	var palette_position = Vector2(50, 290)
	
	var block_spawners = {
		"IF": LogicBlock.BlockType.IF,
		"ELSE": LogicBlock.BlockType.ELSE,
		"FOR": LogicBlock.BlockType.FOR,
		"WHILE": LogicBlock.BlockType.WHILE,
		"VARIABLE": LogicBlock.BlockType.VARIABLE,
		"MOVE": LogicBlock.BlockType.MOVE,
		"ASSIGN": LogicBlock.BlockType.ASSIGN,
		"THREAD": LogicBlock.BlockType.THREAD,
		"LOCK": LogicBlock.BlockType.LOCK,
		"SEMAPHORE": LogicBlock.BlockType.SEMAPHORE,
		"SYNCHRONIZE": LogicBlock.BlockType.SYNCHRONIZE,
		"ASYNC": LogicBlock.BlockType.ASYNC,
		"AWAIT": LogicBlock.BlockType.AWAIT,
		"PROMISE": LogicBlock.BlockType.PROMISE,
		"CALLBACK": LogicBlock.BlockType.CALLBACK,
		"OBSERVER": LogicBlock.BlockType.OBSERVER,
		"SUBJECT": LogicBlock.BlockType.SUBJECT,
		"NOTIFY": LogicBlock.BlockType.NOTIFY,
		"SUBSCRIBE": LogicBlock.BlockType.SUBSCRIBE,
		"FACTORY": LogicBlock.BlockType.FACTORY,
		"CREATE_OBJECT": LogicBlock.BlockType.CREATE_OBJECT,
		"FACTORY_METHOD": LogicBlock.BlockType.FACTORY_METHOD,
		"DEADLOCK_PREVENT": LogicBlock.BlockType.DEADLOCK_PREVENT,
		"RESOURCE_ORDER": LogicBlock.BlockType.RESOURCE_ORDER,
		"LOCK_TIMEOUT": LogicBlock.BlockType.LOCK_TIMEOUT,
		"DEADLOCK_DETECT": LogicBlock.BlockType.DEADLOCK_DETECT
	}
	
	var x_offset = 0
	for block_type_name in blocks_needed:
		if block_spawners.has(block_type_name):
			var block_type = block_spawners[block_type_name]
			var block = create_spawner_block(block_type, palette_position + Vector2(x_offset, 0))
			x_offset += 65

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
	
	# Atualizar contadores periodicamente
	if int(level_timer * 2) % 1 == 0:  # A cada 0.5s
		update_counters()
	
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
	
	# Calcular pontuação (inclui conceitos avançados)
	var score = calculate_puzzle_score()
	
	# Mostrar resultado
	show_puzzle_completion(score)
	
	# Aguardar antes de carregar próximo puzzle
	await get_tree().create_timer(2.0).timeout
	
	load_puzzle(current_puzzle_index + 1)

func calculate_puzzle_score() -> Dictionary:
	"""Calcula pontuação baseada em performance e conceitos avançados"""
	var time_score = max(0, 100 - int(level_timer))
	var moves_score = max(0, 100 - (moves_used * 5))
	var efficiency_score = blocks_placed > 0 ? 100 - (abs(blocks_placed - target_moves) * 2) : 50
	var concurrency_score = calculate_concurrency_score()
	var pattern_score = calculate_pattern_score()
	
	return {
		"time": time_score,
		"moves": moves_score,
		"efficiency": efficiency_score,
		"concurrency": concurrency_score,
		"design_patterns": pattern_score,
		"total": (time_score + moves_score + efficiency_score + concurrency_score + pattern_score) / 5
	}

func calculate_concurrency_score() -> int:
	"""Calcula pontuação baseada em conceitos de concorrência"""
	var concurrency_score = 30  # Base score
	
	# Bonus por threads criadas
	if ability_used_count.has("threads_created"):
		concurrency_score += min(25, ability_used_count["threads_created"] * 5)
	
	# Bonus por sincronização
	if ability_used_count.has("synchronization_used"):
		concurrency_score += min(25, ability_used_count["synchronization_used"] * 8)
	
	# Bonus por async/await
	if ability_used_count.has("async_operations"):
		concurrency_score += min(20, ability_used_count["async_operations"] * 4)
	
	return min(100, concurrency_score)

func calculate_pattern_score() -> int:
	"""Calcula pontuação baseada em padrões de design usados"""
	var pattern_score = 20  # Base score
	
	# Bonus por padrões implementados
	pattern_score += min(40, design_patterns_used.size() * 10)
	
	# Bonus por variedade de padrões
	var unique_patterns = design_patterns_used.size()
	if unique_patterns >= 3:
		pattern_score += 20
	elif unique_patterns >= 2:
		pattern_score += 10
	
	return min(100, pattern_score)

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
	title.text = "PUZZLE AVANÇADO COMPLETADO!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.position = Vector2(0, -50)
	title.modulate = Color(0.6, 0.2, 0.8)
	completion_panel.add_child(title)
	
	# Pontuação
	var score_text = Label.new()
	score_text.text = "Pontuação Total: " + str(int(score.total))
	score_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_text.position = Vector2(0, -10)
	completion_panel.add_child(score_text)
	
	# Detalhes
	var details = Label.new()
	details.text = "Concorrência: " + str(int(score.concurrency)) + " | Padrões: " + str(int(score.design_patterns))
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
	final_panel.modulate = Color(0.6, 0.2, 0.8, 0.9)
	add_child(final_panel)
	
	# Título
	var title = Label.new()
	title.text = "A ARQUITETURA CONCORRENTE - CONCLUÍDA!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.position = Vector2(0, -80)
	title.modulate = Color(0.8, 0.6, 1.0)
	final_panel.add_child(title)
	
	# Informações
	var info = Label.new()
	info.text = "Você dominou concorrência e padrões de design!\n\nPróximo nível: O Arquiteto de Software (Integração Final)"
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	info.position = Vector2(0, 0)
	final_panel.add_child(info)

# Event handlers
func _on_gem_collected(body: Node):
	"""Called quando gema é coletada"""
	if body.is_in_group("player"):
		var gem_node = body.get_parent()
		if not gem_node.is_collected:
			# Verificar requisitos avançados
			var can_collect = check_advanced_requirements(gem_node.requirements)
			
			if can_collect:
				gem_node.is_collected = true
				gem_node.queue_free()
				show_feedback("Gema Avançada coletada!", Color.GOLD)

func check_advanced_requirements(requirements: Dictionary) -> bool:
	"""Verifica se requisitos avançados foram atendidos"""
	if requirements.requires_threads and active_threads.size() < 2:
		return false
	if requirements.requires_async and async_tasks_running < 1:
		return false
	if requirements.requires_observer and not design_patterns_used.has("observer"):
		return false
	if requirements.requires_factory and not design_patterns_used.has("factory"):
		return false
	if requirements.requires_no_deadlock and thread_synchronization.has("deadlock_detected"):
		return false
	
	return true

func show_feedback(message: String, color: Color):
	"""Mostra feedback temporário"""
	var feedback = Label.new()
	feedback.text = message
	feedback.modulate = color
	feedback.position = Vector2(200, 180)
	add_child(feedback)
	
	# Animar e remover
	var tween = create_tween()
	tween.tween_property(feedback, "position", Vector2(200, 160), 1.0).set_trans(Tween.TRANS_SINE)
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
		"active_threads": active_threads.size(),
		"design_patterns": design_patterns_used.size(),
		"async_tasks": async_tasks_running,
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
