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
var ability_system: LanguageAbilitySystem
var language_ui: LanguageSelectionUI
var cooldown_indicator: CooldownIndicator

# Sistema de habilidades
var selected_language_type: int = AdvancedLanguageAbilitySystem.ProgrammingLanguage.PYTHON
var marked_position: Vector2 = Vector2.ZERO  # Para JavaScript Callback

# Sistema avançado (Sprint 3)
var advanced_ability_system: AdvancedLanguageAbilitySystem
var advanced_language_ui: AdvancedLanguageUI

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
	setup_ability_system()
	setup_advanced_ability_system()
	
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
	
func setup_ability_system():
	"""Configura sistema de habilidades por linguagem"""
	ability_system = LanguageAbilitySystem.new()
	add_child(ability_system)
	
	# Conectar sistema com player
	if player:
		player.set_language_ability_system(ability_system)
		
	# Configurar indicador de cooldown
	setup_cooldown_indicator()
		
	# Ajustar linguagem inicial
	ability_system.select_language(selected_language_type)

func setup_advanced_ability_system():
	"""Configura sistema avançado de habilidades (Sprint 3)"""
	advanced_ability_system = AdvancedLanguageAbilitySystem.new()
	add_child(advanced_ability_system)
	
	# Conecta com systems básicos
	if ability_system:
		advanced_ability_system.setup_abilities()
		advanced_ability_system.setup_references()
	
	# Conectar com player
	if player:
		player.set_advanced_ability_system(advanced_ability_system)
	
	# Configura UI avançada
	setup_advanced_ui()

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
		{"num": 1, "name": "A Torre de Marfim", "desc": "Conceitos básicos de lógica", "unlocked": true},
		{"num": 2, "name": "A Forja de Ponteiros", "desc": "Ponteiros e memória em C++", "unlocked": false},
		{"num": 3, "name": "A Biblioteca de Objetos", "desc": "Orientação a objetos", "unlocked": false},
		{"num": 4, "name": "A Arquitetura Concorrente", "desc": "Concorrência e paralelismo", "unlocked": false},
		{"num": 5, "name": "O Servidor Web", "desc": "Desenvolvimento Web e APIs", "unlocked": false},
		{"num": 6, "name": "O Aplicativo Móvel", "desc": "Mobile Development", "unlocked": false},
		{"num": 7, "name": "O Data Center", "desc": "Data Science e ML", "unlocked": false},
		{"num": 8, "name": "O Laboratório de Testes", "desc": "Testing e QA Automation", "unlocked": false},
		{"num": 9, "name": "As Fronteiras da Tecnologia", "desc": "IoT, Blockchain, Quantum", "unlocked": false},
		{"num": 10, "name": "O Estúdio de Jogos", "desc": "Unity, Unreal, Game Design", "unlocked": false},
		{"num": 11, "name": "A Fábrica Cloud", "desc": "DevOps, AWS, Docker, K8s", "unlocked": false}
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

# SISTEMA DE HABILIDADES POR LINGUAGEM
func show_language_selection_ui():
	"""Mostra interface de seleção de linguagem"""
	if not language_ui:
		language_ui = LanguageSelectionUI.new()
		add_child(language_ui)
		language_ui.set_ability_system(ability_system)
		language_ui.set_game_manager(self)
		
		# Conectar sinais
		language_ui.connect("language_selected", Callable(self, "_on_language_selected"))
		language_ui.connect("ui_closed", Callable(self, "_on_language_ui_closed"))
	
	language_ui.show_ui()

func force_language_selection():
	"""Força seleção de linguagem no início do nível"""
	show_language_selection_ui()
	
	# Pausa o jogo se estiver jogando
	if current_state == GameState.PLAYING:
		pause_game()

func _on_language_selected(language_type: int):
	"""Callback quando linguagem é selecionada"""
	selected_language_type = language_type
	ability_system.select_language(language_type)
	
	# Atualiza cooldown indicator
	if cooldown_indicator:
		var ability_data = ability_system.get_language_info(language_type)
		cooldown_indicator.show_cooldown(language_type, ability_data)
	
	# Retoma jogo se estava pausado
	if current_state == GameState.PAUSED:
		resume_game()

func _on_language_ui_closed():
	"""Callback quando UI de linguagem é fechada"""
	# Se não foi selecionada linguagem e estamos no início do nível, força seleção
	if current_state == GameState.PLAYING and selected_language_type < 0:
		force_language_selection()

func update_language_display(language_type: int):
	"""Atualiza display da linguagem atual"""
	print("Linguagem selecionada: ", _get_language_name(language_type))
	
	# Atualiza UI se disponível
	var language_name_label = get_node_or_null("CanvasLayer/LanguageInfo/VBoxContainer/LanguageName")
	var ability_name_label = get_node_or_null("CanvasLayer/LanguageInfo/VBoxContainer/AbilityName")
	
	if language_name_label:
		language_name_label.text = _get_language_name(language_type)
		
	if ability_name_label:
		var ability_data = ability_system.get_language_info(language_type)
		ability_name_label.text = ability_data.get("name", "N/A")

