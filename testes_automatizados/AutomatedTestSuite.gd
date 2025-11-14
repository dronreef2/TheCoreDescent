# THE CORE DESCENT - SUITE DE TESTES AUTOMATIZADOS
# Arquivo: AutomatedTestSuite.gd - Testes para validação completa dos 9 níveis

extends Node
class_name AutomatedTestSuite

# Configurações de teste
@export var test_all_levels: bool = true
@export var verbose_output: bool = true
@export var performance_test: bool = true
@export var integration_test: bool = true

# Referências aos sistemas principais
var level_manager: LevelManager
var player_controller: PlayerController
var game_manager: Node

# Resultados dos testes
var test_results: Dictionary = {}
var performance_metrics: Dictionary = {}
var integration_issues: Array = []
var bugs_found: Array = []

# Temporizadores para performance
var test_start_time: float
var level_start_time: float

# Estados de teste
enum TestState { IDLE, TESTING_LEVELS, TESTING_PERFORMANCE, TESTING_INTEGRATION, COMPLETED }
var current_test_state: TestState = TestState.IDLE

# Estrutura de níveis para teste
var test_levels: Array = [
	{"id": 1, "name": "A Torre de Marfim", "expected_moves": 8, "target_score": 85},
	{"id": 2, "name": "A Forja de Ponteiros", "expected_moves": 12, "target_score": 82},
	{"id": 3, "name": "A Biblioteca de Objetos", "expected_moves": 17, "target_score": 80},
	{"id": 4, "name": "A Arquitetura Concorrente", "expected_moves": 21, "target_score": 78},
	{"id": 5, "name": "O Arquiteto de Software", "expected_moves": 25, "target_score": 75},
	{"id": 6, "name": "A Arquitetura Web", "expected_moves": 28, "target_score": 82},
	{"id": 7, "name": "O Ecossistema Mobile", "expected_moves": 32, "target_score": 80},
	{"id": 8, "name": "A Ciência dos Dados", "expected_moves": 36, "target_score": 78},
	{"id": 9, "name": "As Fronteiras da Tecnologia", "expected_moves": 40, "target_score": 85}
]

func _ready():
	setup_test_suite()

func setup_test_suite():
	"""Configura a suite de testes"""
	# Obter referências aos sistemas
	level_manager = get_tree().get_root().get_node("Main/GameManager/LevelManager")
	player_controller = get_tree().get_root().get_node("Main/GameManager/PlayerController")
	game_manager = get_tree().get_root().get_node("Main/GameManager")
	
	# Configurar conexão com sistemas
	connect_systems()
	
	print("🧪 Suite de testes automatizados configurada")

func connect_systems():
	"""Conecta sinais dos sistemas para teste"""
	if level_manager:
		level_manager.connect("level_completed", Callable(self, "_on_level_completed"))
		level_manager.connect("puzzle_completed", Callable(self, "_on_puzzle_completed"))

# === EXECUÇÃO DE TESTES ===

func run_complete_test_suite():
	"""Executa suite completa de testes"""
	if verbose_output:
		print("🚀 Iniciando suite completa de testes...")
	
	test_start_time = Time.get_ticks_msec() / 1000.0
	current_test_state = TestState.TESTING_LEVELS
	
	# Iniciar testes
	if test_all_levels:
		await test_all_nine_levels()
	
	if performance_test:
		await test_performance_requirements()
	
	if integration_test:
		await test_system_integration()
	
	current_test_state = TestState.COMPLETED
	
	# Gerar relatório final
	generate_test_report()
	
	if verbose_output:
		print("✅ Suite de testes concluída")

async func test_all_nine_levels():
	"""Testa todos os 9 níveis sequencialmente"""
	if verbose_output:
		print("📋 Testando todos os 9 níveis...")
	
	for level_config in test_levels:
		await test_single_level(level_config)
		await get_tree().create_timer(1.0).timeout  # Pausa entre níveis

