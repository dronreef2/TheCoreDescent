# THE CORE DESCENT - LEVEL FLOW SERVICE  
# Arquivo: LevelFlowService.gd - Gerencia ciclo de vida de níveis e cenas

extends Node
class_name LevelFlowService

# Sinais para comunicação
signal level_loaded(level_node: Node)
signal level_cleared(level_num: int)
signal hud_created(hud_node: Control)

# Referências
var current_level: Node = null
var hud: Control = null
var pause_menu: Control = null

# Cache de cenas
var level_scenes: Dictionary = {}  # {1: PackedScene, 2: PackedScene, ...}

# Configurações
@export var default_scene_directory: String = "res://levels/"

func _ready():
	if name != "LevelFlowService":
		name = "LevelFlowService"

# LEVEL LOADING
func load_level_scene(level_num: int) -> Node:
	"""Carrega e instancia cena do nível"""
	var scene_path = get_level_scene_path(level_num)
	
	if not ResourceLoader.exists(scene_path):
		push_error("Level scene not found: " + scene_path)
		return null
	
	var packed_scene: PackedScene
	if level_num in level_scenes:
		packed_scene = level_scenes[level_num]
	else:
		packed_scene = load(scene_path)
		level_scenes[level_num] = packed_scene
	
	if not packed_scene:
		push_error("Failed to load level scene: " + scene_path)
		return null
	
	var instance = packed_scene.instantiate()
	if not instance:
		push_error("Failed to instantiate level: " + scene_path)
		return null
	
	return instance

func get_level_scene_path(level_num: int) -> String:
	"""Retorna caminho da cena do nível"""
	return default_scene_directory + "Level" + str(level_num) + ".tscn"

func start_level(level_num: int, parent: Node) -> bool:
	"""Inicia nível - carrega cena e adiciona à árvore"""
	# Limpar nível anterior se existir
	if current_level:
		cleanup_level()
	
	# Carregar novo nível
	current_level = load_level_scene(level_num)
	if not current_level:
		return false
	
	# Adicionar à árvore
	parent.add_child(current_level)
	level_loaded.emit(current_level)
	return true

func cleanup_level() -> void:
	"""Remove nível atual da árvore"""
	if current_level:
		var level_num = extract_level_number(current_level.name)
		current_level.queue_free()
		current_level = null
		level_cleared.emit(level_num)

func extract_level_number(level_name: String) -> int:
	"""Extrai número do nível a partir do nome"""
	var regex = RegEx.new()
	regex.compile("Level(\\d+)")
	var result = regex.search(level_name)
	if result:
		return result.get_string(1).to_int()
	return 0

# HUD MANAGEMENT
func setup_hud(parent: Node) -> Control:
	"""Cria e configura HUD básico"""
	cleanup_hud()
	
	hud = Control.new()
	hud.name = "HUD"
	hud.anchor_left = 0
	hud.anchor_top = 0
	hud.anchor_right = 1
	hud.anchor_bottom = 0
	hud.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	parent.add_child(hud)
	
	# Botão de pause
	var pause_button = Button.new()
	pause_button.text = "II"
	pause_button.position = Vector2(10, 10)
	hud.add_child(pause_button)
	
	hud_created.emit(hud)
	return hud

func cleanup_hud() -> void:
	"""Remove HUD atual"""
	if hud:
		hud.queue_free()
		hud = null

# PAUSE MENU MANAGEMENT
func setup_pause_menu(parent: Node) -> Control:
	"""Cria menu de pause"""
	cleanup_pause_menu()
	
	pause_menu = Control.new()
	pause_menu.name = "PauseMenu"
	pause_menu.anchor_left = 0
	pause_menu.anchor_top = 0
	pause_menu.anchor_right = 1
	pause_menu.anchor_bottom = 1
	pause_menu.modulate = Color(0, 0, 0, 0.7)
	parent.add_child(pause_menu)
	
	var pause_container = VBoxContainer.new()
	pause_container.anchor_left = 0.5
	pause_container.anchor_top = 0.5
	pause_container.anchor_right = 0.5
	pause_container.anchor_bottom = 0.5
	pause_container.position = Vector2(-100, -75)
	pause_menu.add_child(pause_container)
	
	# Título
	var title = Label.new()
	title.text = "PAUSADO"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pause_container.add_child(title)
	
	return pause_menu

func cleanup_pause_menu() -> void:
	"""Remove menu de pause"""
	if pause_menu:
		pause_menu.queue_free()
		pause_menu = null

# LEVEL SELECT HELPERS
func get_level_metadata(level_num: int) -> Dictionary:
	"""Retorna metadados de um nível"""
	# Mapeamento estático - pode ser movido para JSON config
	var metadata_map = {
		1: {"name": "A Torre de Marfim", "desc": "High-Level Languages"},
		2: {"name": "A Forja de Ponteiros", "desc": "C/C++ Memory Management"},
		3: {"name": "O Salão dos Mnemônicos", "desc": "Assembly Optimization"},
		4: {"name": "O Abismo Binário", "desc": "Machine Language"},
		5: {"name": "O Núcleo de Silício", "desc": "Hardware Logic"},
		6: {"name": "A Arquitetura Web", "desc": "Web Development Full-Stack"},
		7: {"name": "O Ecossistema Mobile", "desc": "Mobile Development"},
		8: {"name": "A Ciência dos Dados", "desc": "Data Science & ML"},
		9: {"name": "As Fronteiras da Tecnologia", "desc": "IoT, Blockchain, Quantum"},
		10: {"name": "O Estúdio de Jogos", "desc": "Game Development"},
		11: {"name": "A Fortaleza Digital", "desc": "Cybersecurity"},
		12: {"name": "Laboratório de Produto", "desc": "Product Management"},
		13: {"name": "O Observatório Quântico", "desc": "Quantum Computing"},
		14: {"name": "A Singularidade", "desc": "AI/AGI Research"}
	}
	
	if level_num in metadata_map:
		return metadata_map[level_num]
	return {"name": "Nível " + str(level_num), "desc": "Unknown"}

func get_total_levels() -> int:
	"""Retorna número total de níveis disponíveis"""
	return 14

# CLEANUP MASTER
func cleanup_all() -> void:
	"""Limpa todos os recursos gerenciados"""
	cleanup_level()
	cleanup_hud()
	cleanup_pause_menu()
