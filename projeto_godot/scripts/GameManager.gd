extends Node
class_name GameManager

# Estado global do jogo
enum GameState { 
	MAIN_MENU, 
	LEVEL_SELECT, 
	PLAYING, 
	PAUSED, 
	GAME_OVER, 
	LEVEL_COMPLETE 
}

var current_state: GameState = GameState.MAIN_MENU
var current_level: Node = null
var level_number: int = 1

# Sistemas principais
var drag_system: DragAndDropSystem
var player: PlayerController

# Configurações
@export var grid_size: int = 32
@export var snap_threshold: float = 16.0
@export var starting_language: String = "PYTHON"

# Progressão do jogador
var unlocked_levels: Array[int] = [1]  # Apenas nível 1 unlocked inicialmente
var player_stats: Dictionary = {
	"total_time_played": 0.0,
	"levels_completed": 0,
	"puzzles_solved": 0,
	"total_moves": 0,
	"languages_unlocked": ["PYTHON"]
}

# UI references
var ui_root: Control
var pause_menu: Control
var hud: Control

func _ready():
	setup_game_systems()
	load_game_config()
	show_main_menu()

func setup_game_systems():
	"""Configura todos os sistemas principais"""
	# AutoLoad singleton para GameManager
	if name != "GameManager":
		name = "GameManager"
	
	# Inicializar managers principais
	setup_drag_system()
	setup_player()
	
	# Conectar sinais
	connect_signals()

func setup_drag_system():
	"""Configura sistema de drag and drop"""
	drag_system = DragAndDropSystem.new()
	add_child(drag_system)
	drag_system.setup_references()
	
	# Conectar sinais
	drag_system.connect("block_snapped", Callable(self, "_on_block_snapped"))
	drag_system.connect("drag_started", Callable(self, "_on_drag_started"))

func setup_player():
	"""Configura jogador principal"""
	player = PlayerController.new()
	add_child(player)
	
	# Configurar propriedades do player
	player.grid_size = grid_size
	player.snap_threshold = snap_threshold

func connect_signals():
	"""Conecta sinais entre sistemas"""
	pass

func load_game_config():
	"""Carrega configurações do jogo"""
	# Carregar save game se existir (implementação futura)
	pass

# STATE MANAGEMENT
func change_state(new_state: GameState):
	"""Muda estado global do jogo"""
	var old_state = current_state
	current_state = new_state
	
	# Cleanup estado anterior
	match old_state:
		GameState.MAIN_MENU:
			cleanup_main_menu()
		GameState.LEVEL_SELECT:
			cleanup_level_select()
		GameState.PLAYING:
			cleanup_gameplay()
	
	# Setup novo estado
	match new_state:
		GameState.MAIN_MENU:
			setup_main_menu()
		GameState.LEVEL_SELECT:
			setup_level_select()
		GameState.PLAYING:
			setup_gameplay()
		GameState.PAUSED:
			setup_pause_menu()

func show_main_menu():
	"""Mostra menu principal"""
	change_state(GameState.MAIN_MENU)

func show_level_select():
	"""Mostra seleção de níveis"""
	change_state(GameState.LEVEL_SELECT)

func start_level(level_num: int):
	"""Inicia nível específico"""
	level_number = level_num
	change_state(GameState.PLAYING)

func pause_game():
	"""Pausa o jogo"""
	if current_state == GameState.PLAYING:
		change_state(GameState.PAUSED)
		get_tree().paused = true

func resume_game():
	"""Resume o jogo"""
	if current_state == GameState.PAUSED:
		get_tree().paused = false
		change_state(GameState.PLAYING)

# MAIN MENU
func setup_main_menu():
	"""Configura menu principal"""
	ui_root = Control.new()
	ui_root.name = "UIRoot"
	ui_root.anchor_left = 0
	ui_root.anchor_top = 0
	ui_root.anchor_right = 1
	ui_root.anchor_bottom = 1
	ui_root.modulate = Color(0, 0, 0, 0.8)
	add_child(ui_root)
	
	# Container principal
	var main_container = VBoxContainer.new()
	main_container.anchor_left = 0.5
	main_container.anchor_top = 0.5
	main_container.anchor_right = 0.5
	main_container.anchor_bottom = 0.5
	main_container.position = Vector2(-200, -150)
	ui_root.add_child(main_container)
	
	# Título
	var title = Label.new()
	title.text = "THE CORE DESCENT"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.modulate = Color.CYAN
	title.scale = Vector2(2, 2)
	main_container.add_child(title)
	
	# Subtitle
	var subtitle = Label.new()
	subtitle.text = "Nível 1: A Torre de Marfim"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.modulate = Color.WHITE
	main_container.add_child(subtitle)
	
	# Botões
	var start_button = Button.new()
	start_button.text = "INICIAR PROTÓTIPO"
	start_button.pressed.connect(Callable(self, "show_level_select"))
	main_container.add_child(start_button)
	
	var test_button = Button.new()
	test_button.text = "TESTE RÁPIDO"
	test_button.pressed.connect(Callable(self, "start_quick_test"))
	main_container.add_child(test_button)
	
	var quit_button = Button.new()
	quit_button.text = "SAIR"
	quit_button.pressed.connect(Callable(self, "quit_game"))
	main_container.add_child(quit_button)

