# THE CORE DESCENT - ARQUITETURA PRINCIPAL
# Arquivo: GameManager.gd - Coordenador principal do jogo (REFATORADO)
# Agora delega state e level flow para services dedicados

extends Node
class_name GameManager

# Services (dependency injection)
var game_state_service: GameStateService
var level_flow_service: LevelFlowService

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
	game_state_service.show_main_menu()

func setup_game_systems():
	"""Configura todos os sistemas principais"""
	# AutoLoad singleton para GameManager
	if name != "GameManager":
		name = "GameManager"
	
	# Inicializar services
	setup_services()
	
	# Inicializar managers principais
	setup_drag_system()
	setup_player()
	setup_ui_manager()
	setup_audio_manager()
	setup_save_system()
	
	# Conectar sinais
	connect_signals()

func setup_services():
	"""Configura services de state e level flow"""
	# Tentar obter services como AutoLoad, ou criar localmente
	if has_node("/root/GameStateService"):
		game_state_service = get_node("/root/GameStateService")
	else:
		game_state_service = GameStateService.new()
		add_child(game_state_service)
	
	if has_node("/root/LevelFlowService"):
		level_flow_service = get_node("/root/LevelFlowService")
	else:
		level_flow_service = LevelFlowService.new()
		add_child(level_flow_service)
	
	# Conectar sinais dos services
	game_state_service.state_changed.connect(_on_state_changed)
	game_state_service.level_unlocked.connect(_on_level_unlocked)
	level_flow_service.level_loaded.connect(_on_level_loaded)

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

# STATE MANAGEMENT (delegado para GameStateService)
func _on_state_changed(old_state: GameStateService.GameState, new_state: GameStateService.GameState):
	"""Reage a mudanças de estado vindas do service"""
	# Cleanup estado anterior
	match old_state:
		GameStateService.GameState.MAIN_MENU:
			cleanup_main_menu()
		GameStateService.GameState.LEVEL_SELECT:
			cleanup_level_select()
		GameStateService.GameState.PLAYING:
			cleanup_gameplay()
	
	# Setup novo estado
	match new_state:
		GameStateService.GameState.MAIN_MENU:
			setup_main_menu()
		GameStateService.GameState.LEVEL_SELECT:
			setup_level_select()
		GameStateService.GameState.PLAYING:
			setup_gameplay()
		GameStateService.GameState.PAUSED:
			setup_pause_menu()
			get_tree().paused = true
		GameStateService.GameState.LEVEL_COMPLETE:
			setup_level_complete()
	
	# Resume logic
	if old_state == GameStateService.GameState.PAUSED:
		get_tree().paused = false

func show_main_menu():
	"""Mostra menu principal"""
	game_state_service.show_main_menu()

func show_level_select():
	"""Mostra seleção de níveis"""
	game_state_service.show_level_select()

func start_level(level_num: int):
	"""Inicia nível específico"""
	game_state_service.start_level(level_num)

func pause_game():
	"""Pausa o jogo"""
	game_state_service.pause_game()

func resume_game():
	"""Resume o jogo"""
	game_state_service.resume_game()

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
	name_label.modulate = Color.WHITE if level_data.unlocked else Color.GRAY
	button_container.add_child(name_label)
	
	# Descrição
	var desc_label = Label.new()
	desc_label.text = level_data.name
	desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc_label.scale = Vector2(0.8, 0.8)
	desc_label.modulate = Color.CYAN if level_data.unlocked else Color.GRAY
	button_container.add_child(desc_label)
	
	# Status
	var status_label = Label.new()
	status_label.text = level_data.desc
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.scale = Vector2(0.7, 0.7)
	status_label.modulate = Color.GREEN if level_data.unlocked else Color.RED
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

# GAMEPLAY (delegado para LevelFlowService)
func setup_gameplay():
	"""Configura gameplay do nível"""
	cleanup_ui()
	
	# Carregar nível via service
	var success = level_flow_service.start_level(game_state_service.level_number, self)
	if not success:
		push_error("Failed to load level " + str(game_state_service.level_number))
		return
	
	# Configurar jogador
	if player:
		player.position = Vector2(100, 100)
		player.start_level()
	
	# Setup HUD via service
	var hud_node = level_flow_service.setup_hud(self)
	if hud_node:
		# Adicionar info customizada ao HUD
		var player_info = Label.new()
		player_info.text = "Linguagem: " + starting_language
		player_info.position = Vector2(50, 15)
		hud_node.add_child(player_info)
		
		# Conectar pause button
		var pause_btn = hud_node.get_node("Button")
		if pause_btn:
			pause_btn.pressed.connect(Callable(self, "pause_game"))
	
	# Input mapping para pause
	setup_input_mapping()

func cleanup_gameplay():
	"""Limpa gameplay"""
	level_flow_service.cleanup_level()

func _on_level_loaded(level_node: Node):
	"""Callback quando nível é carregado pelo service"""
	print("Level loaded: ", level_node.name)

# PAUSE MENU (delegado para LevelFlowService)
func setup_pause_menu():
	"""Configura menu de pause"""
	pause_menu = level_flow_service.setup_pause_menu(self)
	
	# Conectar botões personalizados
	var pause_container = pause_menu.get_node("VBoxContainer")
	if pause_container:
		# Adicionar botões customizados
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

# LEVEL LOADING (obsoleto - mantido para compatibilidade)
func load_level_scene(level_num: int) -> Node:
	"""DEPRECATED: Use level_flow_service.load_level_scene() instead"""
	return level_flow_service.load_level_scene(level_num)

# SAVE SYSTEM (delegado para GameStateService)
func save_game():
	"""Salva progresso do jogador"""
	var save_data = game_state_service.get_save_data()
	save_data["starting_language"] = starting_language
	save_data["save_time"] = Time.get_unix_time_from_system()
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
	game_state_service.apply_save_data(save_data)
	
	if save_data.has("starting_language"):
		starting_language = save_data.starting_language

# EVENT HANDLERS
func _on_block_snapped(grid_pos: Vector2i):
	"""Called quando bloco é posicionamento na grade"""
	# Contabilizar movimento via service
	game_state_service.increment_stat("total_moves")
	game_state_service.increment_stat("puzzles_solved")

func _on_drag_started(block: LogicBlock):
	"""Called quando começa a arrastar bloco"""
	# Feedback visual/sonoro
	if audio_manager:
		audio_manager.play_sound("pickup")

func _on_player_state_changed(new_state):
	"""Called quando estado do jogador muda"""
	match new_state:
		PlayerController.PlayerState.SUCCESS:
			complete_current_level()
		PlayerController.PlayerState.FAILURE:
			show_failure_feedback()

func _on_level_unlocked(level_num: int):
	"""Callback quando nível é desbloqueado"""
	print("Level unlocked: ", level_num)
	# Atualizar UI de seleção de níveis se visível

func load_last_level():
	"""Carrega último nível jogado"""
	var unlocked = game_state_service.get_unlocked_levels()
	if unlocked.size() > 0:
		var last_level = unlocked.back()
		start_level(last_level)

func restart_level():
	"""Reinicia nível atual"""
	var current_level = level_flow_service.current_level
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
	game_state_service.complete_level()
	
	# Desbloquear próximo nível via service
	var next_level = game_state_service.level_number + 1
	game_state_service.unlock_level(next_level)
	
	# Atualizar estatísticas via service
	game_state_service.increment_stat("levels_completed")
	
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