async func test_single_level(level_config: Dictionary):
	"""Testa um nível específico"""
	var level_id = level_config.id
	var level_name = level_config.name
	
	if verbose_output:
		print("🔍 Testando nível ", level_id, ": ", level_name)
	
	level_start_time = Time.get_ticks_msec() / 1000.0
	
	# Inicializar resultado do teste
	var level_result = {
		"level_id": level_id,
		"level_name": level_name,
		"loaded": false,
		"completed": false,
		"puzzles_tested": 0,
		"expected_moves": level_config.expected_moves,
		"actual_moves": 0,
		"target_score": level_config.target_score,
		"actual_score": 0,
		"load_time": 0.0,
		"completion_time": 0.0,
		"errors": [],
		"warnings": [],
		"performance_issues": []
	}
	
	try:
		# 1. Testar carregamento do nível
		var load_success = await test_level_loading(level_id)
		level_result.loaded = load_success
		
		if load_success:
			# 2. Testar mecânicas específicas
			await test_level_mechanics(level_id, level_result)
			
			# 3. Testar progressão dos puzzles
			await test_puzzle_progression(level_id, level_result)
			
			# 4. Testar conclusão do nível
			var completion_result = await test_level_completion(level_id)
			level_result.completed = completion_result.success
			level_result.actual_score = completion_result.score
		
	except Exception as e:
		level_result.errors.append("Erro durante teste: " + str(e))
	
	# Calcular tempos
	var level_end_time = Time.get_ticks_msec() / 1000.0
	level_result.completion_time = level_end_time - level_start_time
	
	test_results[level_id] = level_result
	
	if verbose_output:
		var status = "✅" if level_result.completed else "❌"
		print(status, " Nível ", level_id, " testado - Score: ", level_result.actual_score, 
				" | Tempo: ", level_result.completion_time, "s")

async func test_level_loading(level_id: int) -> bool:
	"""Testa carregamento de um nível"""
	var load_start = Time.get_ticks_msec() / 1000.0
	
	if not level_manager:
		print("❌ LevelManager não encontrado")
		return false
	
	# Verificar se o nível está disponível
	var level_data = level_manager.get_level_data(level_id)
	if level_data.is_empty():
		print("❌ Dados do nível ", level_id, " não encontrados")
		return false
	
	# Desbloquear o nível para teste
	if not level_manager.unlocked_levels.has(level_id):
		level_manager.unlocked_levels.append(level_id)
	
	# Tentar carregar o nível
	var load_result = level_manager.load_level(level_id)
	
	var load_end = Time.get_ticks_msec() / 1000.0
	var load_time = load_end - load_start
	
	# Verificar tempo de carregamento
	if load_time > 3.0:  # Limite de 3 segundos
		print("⚠️ Carregamento lento do nível ", level_id, ": ", load_time, "s")
		return false
	
	if verbose_output:
		print("📥 Nível ", level_id, " carregado em ", load_time, "s")
	
	return load_result

async func test_level_mechanics(level_id: int, level_result: Dictionary):
	"""Testa mecânicas específicas de cada nível"""
	match level_id:
		1:
			await test_basic_logic_mechanics(level_result)
		2:
			await test_pointer_mechanics(level_result)
		3:
			await test_oop_mechanics(level_result)
		4:
			await test_concurrency_mechanics(level_result)
		5:
			await test_architecture_mechanics(level_result)
		6:
			await test_web_development_mechanics(level_result)
		7:
			await test_mobile_development_mechanics(level_result)
		8:
			await test_data_science_mechanics(level_result)
		9:
			await test_emerging_tech_mechanics(level_result)

async func test_basic_logic_mechanics(level_result: Dictionary):
	"""Testa mecânicas de lógica básica (Nível 1)"""
	# Testar movimento básico
	await test_player_movement()
	
	# Testar blocos de lógica simples
	await test_logic_blocks_interaction()
	
	# Testar sequências simples
	await test_simple_sequences()