func _get_language_name(language_type: int) -> String:
	"""Retorna nome da linguagem"""
	match language_type:
		LanguageAbilitySystem.ProgrammingLanguage.PYTHON:
			return "Python"
		LanguageAbilitySystem.ProgrammingLanguage.JAVA:
			return "Java"
		LanguageAbilitySystem.ProgrammingLanguage.C_SHARP:
			return "C#"
		LanguageAbilitySystem.ProgrammingLanguage.JAVASCRIPT:
			return "JavaScript"
		_:
			return "Unknown"

# Métodos para habilidades específicas
func mark_interaction_allowed(position: Vector2):
	"""Marca uma interação como permitida temporariamente (para Duck Typing)"""
	# Implementação simplificada - poderia ser expandida
	pass

func get_overlapping_objects(position: Vector2, object_type: String) -> Array:
	"""Retorna objetos que sobrepõem uma posição específica"""
	var results = []
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, position + Vector2(1, 0))
	
	var result = space_state.intersect_ray(query)
	if result.size() > 0:
		results.append(result.get("collider"))
	
	return results

func set_marked_position(position: Vector2):
	"""Define posição marcada (para JavaScript Callback)"""
	marked_position = position
	print("Posição marcada para callback: ", position)

func get_marked_position() -> Vector2:
	"""Retorna posição marcada (para JavaScript Callback)"""
	return marked_position

func on_ability_used(language_type: int, success: bool):
	"""Callback quando habilidade é usada"""
	var lang_name = _get_language_name(language_type)
	if success:
		print("Habilidade ", lang_name, " usada com sucesso!")
	else:
		print("Falha ao usar habilidade ", lang_name)

# === MÉTODOS AVANÇADOS (SPRINT 3) ===

func on_advanced_ability_used(language_type: int, success: bool):
	"""Callback para habilidade avançada usada"""
	var lang_name = _get_language_name(language_type)
	if success:
		print("🎯 Habilidade AVANÇADA ", lang_name, " usada com sucesso!")
		
		# Atualiza UI avançada se disponível
		if advanced_language_ui:
			var stats = advanced_ability_system.get_language_stats()
			advanced_language_ui.update_advanced_ui(language_type, stats)
	else:
		print("❌ Falha ao usar habilidade avançada ", lang_name)

func show_advanced_language_info():
	"""Mostra informações avançadas da linguagem atual"""
	if advanced_language_ui:
		advanced_language_ui.show_advanced_ui(selected_language_type)

func show_mastery_overview():
	"""Mostra overview de maestria"""
	if advanced_language_ui:
		advanced_language_ui.show_language_mastery()

func show_language_upgrades():
	"""Mostra melhorias disponíveis"""
	if advanced_language_ui:
		advanced_language_ui.show_current_upgrades()

func show_global_statistics():
	"""Mostra estatísticas globais"""
	if advanced_language_ui:
		advanced_language_ui.show_statistics()

func _on_upgrade_purchased(language_type: int, upgrade_id: String):
	"""Callback quando melhoria é comprada"""
	var lang_name = _get_language_name(language_type)
	print("🛒 Melhoria '", upgrade_id, "' comprada para ", lang_name, "!")
	
	# Atualiza UI
	if advanced_language_ui:
		var stats = advanced_ability_system.get_language_stats()
		advanced_language_ui.update_advanced_ui(language_type, stats)

func _on_language_switched(new_language: int):
	"""Callback quando linguagem é trocada via UI"""
	selected_language_type = new_language
	if ability_system:
		ability_system.select_language(new_language)
	
	# Atualiza displays
	update_language_display(new_language)
	
	# Atualiza UI avançada
	if advanced_language_ui:
		var stats = advanced_ability_system.get_language_stats()
		advanced_language_ui.update_advanced_ui(new_language, stats)

func setup_cooldown_indicator():
	"""Configura o indicador de cooldown"""
	if not cooldown_indicator:
		cooldown_indicator = CooldownIndicator.new()
		add_child(cooldown_indicator)
		cooldown_indicator.set_ability_system(ability_system)
		
		# Conecta com player se disponível
		if player:
			player.set_cooldown_indicator(cooldown_indicator)

func setup_advanced_ui():
	"""Configura interface avançada (Sprint 3)"""
	# UI Avançada para habilidades
	if not advanced_language_ui:
		advanced_language_ui = AdvancedLanguageUI.new()
		add_child(advanced_language_ui)
		advanced_language_ui.set_ability_system(advanced_ability_system)
		advanced_language_ui.set_game_manager(self)
		
		# Conectar sinais da UI avançada
		advanced_language_ui.connect("upgrade_purchased", Callable(self, "_on_upgrade_purchased"))
		advanced_language_ui.connect("language_switched", Callable(self, "_on_language_switched"))

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