func cleanup_main_menu():
	"""Limpa menu principal"""
	if ui_root:
		ui_root.queue_free()

# LEVEL SELECT
func setup_level_select():
	"""Configura seleção de níveis"""
	cleanup_ui()
	
	var level_select = Control.new()
	level_select.name = "LevelSelect"
	level_select.anchor_left = 0
	level_select.anchor_top = 0
	level_select.anchor_right = 1
	level_select.anchor_bottom = 1
	level_select.modulate = Color(0, 0, 0, 0.9)
	add_child(level_select)
	
	ui_root = level_select
	
	# Título
	var title = Label.new()
	title.text = "SELECIONE SEU PROTÓTIPO"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.position = Vector2(0, 50)
	title.modulate = Color.CYAN
	level_select.add_child(title)
	
	# Grid de níveis
	var level_grid = GridContainer.new()
	level_grid.columns = 2
	level_grid.position = Vector2(200, 150)
	level_grid.size = Vector2(800, 300)
	level_select.add_child(level_grid)
	
	# Criar botões para cada nível
	create_level_buttons(level_grid)

func create_level_buttons(parent: GridContainer):
	"""Cria botões para seleção de níveis"""
	var levels_data = [
		{"num": 1, "name": "Teste Rápido", "desc": "Block-based Logic", "unlocked": true},
		{"num": 2, "name": "A Torre de Marfim", "desc": "High-Level Languages", "unlocked": false},
		{"num": 3, "name": "A Forja de Ponteiros", "desc": "C/C++ Memory Management", "unlocked": false},
		{"num": 4, "name": "O Salão dos Mnemônicos", "desc": "Assembly Optimization", "unlocked": false},
		{"num": 5, "name": "O Abismo Binário", "desc": "Machine Language", "unlocked": false},
		{"num": 6, "name": "O Núcleo de Silício", "desc": "Hardware Logic", "unlocked": false}
	]
	
	for level_data in levels_data:
		var level_button = create_level_button(level_data)
		parent.add_child(level_button)

func create_level_button(level_data: Dictionary) -> Button:
	"""Cria botão para um nível específico"""
	var button = Button.new()
	button.custom_minimum_size = Vector2(350, 80)
	
	var button_container = VBoxContainer.new()
	button.add_child(button_container)
	
	# Nome do nível
	var name_label = Label.new()
	name_label.text = "Nível " + str(level_data.num)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.modulate = level_data.unlocked ? Color.WHITE : Color.GRAY
	button_container.add_child(name_label)
	
	# Descrição
	var desc_label = Label.new()
	desc_label.text = level_data.name
	desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc_label.scale = Vector2(0.9, 0.9)
	desc_label.modulate = level_data.unlocked ? Color.CYAN : Color.GRAY
	button_container.add_child(desc_label)
	
	# Status
	var status_label = Label.new()
	status_label.text = level_data.desc
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.scale = Vector2(0.7, 0.7)
	status_label.modulate = level_data.unlocked ? Color.GREEN : Color.RED
	button_container.add_child(status_label)
	
	# Configurar botão
	if level_data.unlocked:
		button.pressed.connect(Callable(self, "start_level").bind(level_data.num))
		button.tooltip_text = "Clique para testar " + level_data.name
	else:
		button.disabled = true
		button.modulate = Color.GRAY
		button.tooltip_text = "Em desenvolvimento..."
	
	return button

# GAMEPLAY
func setup_gameplay():
	"""Configura gameplay do nível"""
	cleanup_ui()
	
	# Carregar cena do nível baseado no número
	load_test_level(level_number)
	
	# Configurar jogador
	if player:
		player.position = Vector2(64, 64)  # Posição inicial padrão
		player.start_level()
	
	# Setup HUD
	setup_hud()
	
	# Input mapping para pause
	setup_input_mapping()

func load_test_level(level_num: int):
	"""Carrega nível de teste específico"""
	# Para protótipo, sempre carregar o mesmo nível de teste
	create_test_level()

func create_test_level():
	"""Cria um nível de teste simples com blocos"""
	# Adicionar alguns blocos de teste para demonstrar funcionalidade
	create_test_blocks()

func create_test_blocks():
	"""Cria blocos de teste para demonstração"""
	# Bloco IF
	var if_block = LogicBlock.new()
	if_block.block_type = LogicBlock.BlockType.IF
	if_block.position = Vector2(200, 100)
	if_block.visual_color = Color(0.2, 0.6, 1.0)
	add_child(if_block)
	if_block.add_to_group("logic_blocks")
	
	# Bloco FOR
	var for_block = LogicBlock.new()
	for_block.block_type = LogicBlock.BlockType.FOR
	for_block.position = Vector2(300, 200)
	for_block.visual_color = Color(0.2, 1.0, 0.6)
	add_child(for_block)
	for_block.add_to_group("logic_blocks")
	
	# Bloco MOVE
	var move_block = LogicBlock.new()
	move_block.block_type = LogicBlock.BlockType.MOVE
	move_block.position = Vector2(400, 300)
	move_block.visual_color = Color(1.0, 0.2, 0.8)
	add_child(move_block)
	move_block.add_to_group("logic_blocks")