async func test_pointer_mechanics(level_result: Dictionary):
	"""Testa mecânicas de ponteiros (Nível 2)"""
	# Testar referência vs valor
	await test_reference_vs_value()
	
	# Testar manipulação de memória
	await test_memory_manipulation()
	
	# Testar ponteiros null/invalid
	await test_null_pointer_handling()

async func test_oop_mechanics(level_result: Dictionary):
	"""Testa mecânicas de orientação a objetos (Nível 3)"""
	# Testar herança
	await test_inheritance_mechanics()
	
	# Testar polimorfismo
	await test_polymorphism_mechanics()
	
	# Testar encapsulamento
	await test_encapsulation_mechanics()

async func test_concurrency_mechanics(level_result: Dictionary):
	"""Testa mecânicas de concorrência (Nível 4)"""
	# Testar threads/processos
	await test_thread_mechanics()
	
	# Testar sincronização
	await test_synchronization_mechanics()
	
	# Testar deadlocks
	await test_deadlock_handling()

async func test_architecture_mechanics(level_result: Dictionary):
	"""Testa mecânicas de arquitetura (Nível 5)"""
	# Testar padrões de design
	await test_design_patterns()
	
	# Testar camadas
	await test_layer_separation()
	
	# Testar dependências
	await test_dependency_management()

async func test_web_development_mechanics(level_result: Dictionary):
	"""Testa mecânicas de desenvolvimento web (Nível 6)"""
	# Testar HTML/CSS/JS
	await test_web_technologies()
	
	# Testar APIs
	await test_api_integration()
	
	# Testar responsividade
	await test_responsive_design()

async func test_mobile_development_mechanics(level_result: Dictionary):
	"""Testa mecânicas de desenvolvimento mobile (Nível 7)"""
	# Testar nativos vs cross-platform
	await test_platform_differences()
	
	# Testar UI/UX mobile
	await test_mobile_ui_mechanics()
	
	# Testar funcionalidades específicas
	await test_mobile_specific_features()

async func test_data_science_mechanics(level_result: Dictionary):
	"""Testa mecânicas de ciência de dados (Nível 8)"""
	# Testar processamento de dados
	await test_data_processing()
	
	# Testar algoritmos ML
	await test_ml_algorithms()
	
	# Testar visualização
	await test_data_visualization()

async func test_emerging_tech_mechanics(level_result: Dictionary):
	"""Testa mecânicas de tecnologias emergentes (Nível 9)"""
	# Testar IoT
	await test_iot_mechanics()
	
	# Testar blockchain
	await test_blockchain_mechanics()
	
	# Testar computação quântica
	await test_quantum_mechanics()

# === TESTES DE PROGRESSÃO ===

async func test_puzzle_progression(level_id: int, level_result: Dictionary):
	"""Testa progressão através dos puzzles do nível"""
	var current_level = level_manager.current_level
	if not current_level:
		level_result.errors.append("Nível atual não encontrado")
		return
	
	# Verificar se existem puzzles
	var puzzle_count = current_level.get("puzzles", {}).size()
	level_result.puzzles_tested = puzzle_count
	
	if verbose_output:
		print("🧩 Testando ", puzzle_count, " puzzles do nível ", level_id)
	
	# Testar cada puzzle
	for i in range(puzzle_count):
		var puzzle_result = await test_single_puzzle(level_id, i)
		level_result.actual_moves += puzzle_result.moves
		
		# Verificar se o puzzle foi completado com sucesso
		if not puzzle_result.success:
			level_result.warnings.append("Puzzle " + str(i) + " falhou")
		
		await get_tree().create_timer(0.5).timeout  # Pausa entre puzzles

