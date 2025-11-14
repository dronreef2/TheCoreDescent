# THE CORE DESCENT - GERENCIADOR DE NÍVEIS
# Arquivo: LevelManager.gd - Sistema de navegação e gerenciamento de níveis

extends Node
class_name LevelManager

# Estados do gerenciador
enum ManagerState { MENU, LOADING, PLAYING, PAUSED, COMPLETED }
var current_state: ManagerState = ManagerState.MENU

# Referências aos sistemas
var game_manager: Node
var player_controller: PlayerController
var ui_manager: Node

# Sistema de níveis
var current_level: Node2D
var level_index: int = 0
var available_levels: Array = []
var completed_levels: Array = []
var unlocked_levels: Array = []

# Progresso do jogador
var total_score: int = 0
var achievements_unlocked: Array = []
var concepts_mastered: Dictionary = {}
var time_played: float = 0.0

# Configurações
@export var auto_save_progress: bool = true
@export var show_tutorial: bool = true
@export var difficulty_scaling: bool = true

func _ready():
	setup_level_manager()
	load_available_levels()
	initialize_progress()

func setup_level_manager():
	"""Configura o gerenciador de níveis"""
	# Adicionar ao grupo de managers
	add_to_group("level_manager")
	add_to_group("game_managers")
	
	# Obter referências
	if get_tree().current_scene.has_method("get_game_manager"):
		game_manager = get_tree().current_scene.get_game_manager()
		player_controller = game_manager.get_player()
		ui_manager = game_manager.get_ui_manager()
	
	# Conectar sinais
	connect_signals()

func connect_signals():
	"""Conecta sinais dos níveis"""
	if game_manager:
		game_manager.connect("level_completed", Callable(self, "_on_level_completed"))
		game_manager.connect("puzzle_completed", Callable(self, "_on_puzzle_completed"))

func load_available_levels():
	"""Carrega níveis disponíveis"""
	available_levels = [
		{
			"id": 1,
			"name": "A Torre de Marfim",
			"description": "Conceitos básicos de lógica de programação",
			"scene_path": "res://codigo/Level1.gd",
			"required_concepts": [],
			"difficulty": "Iniciante",
			"estimated_time": 15,
			"is_unlocked": true,
			"is_completed": false
		},
		{
			"id": 2,
			"name": "A Forja de Ponteiros", 
			"description": "Ponteiros e gerenciamento de memória em C++",
			"scene_path": "res://codigo/Level2.gd",
			"required_concepts": ["lógica_básica", "variáveis"],
			"difficulty": "Intermediário",
			"estimated_time": 25,
			"is_unlocked": false,
			"is_completed": false
		},
		{
			"id": 3,
			"name": "A Biblioteca de Objetos",
			"description": "Orientação a objetos em Java/Python",
			"scene_path": "res://codigo/Level3.gd",
			"required_concepts": ["lógica_básica", "ponteiros"],
			"difficulty": "Intermediário-Avançado",
			"estimated_time": 35,
			"is_unlocked": false,
			"is_completed": false
		},
		{
			"id": 4,
			"name": "A Arquitetura Concorrente",
			"description": "Concorrência e padrões em C#/JavaScript",
			"scene_path": "res://codigo/Level4.gd",
			"required_concepts": ["lógica_básica", "orientação_objetos", "ponteiros"],
			"difficulty": "Avançado",
			"estimated_time": 45,
			"is_unlocked": false,
			"is_completed": false
		},
		{
			"id": 5,
			"name": "O Arquiteto de Software",
			"description": "Integração de todos os conceitos",
			"scene_path": "res://codigo/Level5.gd",
			"required_concepts": ["lógica_básica", "orientação_objetos", "ponteiros", "concorrência"],
			"difficulty": "Especialista",
			"estimated_time": 60,
			"is_unlocked": false,
			"is_completed": false
		},
		{
			"id": 6,
			"name": "A Arquitetura Web",
			"description": "Desenvolvimento web moderno e full-stack",
			"scene_path": "res://codigo/Level6.gd",
			"required_concepts": ["lógica_básica", "orientação_objetos", "web_development"],
			"difficulty": "Especialista-Avançado",
			"estimated_time": 75,
			"is_unlocked": false,
			"is_completed": false
		},
		{
			"id": 7,
			"name": "O Ecossistema Mobile",
			"description": "Desenvolvimento mobile nativo e cross-platform",
			"scene_path": "res://codigo/Level7.gd",
			"required_concepts": ["lógica_básica", "orientação_objetos", "web_development", "mobile_development"],
			"difficulty": "Especialista-Avançado",
			"estimated_time": 85,
			"is_unlocked": false,
			"is_completed": false
		},
		{
			"id": 8,
			"name": "A Ciência dos Dados",
			"description": "Data Science e Machine Learning",
			"scene_path": "res://codigo/Level8.gd",
			"required_concepts": ["lógica_básica", "orientação_objetos", "algoritmos", "data_science"],
			"difficulty": "Especialista-Máximo",
			"estimated_time": 95,
			"is_unlocked": false,
			"is_completed": false
		},
		{
			"id": 9,
			"name": "As Fronteiras da Tecnologia",
			"description": "IoT, Blockchain e Computação Quântica",
			"scene_path": "res://codigo/Level9.gd",
			"required_concepts": ["lógica_básica", "orientação_objetos", "web_development", "mobile_development", "data_science"],
			"difficulty": "Inovador",
			"estimated_time": 120,
			"is_unlocked": false,
			"is_completed": false
		}
	]
	
	# Configurar níveis desbloqueados inicialmente
	unlocked_levels = [1]  # Apenas o primeiro nível disponível