func cleanup_gameplay():
	"""Limpa gameplay"""
	# Limpar blocos existentes
	var blocks = get_tree().get_nodes_in_group("logic_blocks")
	for block in blocks:
		block.queue_free()

func setup_hud():
	"""Configura heads-up display"""
	hud = Control.new()
	hud.name = "HUD"
	hud.anchor_left = 0
	hud.anchor_top = 0
	hud.anchor_right = 1
	hud.anchor_bottom = 0
	hud.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	add_child(hud)
	
	# Botão de pause
	var pause_button = Button.new()
	pause_button.text = "II"
	pause_button.position = Vector2(10, 10)
	pause_button.pressed.connect(Callable(self, "pause_game"))
	hud.add_child(pause_button)
	
	# Info do jogador
	var player_info = Label.new()
	player_info.text = "Protótipo - Drag & Drop Test"
	player_info.position = Vector2(50, 15)
	hud.add_child(player_info)

# PAUSE MENU
func setup_pause_menu():
	"""Configura menu de pause"""
	pause_menu = Control.new()
	pause_menu.name = "PauseMenu"
	pause_menu.anchor_left = 0
	pause_menu.anchor_top = 0
	pause_menu.anchor_right = 1
	pause_menu.anchor_bottom = 1
	pause_menu.modulate = Color(0, 0, 0, 0.7)
	add_child(pause_menu)
	
	var pause_container = VBoxContainer.new()
	pause_container.anchor_left = 0.5
	pause_container.anchor_top = 0.5
	pause_container.anchor_right = 0.5
	pause_container.anchor_bottom = 0.5
	pause_container.position = Vector2(-100, -75)
	pause_menu.add_child(pause_container)
	
	var title = Label.new()
	title.text = "JOGO PAUSADO"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.modulate = Color.YELLOW
	pause_container.add_child(title)
	
	var resume_button = Button.new()
	resume_button.text = "CONTINUAR"
	resume_button.pressed.connect(Callable(self, "resume_game"))
	pause_container.add_child(resume_button)
	
	var restart_button = Button.new()
	restart_button.text = "REINICIAR TESTE"
	restart_button.pressed.connect(Callable(self, "restart_level"))
	pause_container.add_child(restart_button)
	
	var main_menu_button = Button.new()
	main_menu_button.text = "MENU PRINCIPAL"
	main_menu_button.pressed.connect(Callable(self, "show_main_menu"))
	pause_container.add_child(main_menu_button)

func setup_input_mapping():
	"""Configura mapeamento de input para pause"""
	# Configurar input action para ESC
	if not InputMap.has_action("pause"):
		InputMap.add_action("pause")
		var key_event = InputEventKey.new()
		key_event.keycode = KEY_ESCAPE
		InputMap.action_add_event("pause", key_event)

# EVENT HANDLERS
func _input(event):
	"""Processa input global"""
	if event.is_action_pressed("pause"):
		if current_state == GameState.PLAYING:
			pause_game()
		elif current_state == GameState.PAUSED:
			resume_game()

func _on_block_snapped(grid_pos: Vector2i):
	"""Called quando bloco é posicionamento na grade"""
	# Contabilizar movimento
	player_stats.total_moves += 1
	player_stats.puzzles_solved += 1

func _on_drag_started(block: LogicBlock):
	"""Called quando começa a arrastar bloco"""
	# Feedback visual simples - poderia adicionar som aqui
	print("Bloco arrastado: ", block.get_block_type_name())

func start_quick_test():
	"""Inicia teste rápido direto no gameplay"""
	level_number = 1
	change_state(GameState.PLAYING)

func restart_level():
	"""Reinicia nível atual"""
	if current_level and current_level.has_method("reset"):
		current_level.reset()
	if player:
		player.reset()
	# Recriar blocos de teste
	create_test_blocks()
	resume_game()

func quit_game():
	"""Sai do jogo"""
	get_tree().quit()

func cleanup_ui():
	"""Limpa elementos de UI"""
	for child in get_children():
		if child is Control and child.name != "GameManager":
			child.queue_free()

# GETTERS PARA OUTROS SISTEMAS
func get_drag_system() -> DragAndDropSystem:
	return drag_system

func get_player() -> PlayerController:
	return player

# Utility methods
func format_time(seconds: float) -> String:
	"""Formata tempo em segundos para string legível"""
	var mins = int(seconds / 60)
	var secs = int(seconds % 60)
	return str(mins).pad_zeros(2) + ":" + str(secs).pad_zeros(2)