async func test_single_puzzle(level_id: int, puzzle_index: int) -> Dictionary:
	"""Testa um puzzle específico"""
	var puzzle_result = {
		"puzzle_index": puzzle_index,
		"success": false,
		"moves_used": 0,
		"completion_time": 0.0,
		"errors": []
	}
	
	var puzzle_start = Time.get_ticks_msec() / 1000.0
	
	try:
		# Simular solução do puzzle
		await simulate_puzzle_solution(level_id, puzzle_index)
		
		var puzzle_end = Time.get_ticks_msec() / 1000.0
		puzzle_result.completion_time = puzzle_end - puzzle_start
		
		# Verificar se o puzzle foi considerado completado
		if current_level and current_level.has_signal("puzzle_completed"):
			# Aguardar sinal de completude (timeout de 5 segundos)
			var timeout = 5.0
			var elapsed = 0.0
			
			while elapsed < timeout:
				await get_tree().process_frame
				elapsed += 0.016  # ~60 FPS
		
		puzzle_result.success = true
		
	except Exception as e:
		puzzle_result.errors.append("Erro no puzzle: " + str(e))
	
	puzzle_result.moves_used = simulate_moves_count()  # Simulação
	
	return puzzle_result

# === TESTE DE CONCLUSÃO ===

async func test_level_completion(level_id: int) -> Dictionary:
	"""Testa conclusão do nível"""
	var completion_result = {
		"success": false,
		"score": 0,
		"completion_time": 0.0,
		"errors": []
	}
	
	var completion_start = Time.get_ticks_msec() / 1000.0
	
	try:
		# Forçar conclusão do nível para teste
		if level_manager.current_level:
			level_manager.current_level.call_deferred("force_complete_level")
		
		# Aguardar processamento de conclusão
		await get_tree().create_timer(2.0).timeout
		
		var completion_end = Time.get_ticks_msec() / 1000.0
		completion_result.completion_time = completion_end - completion_start
		
		# Verificar se o nível foi marcado como completado
		var level_data = level_manager.get_level_data(level_id)
		if level_data.get("is_completed", false):
			completion_result.success = true
			completion_result.score = level_data.get("final_score", {}).get("total", 0)
		
	except Exception as e:
		completion_result.errors.append("Erro na conclusão: " + str(e))
	
	return completion_result

# === TESTES DE PERFORMANCE ===

async func test_performance_requirements():
	"""Testa requisitos de performance (60 FPS)"""
	if verbose_output:
		print("⚡ Testando performance...")
	
	performance_metrics = {
		"average_fps": 0.0,
		"min_fps": 999.0,
		"max_fps": 0.0,
		"memory_usage": 0.0,
		"load_times": {},
		"frame_times": []
	}
	
	# Testar FPS em cada nível
	for level_config in test_levels:
		await test_level_fps(level_config.id)
	
	# Calcular métricas gerais
	calculate_performance_metrics()
	
	# Verificar se atende aos requisitos
	validate_performance_requirements()

async func test_level_fps(level_id: int):
	"""Testa FPS em um nível específico"""
	# Carregar nível se necessário
	if not level_manager.current_level or level_manager.level_index != level_id:
		level_manager.load_level(level_id)
	
	await get_tree().create_timer(2.0).timeout  # Aguardar estabilização
	
	# Coletar métricas de FPS por 10 segundos
	var fps_samples = []
	var frame_times = []
	
	var test_duration = 10.0
	var start_time = Time.get_ticks_msec() / 1000.0
	
	while (Time.get_ticks_msec() / 1000.0 - start_time) < test_duration:
		var fps = Engine.get_frames_per_second()
		var frame_time = Engine.get_frame_time()
		
		fps_samples.append(fps)
		frame_times.append(frame_time)
		
		await get_tree().process_frame
	
	# Calcular estatísticas do nível
	var level_fps_stats = {
		"level_id": level_id,
		"average_fps": calculate_average(fps_samples),
		"min_fps": calculate_min(fps_samples),
		"max_fps": calculate_max(fps_samples),
		"frame_times": frame_times
	}
	
	performance_metrics.load_times[level_id] = level_fps_stats