func initialize_progress():
	"""Inicializa o progresso do jogador"""
	# Carregar progresso salvo (implementação futura)
	load_saved_progress()
	
	# Atualizar UI do menu principal
	update_main_menu()

func load_level(level_id: int):
	"""Carrega um nível específico"""
	if not can_access_level(level_id):
		show_level_locked_message(level_id)
		return false
	
	# Atualizar estado
	current_state = ManagerState.LOADING
	
	# Encontrar dados do nível
	var level_data = get_level_data(level_id)
	if not level_data:
		print("Erro: Nível ", level_id, " não encontrado")
		return false
	
	# Carregar o script do nível
	var level_script = load(level_data.scene_path)
	if not level_script:
		print("Erro: Não foi possível carregar o script do nível ", level_id)
		return false
	
	# Instanciar o nível
	current_level = level_script.new()
	
	# Adicionar à árvore de cena
	add_child(current_level)
	
	# Configurar jogador para o nível
	setup_player_for_level(level_id)
	
	# Conectar sinais do nível
	connect_level_signals(current_level)
	
	# Atualizar UI
	update_level_ui(level_id)
	
	# Iniciar nível
	current_level.call_deferred("start_level")
	
	current_state = ManagerState.PLAYING
	level_index = level_id
	
	print("Nível ", level_id, " carregado com sucesso")
	return true

func setup_player_for_level(level_id: int):
	"""Configura o jogador para um nível específico"""
	if not player_controller:
		return
	
	# Reset do jogador
	player_controller.reset()
	
	# Configurações específicas por nível
	match level_id:
		1:
			player_controller.enable_abilities(false)
		2:
			player_controller.enable_abilities(true)
			player_controller.set_available_languages(["cpp"])
		3:
			player_controller.enable_abilities(true)
			player_controller.set_available_languages(["java", "python"])
		4:
			player_controller.enable_abilities(true)
			player_controller.set_available_languages(["csharp", "javascript"])
		5:
			player_controller.enable_abilities(true)
			player_controller.set_available_languages(["cpp", "java", "python", "csharp", "javascript"])

func connect_level_signals(level: Node):
	"""Conecta sinais do nível atual"""
	if level.has_signal("puzzle_loaded"):
		level.connect("puzzle_loaded", Callable(self, "_on_puzzle_loaded"))
	if level.has_signal("level_completed"):
		level.connect("level_completed", Callable(self, "_on_level_completed"))
	if level.has_signal("puzzle_completed"):
		level.connect("puzzle_completed", Callable(self, "_on_puzzle_completed"))

func unload_current_level():
	"""Descarrega o nível atual"""
	if current_level:
		# Salvar progresso antes de descarregar
		if auto_save_progress:
			save_level_progress()
		
		# Desconectar sinais
		if current_level.is_connected("puzzle_loaded", Callable(self, "_on_puzzle_loaded")):
			current_level.disconnect("puzzle_loaded", Callable(self, "_on_puzzle_loaded"))
		if current_level.is_connected("level_completed", Callable(self, "_on_level_completed")):
			current_level.disconnect("level_completed", Callable(self, "_on_level_completed"))
		if current_level.is_connected("puzzle_completed", Callable(self, "_on_puzzle_completed")):
			current_level.disconnect("puzzle_completed", Callable(self, "_on_puzzle_completed"))
		
		# Remover da árvore
		current_level.queue_free()
		current_level = null
	
	current_state = ManagerState.MENU

func complete_level(level_id: int, final_score: Dictionary):
	"""Marca um nível como completado"""
	# Atualizar dados do nível
	for i in range(available_levels.size()):
		if available_levels[i]["id"] == level_id:
			available_levels[i]["is_completed"] = true
			available_levels[i]["final_score"] = final_score
			break
	
	# Adicionar à lista de completados
	if not completed_levels.has(level_id):
		completed_levels.append(level_id)
	
	# Desbloquear próximo nível
	unlock_next_level(level_id)
	
	# Atualizar pontuação total
	total_score += int(final_score.get("total", 0))
	
	# Verificar conquistas
	check_achievements(level_id, final_score)
	
	# Salvar progresso
	if auto_save_progress:
		save_progress()
	
	# Atualizar UI
	update_progress_ui()
	
	print("Nível ", level_id, " completado com pontuação: ", final_score)

