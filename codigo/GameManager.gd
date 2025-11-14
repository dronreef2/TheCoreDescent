# THE CORE DESCENT - ARQUITETURA PRINCIPAL
# Arquivo: GameManager.gd - Coordenador principal do jogo

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
var ui_manager: UIManager
var audio_manager: AudioManager
var save_system: SaveSystem

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

# Scene management
var main_menu_scene: PackedScene
var level_select_scene: PackedScene
var game_scene: PackedScene

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
	setup_ui_manager()
	setup_audio_manager()
	setup_save_system()
	
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
	
	# Conectar sinais
	player.connect("state_changed", Callable(self, "_on_player_state_changed"))

func setup_ui_manager():
	"""Configura manager de interface"""
	ui_manager = UIManager.new()
	add_child(ui_manager)
	ui_manager.setup_ui_systems()

func setup_audio_manager():
	"""Configura sistema de áudio"""
	audio_manager = AudioManager.new()
	add_child(audio_manager)
	audio_manager.setup_audio_systems()

func setup_save_system():
	"""Configura sistema de save/load"""
	save_system = SaveSystem.new()
	add_child(save_system)

func connect_signals():
	"""Conecta sinais entre sistemas"""
	pass

func load_game_config():
	"""Carrega configurações do jogo"""
	# Carregar save game se existir
	var save_data = save_system.load_game()
	if save_data:
		apply_save_data(save_data)

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
		GameState.LEVEL_COMPLETE:
			setup_level_complete()

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
	
	# Botões
	var start_button = Button.new()
	start_button.text = "INICIAR JORNADA"
	start_button.pressed.connect(Callable(self, "show_level_select"))
	main_container.add_child(start_button)
	
	var continue_button = Button.new()
	continue_button.text = "CONTINUAR"
	continue_button.pressed.connect(Callable(self, "load_last_level"))
	continue_button.disabled = unlocked_levels.size() == 1  # Apenas se há save
	main_container.add_child(continue_button)
	
	var options_button = Button.new()
	options_button.text = "OPÇÕES"
	options_button.pressed.connect(Callable(self, "show_options"))
	main_container.add_child(options_button)
	
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
	title.text = "SELECIONE SEU DESTINO"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	title.position = Vector2(0, 50)
	title.modulate = Color.CYAN
	level_select.add_child(title)
	
	# Grid de níveis
	var level_grid = GridContainer.new()
	level_grid.columns = 3
	level_grid.position = Vector2(100, 150)
	level_grid.size = Vector2(600, 300)
	level_select.add_child(level_grid)
	
	# Criar botões para cada nível
	create_level_buttons(level_grid)

func create_level_buttons(parent: GridContainer):
	"""Cria botões para seleção de níveis"""
	var levels_data = [
		{"num": 1, "name": "A Torre de Marfim", "desc": "High-Level Languages", "unlocked": true},
		{"num": 2, "name": "A Forja de Ponteiros", "desc": "C/C++ Memory Management", "unlocked": false},
		{"num": 3, "name": "O Salão dos Mnemônicos", "desc": "Assembly Optimization", "unlocked": false},
		{"num": 4, "name": "O Abismo Binário", "desc": "Machine Language", "unlocked": false},
		{"num": 5, "name": "O Núcleo de Silício", "desc": "Hardware Logic", "unlocked": false},
		{"num": 6, "name": "A Arquitetura Web", "desc": "Web Development Full-Stack", "unlocked": false},
		{"num": 7, "name": "O Ecossistema Mobile", "desc": "Mobile Development", "unlocked": false},
		{"num": 8, "name": "A Ciência dos Dados", "desc": "Data Science & ML", "unlocked": false},
		{"num": 9, "name": "As Fronteiras da Tecnologia", "desc": "IoT, Blockchain, Quantum", "unlocked": false},
		{"num": 10, "name": "O Estúdio de Jogos", "desc": "Game Development", "unlocked": false}
	]
	
	for level_data in levels_data:
		var level_button = create_level_button(level_data)
		parent.add_child(level_button)

func create_level_button(level_data: Dictionary) -> Button:
	"""Cria botão para um nível específico"""
	var button = Button.new()
	button.custom_minimum_size = Vector2(180, 100)
	
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
	desc_label.scale = Vector2(0.8, 0.8)
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
		button.tooltip_text = "Clique para jogar " + level_data.name
	else:
		button.disabled = true
		button.modulate = Color.GRAY
		button.tooltip_text = "Complete o nível anterior para desbloquear"
	
	return button

# GAMEPLAY
func setup_gameplay():
	"""Configura gameplay do nível"""
	cleanup_ui()
	
	# Carregar cena do nível
	current_level = load_level_scene(level_number)
	if current_level:
		add_child(current_level)
	
	# Configurar jogador
	if player:
		player.position = Vector2(100, 100)  # Posição inicial padrão
		player.start_level()
	
	# Setup HUD
	setup_hud()
	
	# Input mapping para pause
	setup_input_mapping()

