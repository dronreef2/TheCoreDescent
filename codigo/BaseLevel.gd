# THE CORE DESCENT - BASE LEVEL CLASS
# Arquivo: BaseLevel.gd - Classe base abstrata para todos os níveis

extends Node2D
class_name BaseLevel

# Configurações exportadas (override em subclasses)
@export var level_name: String = "Base Level"
@export var level_description: String = "Abstract base level"
@export var target_moves: int = 10
@export var grid_width: int = 20
@export var grid_height: int = 15

# Referências aos sistemas (preenchidas automaticamente)
var game_manager: Node
var drag_system: DragAndDropSystem
var player: PlayerController
var ui_manager: Node

# Estado do nível
enum LevelState { LOADING, PLAYING, COMPLETED, FAILED }
var current_state: LevelState = LevelState.LOADING

# Objetivo atual
var moves_used: int = 0
var blocks_placed: int = 0
var level_timer: float = 0.0
var is_timer_running: bool = false

# Puzzles disponíveis (override em subclasses)
var available_puzzles: Array[Dictionary] = []
var current_puzzle_index: int = 0

# UI Elements (criados automaticamente)
var move_counter: Label
var timer_label: Label
var puzzle_title: Label
var instructions_label: Label

func _ready():
	setup_level()
	setup_ui()
	_on_level_ready()  # Hook virtual para subclasses

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
	"""Configura interface do usuário base"""
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
	
	# Título do puzzle (personalizado via _customize_ui)
	puzzle_title = Label.new()
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
	instructions_label.position = Vector2(20, 120)
	instructions_label.size = Vector2(400, 60)
	ui_container.add_child(instructions_label)
	
	# Hook virtual para customizações da subclasse
	_customize_ui(ui_container)

# VIRTUAL METHODS (override em subclasses)
func _on_level_ready():
	"""Hook chamado após setup completo. Override para carregar puzzles."""
	pass

func _customize_ui(container: Control):
	"""Hook para adicionar elementos UI extras. Override em subclasses."""
	pass

# LIFECYCLE
func _process(delta):
	if is_timer_running:
		level_timer += delta
		update_timer_display()

func start_level():
	"""Inicia o nível"""
	current_state = LevelState.PLAYING
	is_timer_running = true

func complete_level():
	"""Completa o nível"""
	current_state = LevelState.COMPLETED
	is_timer_running = false
	# Emitir sinal ou notificar game_manager
	if game_manager and game_manager.has_method("on_level_complete"):
		game_manager.on_level_complete(get_level_number())

func fail_level():
	"""Marca nível como falhado"""
	current_state = LevelState.FAILED
	is_timer_running = false

func reset():
	"""Reseta o nível ao estado inicial"""
	moves_used = 0
	blocks_placed = 0
	level_timer = 0.0
	is_timer_running = false
	current_state = LevelState.LOADING
	update_move_counter()
	update_timer_display()

# UI UPDATES
func update_move_counter():
	"""Atualiza display do contador de movimentos"""
	if move_counter:
		move_counter.text = "Movimentos: %d/%d" % [moves_used, target_moves]

func update_timer_display():
	"""Atualiza display do timer"""
	if timer_label:
		timer_label.text = "Tempo: %.1fs" % level_timer

func set_puzzle_title(title: String):
	"""Define título do puzzle"""
	if puzzle_title:
		puzzle_title.text = title

func set_instructions(text: String):
	"""Define texto de instruções"""
	if instructions_label:
		instructions_label.text = text

# HELPERS
func get_level_number() -> int:
	"""Extrai número do nível a partir do nome da classe"""
	var class_name = get_script().resource_path.get_file().get_basename()
	var regex = RegEx.new()
	regex.compile("Level(\\d+)")
	var result = regex.search(class_name)
	if result:
		return result.get_string(1).to_int()
	return 0

func increment_moves():
	"""Incrementa contador de movimentos"""
	moves_used += 1
	update_move_counter()

func increment_blocks():
	"""Incrementa contador de blocos colocados"""
	blocks_placed += 1