func unlock_next_level(completed_level_id: int):
	"""Desbloqueia o próximo nível"""
	var next_level_id = completed_level_id + 1
	
	# Verificar se existe próximo nível
	if next_level_id <= available_levels.size():
		# Verificar se já está desbloqueado
		if not unlocked_levels.has(next_level_id):
			# Verificar pré-requisitos
			var next_level_data = get_level_data(next_level_id)
			if meets_prerequisites(next_level_data):
				unlocked_levels.append(next_level_id)
				show_level_unlocked_message(next_level_id)
			else:
				print("Pré-requisitos não atendidos para nível ", next_level_id)

func meets_prerequisites(level_data: Dictionary) -> bool:
	"""Verifica se o jogador atende aos pré-requisitos de um nível"""
	var required_concepts = level_data.get("required_concepts", [])
	
	for concept in required_concepts:
		if not concepts_mastered.has(concept) or not concepts_mastered[concept]:
			return false
	
	return true

func can_access_level(level_id: int) -> bool:
	"""Verifica se o jogador pode acessar um nível"""
	return unlocked_levels.has(level_id)

func get_level_data(level_id: int) -> Dictionary:
	"""Retorna dados de um nível específico"""
	for level_data in available_levels:
		if level_data["id"] == level_id:
			return level_data
	return {}

func get_current_level_info() -> Dictionary:
	"""Retorna informações do nível atual"""
	if current_level and current_level.has_method("get_level_info"):
		return current_level.get_level_info()
	return {}

func pause_level():
	"""Pausa o nível atual"""
	if current_state == ManagerState.PLAYING and current_level:
		current_state = ManagerState.PAUSED
		if current_level.has_method("pause"):
			current_level.pause()
		show_pause_menu()

func resume_level():
	"""Resume o nível pausado"""
	if current_state == ManagerState.PAUSED and current_level:
		current_state = ManagerState.PLAYING
		if current_level.has_method("resume"):
			current_level.resume()
		hide_pause_menu()

func restart_level():
	"""Reinicia o nível atual"""
	if current_level:
		var current_level_id = level_index
		unload_current_level()
		load_level(current_level_id)

func go_to_menu():
	"""Volta ao menu principal"""
	unload_current_level()
	current_state = ManagerState.MENU
	update_main_menu()

func update_level_ui(level_id: int):
	"""Atualiza UI para o nível atual"""
	var level_data = get_level_data(level_id)
	if ui_manager and ui_manager.has_method("update_level_info"):
		ui_manager.update_level_info(level_data)

func update_main_menu():
	"""Atualiza interface do menu principal"""
	if ui_manager and ui_manager.has_method("update_main_menu"):
		ui_manager.update_main_menu(available_levels, unlocked_levels, completed_levels)

func update_progress_ui():
	"""Atualiza interface de progresso"""
	if ui_manager and ui_manager.has_method("update_progress"):
		ui_manager.update_progress(total_score, completed_levels.size(), available_levels.size())

func show_pause_menu():
	"""Mostra menu de pausa"""
	if ui_manager and ui_manager.has_method("show_pause_menu"):
		ui_manager.show_pause_menu()

func hide_pause_menu():
	"""Esconde menu de pausa"""
	if ui_manager and ui_manager.has_method("hide_pause_menu"):
		ui_manager.hide_pause_menu()

func show_level_locked_message(level_id: int):
	"""Mostra mensagem de nível bloqueado"""
	var level_data = get_level_data(level_id)
	print("Nível '" + level_data.get("name", "Nível") + "' está bloqueado. Complete níveis anteriores primeiro.")

func show_level_unlocked_message(level_id: int):
	"""Mostra mensagem de novo nível desbloqueado"""
	var level_data = get_level_data(level_id)
	print("🎉 Novo nível desbloqueado: " + level_data.get("name", "Nível") + "!")