func cleanup_gameplay():
	"""Limpa gameplay"""
	if current_level:
		current_level.queue_free()
		current_level = null

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
	player_info.text = "Linguagem: " + starting_language
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
	restart_button.text = "REINICIAR NÍVEL"
	restart_button.pressed.connect(Callable(self, "restart_level"))
	pause_container.add_child(restart_button)
	
	var main_menu_button = Button.new()
	main_menu_button.text = "MENU PRINCIPAL"
	main_menu_button.pressed.connect(Callable(self, "show_main_menu"))
	pause_container.add_child(main_menu_button)

# LEVEL LOADING
func load_level_scene(level_num: int) -> Node:
	"""Carrega cena do nível específico"""
	var level_scenes = {
		1: "res://Level1.gd",
		2: "res://Level2.gd", 
		3: "res://Level3.gd",
		4: "res://Level4.gd",
		5: "res://Level5.gd",
		6: "res://Level6.gd",
		7: "res://Level7.gd",
		8: "res://Level8.gd",
		9: "res://Level9.gd",
		10: "res://Level10.gd"
	}
	
	var scene_path = level_scenes.get(level_num)
	if scene_path and ResourceLoader.exists(scene_path):
		var scene = load(scene_path)
		return scene.instantiate()
	else:
		# Fallback para Level1 se cena não existe
		return Level1.new()

# SAVE SYSTEM
func save_game():
	"""Salva progresso do jogador"""
	var save_data = {
		"player_stats": player_stats,
		"unlocked_levels": unlocked_levels,
		"current_level": level_number,
		"starting_language": starting_language,
		"save_time": Time.get_unix_time_from_system()
	}
	save_system.save_game(save_data)

func load_game():
	"""Carrega save game"""
	var save_data = save_system.load_game()
	if save_data:
		apply_save_data(save_data)
		return true
	return false

func apply_save_data(save_data: Dictionary):
	"""Aplica dados do save ao jogo"""
	if save_data.has("player_stats"):
		player_stats = save_data.player_stats
	
	if save_data.has("unlocked_levels"):
		unlocked_levels = save_data.unlocked_levels
	
	if save_data.has("current_level"):
		level_number = save_data.current_level
	
	if save_data.has("starting_language"):
		starting_language = save_data.starting_language

# EVENT HANDLERS
func _on_block_snapped(grid_pos: Vector2i):
	"""Called quando bloco é posicionamento na grade"""
	# Contabilizar movimento
	player_stats.total_moves += 1
	player_stats.puzzles_solved += 1

func _on_drag_started(block: LogicBlock):
	"""Called quando começa a arrastar bloco"""
	# Feedback visual/sonoro
	audio_manager.play_sound("pickup")

func _on_player_state_changed(new_state):
	"""Called quando estado do jogador muda"""
	match new_state:
		PlayerController.PlayerState.SUCCESS:
			complete_current_level()
		PlayerController.PlayerState.FAILURE:
			show_failure_feedback()

func load_last_level():
	"""Carrega último nível jogado"""
	if unlocked_levels.size() > 0:
		var last_level = unlocked_levels.back()
		start_level(last_level)

func restart_level():
	"""Reinicia nível atual"""
	if current_level and current_level.has_method("reset"):
		current_level.reset()
		player.reset()
	resume_game()

func show_options():
	"""Mostra menu de opções"""
	# Implementar tela de opções
	pass

func quit_game():
	"""Sai do jogo"""
	save_game()
	get_tree().quit()

func complete_current_level():
	"""Completa nível atual"""
	current_state = GameState.LEVEL_COMPLETE
	
	# Desbloquear próximo nível
	var next_level = level_number + 1
	if not unlocked_levels.has(next_level):
		unlocked_levels.append(next_level)
	
	# Atualizar estatísticas
	player_stats.levels_completed += 1
	
	# Salvar progresso
	save_game()
	
	# Mostrar tela de completion
	show_level_completion()

func show_level_completion():
	"""Mostra tela de completion do nível"""
	# Implementar tela de completion
	pass

func show_failure_feedback():
	"""Mostra feedback de falha"""
	# Implementar feedback de falha
	pass

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

func get_ui_manager() -> UIManager:
	return ui_manager

func get_audio_manager() -> AudioManager:
	return audio_manager

# Utility methods
func format_time(seconds: float) -> String:
	"""Formata tempo em segundos para string legível"""
	var mins = int(seconds / 60)
	var secs = int(seconds % 60)
	return str(mins).pad_zeros(2) + ":" + str(secs).pad_zeros(2)