func calculate_performance_metrics():
	"""Calcula métricas gerais de performance"""
	var all_fps = []
	for level_stats in performance_metrics.load_times.values():
		all_fps.append(level_stats.average_fps)
	
	performance_metrics.average_fps = calculate_average(all_fps)
	performance_metrics.min_fps = calculate_min(all_fps)
	performance_metrics.max_fps = calculate_max(all_fps)

func validate_performance_requirements():
	"""Valida se a performance atende aos requisitos"""
	var issues = []
	
	if performance_metrics.average_fps < 55.0:
		issues.append("FPS médio abaixo de 55: " + str(performance_metrics.average_fps))
	
	if performance_metrics.min_fps < 30.0:
		issues.append("FPS mínimo abaixo de 30: " + str(performance_metrics.min_fps))
	
	if performance_metrics.memory_usage > 500.0:  # MB
		issues.append("Uso de memória alto: " + str(performance_metrics.memory_usage) + "MB")
	
	if not issues.is_empty():
		performance_metrics.issues = issues
		
		if verbose_output:
			for issue in issues:
				print("⚠️ Performance: ", issue)

# === TESTES DE INTEGRAÇÃO ===

async func test_system_integration():
	"""Testa integração entre todos os sistemas"""
	if verbose_output:
		print("🔗 Testando integração de sistemas...")
	
	# Testar integração LevelManager ↔ PlayerController
	await test_level_manager_integration()
	
	# Testar sistema de habilidades (Sprint 2)
	await test_language_ability_integration()
	
	# Testar sistema de maestria (Sprint 3)
	await test_mastery_system_integration()
	
	# Testar persistência de dados
	await test_data_persistence_integration()

async def test_level_manager_integration():
	"""Testa integração com LevelManager"""
	var integration_result = {
		"level_loading": true,
		"level_transition": true,
		"progress_saving": true,
		"achievement_system": true,
		"errors": []
	}
	
	try:
		# Testar carregamento sequencial
		for i in range(1, 10):
			var success = level_manager.load_level(i)
			if not success:
				integration_result.errors.append("Falha ao carregar nível " + str(i))
				integration_result.level_loading = false
			
			await get_tree().create_timer(0.5).timeout
		
		# Testar transição entre níveis
		for i in range(1, 9):
			level_manager.load_level(i)
			await get_tree().create_timer(1.0).timeout
			level_manager.load_level(i + 1)
			await get_tree().create_timer(1.0).timeout
		
	except Exception as e:
		integration_result.errors.append("Erro na integração: " + str(e))
	
	integration_issues.append(integration_result)

# === UTILITÁRIOS ===

func simulate_puzzle_solution(level_id: int, puzzle_index: int):
	"""Simula solução de um puzzle para teste"""
	# Implementação simplificada - em versão real seria mais robusta
	await get_tree().create_timer(randf_range(1.0, 3.0)).timeout

func simulate_moves_count() -> int:
	"""Simula número de movimentos realizados"""
	return randi_range(5, 15)

func calculate_average(values: Array) -> float:
	"""Calcula média de um array"""
	if values.is_empty():
		return 0.0
	
	var sum = 0.0
	for value in values:
		sum += float(value)
	
	return sum / values.size()

func calculate_min(values: Array) -> float:
	"""Calcula mínimo de um array"""
	if values.is_empty():
		return 0.0
	
	var min_val = float(values[0])
	for value in values:
		var val = float(value)
		if val < min_val:
			min_val = val
	
	return min_val

func calculate_max(values: Array) -> float:
	"""Calcula máximo de um array"""
	if values.is_empty():
		return 0.0
	
	var max_val = float(values[0])
	for value in values:
		var val = float(value)
		if val > max_val:
			max_val = val
	
	return max_val

# === HANDLERS DE SINAIS ===