func check_achievements(level_id: int, score: Dictionary):
	"""Verifica e desbloqueia conquistas"""
	var achievements_to_check = [
		{
			"id": "first_level",
			"name": "Primeiros Passos",
			"description": "Complete o primeiro nível",
			"condition": func(): return completed_levels.size() >= 1
		},
		{
			"id": "perfect_score",
			"name": "Perfeccionista",
			"description": "Obtenha 100% em qualquer nível",
			"condition": func(): return score.get("total", 0) >= 100
		},
		{
			"id": "speedrunner",
			"name": "Velocista",
			"description": "Complete qualquer nível em menos de 2 minutos",
			"condition": func(): return score.get("time", 999) < 120
		},
		{
			"id": "all_levels",
			"name": "Arquiteto Completo",
			"description": "Complete todos os níveis",
			"condition": func(): return completed_levels.size() >= available_levels.size()
		}
	]
	
	for achievement in achievements_to_check:
		if not achievements_unlocked.has(achievement["id"]):
			if achievement["condition"].call():
				achievements_unlocked.append(achievement["id"])
				print("🏆 Conquista desbloqueada: " + achievement["name"])
				show_achievement_notification(achievement)

func show_achievement_notification(achievement: Dictionary):
	"""Mostra notificação de conquista"""
	if ui_manager and ui_manager.has_method("show_achievement"):
		ui_manager.show_achievement(achievement)

func master_concept(concept_name: String):
	"""Marca um conceito como dominado"""
	concepts_mastered[concept_name] = true
	print("📚 Conceito dominado: " + concept_name)

# Sistema de Salvamento (implementação básica)
func save_progress():
	"""Salva o progresso do jogador"""
	var save_data = {
		"completed_levels": completed_levels,
		"unlocked_levels": unlocked_levels,
		"total_score": total_score,
		"achievements": achievements_unlocked,
		"concepts_mastered": concepts_mastered,
		"time_played": time_played,
		"timestamp": Time.get_unix_time_from_system()
	}
	
	# Aqui seria implementada a salvamento real em arquivo
	print("Progresso salvo: ", save_data)

func load_saved_progress():
	"""Carrega o progresso salvo"""
	# Implementação básica - aqui seria carregado de arquivo
	# Por enquanto, usar valores padrão
	pass

func save_level_progress():
	"""Salva progresso do nível atual"""
	if current_level and current_level.has_method("get_level_info"):
		var level_info = current_level.get_level_info()
		# Salvar informações específicas do nível
		pass

# Signal Handlers
func _on_puzzle_loaded(puzzle_index: int):
	"""Called quando puzzle é carregado"""
	print("Puzzle ", puzzle_index + 1, " carregado")

func _on_puzzle_completed(score: Dictionary):
	"""Called quando puzzle é completado"""
	print("Puzzle completado! Pontuação: ", score)

func _on_level_completed(puzzle_count: int):
	"""Called quando nível é completado"""
	var level_score = calculate_final_level_score()
	complete_level(level_index, level_score)

func _process(delta):
	"""Processa lógica do gerenciador"""
	if current_state == ManagerState.PLAYING:
		time_played += delta
	
	# Atalhos de teclado globais
	if Input.is_action_just_pressed("ui_cancel"):  # ESC
		if current_state == ManagerState.PLAYING:
			pause_level()
		elif current_state == ManagerState.PAUSED:
			resume_level()
	
	if Input.is_action_just_pressed("ui_accept") and current_state == ManagerState.PAUSED:  # Enter
		resume_level()

func calculate_final_level_score() -> Dictionary:
	"""Calcula pontuação final do nível"""
	if current_level and current_level.has_method("get_level_info"):
		var info = current_level.get_level_info()
		return {
			"total": 85 + randi() % 15,  # Simulação de cálculo
			"efficiency": 80 + randi() % 20,
			"speed": 75 + randi() % 25,
			"concepts": 90 + randi() % 10
		}
	return {"total": 0}

# Métodos Públicos para UI
func get_progress_summary() -> Dictionary:
	"""Retorna resumo do progresso do jogador"""
	return {
		"total_levels": available_levels.size(),
		"completed_levels": completed_levels.size(),
		"unlocked_levels": unlocked_levels.size(),
		"total_score": total_score,
		"achievements": achievements_unlocked.size(),
		"concepts_mastered": concepts_mastered.size(),
		"time_played": time_played
	}

func get_level_statistics() -> Array:
	"""Retorna estatísticas detalhadas de cada nível"""
	var stats = []
	for level_data in available_levels:
		var stat = level_data.duplicate()
		stat["is_completed"] = completed_levels.has(level_data["id"])
		stat["is_unlocked"] = unlocked_levels.has(level_data["id"])
		stat["completion_time"] = get_level_completion_time(level_data["id"])
		stat["best_score"] = get_level_best_score(level_data["id"])
		stats.append(stat)
	return stats

func get_level_completion_time(level_id: int) -> float:
	"""Retorna tempo de conclusão de um nível"""
	# Implementação básica - seria calculado com dados reais
	return 0.0

func get_level_best_score(level_id: int) -> int:
	"""Retorna melhor pontuação de um nível"""
	var level_data = get_level_data(level_id)
	if level_data.has("final_score"):
		return int(level_data["final_score"].get("total", 0))
	return 0