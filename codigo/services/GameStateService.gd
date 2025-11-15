# THE CORE DESCENT - GAME STATE SERVICE
# Arquivo: GameStateService.gd - Gerencia estado global e progressão

extends Node
class_name GameStateService

# Estado global do jogo
enum GameState { 
	MAIN_MENU, 
	LEVEL_SELECT, 
	PLAYING, 
	PAUSED, 
	GAME_OVER, 
	LEVEL_COMPLETE 
}

# Sinais para comunicação assíncrona
signal state_changed(old_state: GameState, new_state: GameState)
signal level_unlocked(level_number: int)
signal progress_updated(stats: Dictionary)

# Estado atual
var current_state: GameState = GameState.MAIN_MENU
var level_number: int = 1

# Progressão do jogador
var unlocked_levels: Array[int] = [1]  # Apenas nível 1 unlocked inicialmente
var player_stats: Dictionary = {
	"total_time_played": 0.0,
	"levels_completed": 0,
	"puzzles_solved": 0,
	"total_moves": 0,
	"languages_unlocked": ["PYTHON"]
}

func _ready():
	# AutoLoad singleton setup
	if name != "GameStateService":
		name = "GameStateService"

# STATE MANAGEMENT
func change_state(new_state: GameState) -> void:
	"""Muda estado global do jogo"""
	if current_state == new_state:
		return  # Evita mudanças redundantes
	
	var old_state = current_state
	current_state = new_state
	state_changed.emit(old_state, new_state)

func get_state() -> GameState:
	"""Retorna estado atual"""
	return current_state

# MENU NAVIGATION
func show_main_menu() -> void:
	"""Navega para menu principal"""
	change_state(GameState.MAIN_MENU)

func show_level_select() -> void:
	"""Navega para seleção de níveis"""
	change_state(GameState.LEVEL_SELECT)

func start_level(num: int) -> void:
	"""Inicia nível específico"""
	level_number = num
	change_state(GameState.PLAYING)

func pause_game() -> void:
	"""Pausa o jogo"""
	if current_state == GameState.PLAYING:
		change_state(GameState.PAUSED)

func resume_game() -> void:
	"""Resume o jogo"""
	if current_state == GameState.PAUSED:
		change_state(GameState.PLAYING)

func complete_level() -> void:
	"""Marca nível como completo"""
	change_state(GameState.LEVEL_COMPLETE)

func game_over() -> void:
	"""Marca game over"""
	change_state(GameState.GAME_OVER)

# PROGRESSION MANAGEMENT
func unlock_level(num: int) -> void:
	"""Desbloqueia nível específico"""
	if num not in unlocked_levels:
		unlocked_levels.append(num)
		unlocked_levels.sort()
		level_unlocked.emit(num)

func is_level_unlocked(num: int) -> bool:
	"""Verifica se nível está desbloqueado"""
	return num in unlocked_levels

func get_unlocked_levels() -> Array[int]:
	"""Retorna lista de níveis desbloqueados"""
	return unlocked_levels.duplicate()

# STATS TRACKING
func update_stat(key: String, value: Variant) -> void:
	"""Atualiza estatística do jogador"""
	player_stats[key] = value
	progress_updated.emit(player_stats)

func increment_stat(key: String, amount: float = 1.0) -> void:
	"""Incrementa estatística numérica"""
	if key in player_stats and typeof(player_stats[key]) in [TYPE_INT, TYPE_FLOAT]:
		player_stats[key] += amount
		progress_updated.emit(player_stats)

func unlock_language(language: String) -> void:
	"""Desbloqueia linguagem de programação"""
	if language not in player_stats["languages_unlocked"]:
		player_stats["languages_unlocked"].append(language)
		progress_updated.emit(player_stats)

func get_stats() -> Dictionary:
	"""Retorna cópia das estatísticas"""
	return player_stats.duplicate(true)

# SAVE/LOAD HELPERS
func get_save_data() -> Dictionary:
	"""Retorna dados para salvamento"""
	return {
		"unlocked_levels": unlocked_levels.duplicate(),
		"player_stats": player_stats.duplicate(true),
		"current_level": level_number
	}

func apply_save_data(data: Dictionary) -> void:
	"""Aplica dados carregados"""
	if "unlocked_levels" in data:
		unlocked_levels = data["unlocked_levels"].duplicate()
	if "player_stats" in data:
		player_stats = data["player_stats"].duplicate(true)
	if "current_level" in data:
		level_number = data["current_level"]
	progress_updated.emit(player_stats)