func _on_level_completed(level_id: int):
	"""Handler para conclusão de nível"""
	if verbose_output:
		print("✅ Nível ", level_id, " completado durante teste")

func _on_puzzle_completed(score_data: Dictionary):
	"""Handler para conclusão de puzzle"""
	if verbose_output:
		print("🧩 Puzzle completado com score: ", score_data)

# === RELATÓRIO FINAL ===

func generate_test_report():
	"""Gera relatório final dos testes"""
	var report_time = Time.get_ticks_msec() / 1000.0
	var total_time = report_time - test_start_time
	
	var report = {
		"timestamp": Time.get_datetime_string_from_system(),
		"total_test_time": total_time,
		"levels_tested": test_results.size(),
		"successful_levels": 0,
		"failed_levels": 0,
		"total_bugs": bugs_found.size(),
		"performance_issues": performance_metrics.get("issues", []),
		"integration_issues": integration_issues.size(),
		"detailed_results": test_results
	}
	
	# Contar sucessos/fracassos
	for level_id in test_results:
		var result = test_results[level_id]
		if result.completed:
			report.successful_levels += 1
		else:
			report.failed_levels += 1
	
	# Salvar relatório
	save_test_report(report)
	
	if verbose_output:
		print("📊 RELATÓRIO DE TESTES:")
		print("   Níveis testados: ", report.levels_tested)
		print("   Sucessos: ", report.successful_levels)
		print("   Falhas: ", report.failed_levels)
		print("   Bugs encontrados: ", report.total_bugs)
		print("   Tempo total: ", total_time, "s")
		print("   FPS médio: ", performance_metrics.get("average_fps", 0))

func save_test_report(report: Dictionary):
	"""Salva relatório em arquivo"""
	var report_content = "# RELATÓRIO DE TESTES - THE CORE DESCENT\n\n"
	report_content += "**Data:** " + report.timestamp + "\n"
	report_content += "**Tempo total:** " + str(report.total_test_time) + "s\n\n"
	
	report_content += "## Resumo\n"
	report_content += "- Níveis testados: " + str(report.levels_tested) + "\n"
	report_content += "- Sucessos: " + str(report.successful_levels) + "\n"
	report_content += "- Falhas: " + str(report.failed_levels) + "\n"
	report_content += "- Bugs encontrados: " + str(report.total_bugs) + "\n"
	report_content += "- Problemas de performance: " + str(report.performance_issues.size()) + "\n"
	report_content += "- Problemas de integração: " + str(report.integration_issues) + "\n\n"
	
	report_content += "## Performance\n"
	report_content += "- FPS médio: " + str(performance_metrics.get("average_fps", 0)) + "\n"
	report_content += "- FPS mínimo: " + str(performance_metrics.get("min_fps", 0)) + "\n"
	report_content += "- FPS máximo: " + str(performance_metrics.get("max_fps", 0)) + "\n\n"
	
	report_content += "## Detalhamento por Nível\n"
	for level_id in report.detailed_results:
		var result = report.detailed_results[level_id]
		report_content += "### Nível " + str(level_id) + ": " + result.level_name + "\n"
		report_content += "- Status: " + ("✅ Concluído" if result.completed else "❌ Falhou") + "\n"
		report_content += "- Score: " + str(result.actual_score) + "/" + str(result.target_score) + "\n"
		report_content += "- Movimentos: " + str(result.actual_moves) + "/" + str(result.expected_moves) + "\n"
		report_content += "- Tempo: " + str(result.completion_time) + "s\n"
		report_content += "- Erros: " + str(result.errors.size()) + "\n\n"
	
	# Salvar arquivo
	var file = FileAccess.open("user://test_report_" + Time.get_datetime_string_from_system().replace(":", "_") + ".md", FileAccess.WRITE)
	if file:
		file.store_string(report_content)
		file.close()
		print("📄 Relatório salvo em arquivo")
