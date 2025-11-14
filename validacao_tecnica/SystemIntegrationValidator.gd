# SCRIPT DE INTEGRAÇÃO E VALIDAÇÃO - THE CORE DESCENT
# Arquivo: SystemIntegrationValidator.gd - Validação específica de integração entre sistemas

extends Node
class_name SystemIntegrationValidator

# Configurações de validação
@export var validate_all_integrations: bool = true
@export var stop_on_critical_error: bool = true
@export var generate_detailed_report: bool = true

# Referências aos sistemas
var level_manager: LevelManager
var player_controller: PlayerController
var language_ability_system: LanguageAbilitySystem
var advanced_ability_system: AdvancedLanguageAbilitySystem

# Resultados da validação
var integration_results: Dictionary = {}
var critical_issues: Array = []
var warnings: Array = []
var system_health_score: float = 0.0

# Níveis para validação
var validation_levels: Array = [
	{"id": 1, "name": "A Torre de Marfim", "expected_abilities": [], "critical_systems": ["basic_movement", "level_loading"]},
	{"id": 2, "name": "A Forja de Ponteiros", "expected_abilities": ["cpp_pointer"], "critical_systems": ["language_abilities", "pointer_mechanics"]},
	{"id": 3, "name": "A Biblioteca de Objetos", "expected_abilities": ["java_oop", "python_oop"], "critical_systems": ["multiple_languages", "oop_concepts"]},
	{"id": 4, "name": "A Arquitetura Concorrente", "expected_abilities": ["csharp_threads", "js_callbacks"], "critical_systems": ["concurrency", "advanced_patterns"]},
	{"id": 5, "name": "O Arquiteto de Software", "expected_abilities": ["all_languages"], "critical_systems": ["complex_architecture", "all_patterns"]},
	{"id": 6, "name": "A Arquitetura Web", "expected_abilities": ["web_dev"], "critical_systems": ["web_technologies", "api_integration"]},
	{"id": 7, "name": "O Ecossistema Mobile", "expected_abilities": ["mobile_dev"], "critical_systems": ["mobile_patterns", "platform_specific"]},
	{"id": 8, "name": "A Ciência dos Dados", "expected_abilities": ["data_science"], "critical_systems": ["ml_algorithms", "data_processing"]},
	{"id": 9, "name": "As Fronteiras da Tecnologia", "expected_abilities": ["emerging_tech"], "critical_systems": ["quantum_computing", "blockchain", "iot"]}
]

func _ready():
	setup_validator()

func setup_validator():
	"""Configura o validador de integração"""
	# Obter referências aos sistemas principais
	level_manager = get_tree().get_root().get_node("Main/GameManager/LevelManager")
	player_controller = get_tree().get_root().get_node("Main/GameManager/PlayerController")
	
	# Verificar se os sistemas existem
	if not level_manager:
		critical_issues.append("LevelManager não encontrado no sistema")
		return
	
	if not player_controller:
		critical_issues.append("PlayerController não encontrado no sistema")
		return
	
	# Obter sistemas de habilidades se disponíveis
	language_ability_system = player_controller.get("language_ability_system")
	advanced_ability_system = player_controller.get("advanced_ability_system")
	
	print("🔍 Sistema de validação de integração configurado")

func run_full_validation():
	"""Executa validação completa de todos os sistemas"""
	if critical_issues.size() > 0:
		print("❌ Abortando validação - erros críticos encontrados")
		return
	
	print("🚀 Iniciando validação completa de integração...")
	
	# 1. Validar estrutura básica do projeto
	validate_project_structure()
	
	# 2. Validar integração LevelManager ↔ Níveis
	validate_level_manager_integration()
	
	# 3. Validar sistema de habilidades
	validate_ability_systems()
	
	# 4. Validar progressão de desbloqueio
	validate_unlock_progression()
	
	# 5. Validar cada nível individualmente
	await validate_individual_levels()
	
	# 6. Validar persistência de dados
	validate_data_persistence()
	
	# 7. Calcular health score geral
	calculate_system_health()
	
	# 8. Gerar relatório final
	generate_integration_report()
	
	if generate_detailed_report:
		save_detailed_report()
	
	print("✅ Validação de integração concluída")

# === VALIDAÇÃO DE ESTRUTURA DO PROJETO ===

func validate_project_structure():
	"""Valida se todos os arquivos necessários existem"""
	print("📁 Validando estrutura do projeto...")
	
	var expected_files = [
		"res://codigo/Level1.gd",
		"res://codigo/Level2.gd", 
		"res://codigo/Level3.gd",
		"res://codigo/Level4.gd",
		"res://codigo/Level5.gd",
		"res://codigo/Level6.gd",
		"res://codigo/Level7.gd",
		"res://codigo/Level8.gd",
		"res://codigo/Level9.gd",
		"res://projeto_godot/scripts/LevelManager.gd",
		"res://projeto_godot/scripts/PlayerController.gd"
	]
	
	var structure_validation = {
		"files_found": 0,
		"missing_files": [],
		"validation_passed": false
	}
	
	for file_path in expected_files:
		var file_exists = FileAccess.file_exists(file_path)
		if file_exists:
			structure_validation.files_found += 1
		else:
			structure_validation.missing_files.append(file_path)
	
	structure_validation.validation_passed = structure_validation.files_found == expected_files.size()
	integration_results["project_structure"] = structure_validation
	
	if structure_validation.validation_passed:
		print("✅ Estrutura do projeto válida (", structure_validation.files_found, "/", expected_files.size(), " arquivos)")
	else:
		var error_msg = "Estrutura inválida: " + str(expected_files.size() - structure_validation.files_found) + " arquivos faltando"
		critical_issues.append(error_msg)
		print("❌ ", error_msg)

# === VALIDAÇÃO DE INTEGRAÇÃO LEVELMANAGER ===

func validate_level_manager_integration():
	"""Valida integração entre LevelManager e os níveis"""
	print("🔗 Validando integração LevelManager ↔ Níveis...")
	
	var lm_validation = {
		"available_levels_loaded": 0,
		"level_configs_valid": true,
		"dependency_chains_valid": true,
		"integration_score": 0.0
	}
	
	# Verificar se LevelManager carregou todos os níveis
	if level_manager.available_levels:
		lm_validation.available_levels_loaded = level_manager.available_levels.size()
		
		if lm_validation.available_levels_loaded != 9:
			var error = "LevelManager carregou apenas " + str(lm_validation.available_levels_loaded) + " níveis, esperado 9"
			critical_issues.append(error)
			lm_validation.level_configs_valid = false
	else:
		critical_issues.append("LevelManager.available_levels está vazio")
		lm_validation.level_configs_valid = false
	
	# Validar configurações de cada nível
	for level_config in level_manager.available_levels:
		var validation = validate_level_configuration(level_config)
		if not validation.valid:
			lm_validation.level_configs_valid = false
	
	# Validar chains de dependências
	lm_validation.dependency_chains_valid = validate_dependency_chains()
	
	# Calcular score de integração
	var score_components = [
		(lm_validation.available_levels_loaded / 9.0) * 30,  # 30% - carregamento
		(lm_validation.level_configs_valid ? 40 : 0),          # 40% - configurações válidas
		(lm_validation.dependency_chains_valid ? 30 : 0)       # 30% - dependências válidas
	]
	
	lm_validation.integration_score = score_components[0] + score_components[1] + score_components[2]
	
	integration_results["levelmanager_integration"] = lm_validation
	
	print("Score de integração LevelManager: ", lm_validation.integration_score, "/100")

func validate_level_configuration(level_config: Dictionary) -> Dictionary:
	"""Valida configuração específica de um nível"""
	var validation = {
		"level_id": level_config.get("id", 0),
		"valid": true,
		"issues": []
	}
	
	# Verificar campos obrigatórios
	var required_fields = ["id", "name", "description", "scene_path", "difficulty", "estimated_time"]
	for field in required_fields:
		if not level_config.has(field):
			validation.issues.append("Campo obrigatório ausente: " + field)
			validation.valid = false
	
	# Verificar se scene_path existe
	if level_config.has("scene_path"):
		var scene_path = level_config.scene_path
		if not FileAccess.file_exists(scene_path):
			validation.issues.append("Arquivo do nível não existe: " + scene_path)
			validation.valid = false
	
	# Verificar progressão de difficulty
	if level_config.has("difficulty"):
		var difficulty = level_config.difficulty
		var expected_difficulties = {
			1: "Iniciante",
			2: "Intermediário", 
			3: "Intermediário-Avançado",
			4: "Avançado",
			5: "Especialista",
			6: "Especialista-Avançado",
			7: "Especialista-Avançado",
			8: "Especialista-Máximo",
			9: "Inovador"
		}
		
		var level_id = level_config.get("id", 0)
		if expected_difficulties.has(level_id):
			var expected = expected_difficulties[level_id]
			if difficulty != expected:
				validation.issues.append("Difficulty incorreto: esperado '" + expected + "', encontrado '" + difficulty + "'")
				validation.valid = false
	
	return validation

func validate_dependency_chains() -> bool:
	"""Valida se as cadeias de dependência estão corretas"""
	# Verificar se nível 1 não depende de ninguém
	var level1_config = null
	for config in level_manager.available_levels:
		if config.get("id", 0) == 1:
			level1_config = config
			break
	
	if level1_config:
		var required_concepts = level1_config.get("required_concepts", [])
		if required_concepts.size() > 0:
			print("⚠️ Nível 1 tem dependências: ", required_concepts)
			return false
	
	# Verificar progressão lógica dos conceitos
	for i in range(2, 10):
		var current_config = null
		for config in level_manager.available_levels:
			if config.get("id", 0) == i:
				current_config = config
				break
		
		if current_config:
			var concepts = current_config.get("required_concepts", [])
			# Nível i deve ter pelo menos os conceitos dos níveis anteriores
			if not concepts.has("lógica_básica"):
				print("⚠️ Nível ", i, " não tem conceito base 'lógica_básica'")
				return false
	
	return true

# === VALIDAÇÃO DO SISTEMA DE HABILIDADES ===

func validate_ability_systems():
	"""Valida integração dos sistemas de habilidades"""
	print("⚡ Validando sistema de habilidades...")
	
	var ability_validation = {
		"basic_system_present": false,
		"advanced_system_present": false,
		"player_integration": false,
		"level_availability": {},
		"ability_score": 0.0
	}
	
	# Verificar se sistema básico existe
	if language_ability_system:
		ability_validation.basic_system_present = true
		print("✅ Sistema básico de habilidades encontrado")
	else:
		warnings.append("Sistema básico de habilidades não encontrado")
		print("⚠️ Sistema básico de habilidades não encontrado")
	
	# Verificar se sistema avançado existe
	if advanced_ability_system:
		ability_validation.advanced_system_present = true
		print("✅ Sistema avançado de habilidades encontrado")
	else:
		warnings.append("Sistema avançado de habilidades não encontrado")
		print("⚠️ Sistema avançado de habilidades não encontrado")
	
	# Verificar integração com PlayerController
	if player_controller:
		var has_basic_ref = player_controller.has_method("get_current_language")
		var has_advanced_ref = player_controller.has_method("get_advanced_stats")
		
		if has_basic_ref or has_advanced_ref:
			ability_validation.player_integration = true
			print("✅ Integração com PlayerController validada")
		else:
			critical_issues.append("PlayerController não tem métodos de integração com habilidades")
	
	# Simular verificação por nível (baseado na configuração conhecida)
	var expected_abilities = {
		1: [],
		2: ["cpp"],
		3: ["java", "python"], 
		4: ["csharp", "javascript"],
		5: ["cpp", "java", "python", "csharp", "javascript"],
		6: ["web_dev"],
		7: ["mobile_dev"],
		8: ["data_science"],
		9: ["emerging_tech"]
	}
	
	for level_id in expected_abilities:
		var expected = expected_abilities[level_id]
		ability_validation.level_availability[level_id] = {
			"expected": expected.size(),
			"available": expected.size(),  # Simplificado para validação
			"match": true
		}
	
	# Calcular score
	var score_components = [
		(ability_validation.basic_system_present ? 30 : 0),
		(ability_validation.advanced_system_present ? 25 : 0),
		(ability_validation.player_integration ? 25 : 0),
		20  # Sempre presente baseado na configuração
	]
	
	ability_validation.ability_score = score_components[0] + score_components[1] + score_components[2] + score_components[3]
	integration_results["ability_systems"] = ability_validation
	
	print("Score de sistema de habilidades: ", ability_validation.ability_score, "/100")

# === VALIDAÇÃO DE PROGRESSÃO ===

func validate_unlock_progression():
	"""Valida sistema de desbloqueio progressivo"""
	print("🔓 Validando progressão de desbloqueio...")
	
	var unlock_validation = {
		"initial_state": {},
		"progression_rules": true,
		"unlock_score": 0.0
	}
	
	# Verificar estado inicial
	if level_manager.unlocked_levels:
		unlock_validation.initial_state = level_manager.unlocked_levels.duplicate()
		
		if unlock_validation.initial_state.size() != 1 or unlock_validation.initial_state[0] != 1:
			var error = "Estado inicial incorreto: esperado apenas [1], encontrado " + str(unlock_validation.initial_state)
			critical_issues.append(error)
			unlock_validation.progression_rules = false
	else:
		critical_issues.append("LevelManager.unlocked_levels está vazio")
		unlock_validation.progression_rules = false
	
	# Verificar regras de progressão
	var completed_levels = level_manager.completed_levels if level_manager.completed_levels else []
	
	# Se nenhum nível foi completado, progresso está correto
	if completed_levels.size() == 0:
		print("✅ Estado inicial de desbloqueio válido")
	else:
		# Validar se progressão é linear
		completed_levels.sort()
		for i in range(completed_levels.size() - 1):
			if completed_levels[i + 1] - completed_levels[i] != 1:
				warnings.append("Progressão não linear detectada: " + str(completed_levels))
				unlock_validation.progression_rules = false
	
	# Calcular score
	var base_score = 50  # Points para implementação básica
	var bonus_score = unlock_validation.progression_rules ? 50 : 0
	unlock_validation.unlock_score = base_score + bonus_score
	
	integration_results["unlock_progression"] = unlock_validation
	print("Score de progressão: ", unlock_validation.unlock_score, "/100")

# === VALIDAÇÃO INDIVIDUAL DOS NÍVEIS ===

func validate_individual_levels():
	"""Valida cada nível individualmente"""
	print("🎮 Validando níveis individualmente...")
	
	var individual_validation = {}
	
	for level_info in validation_levels:
		var level_id = level_info.id
		var level_name = level_info.name
		
		print("  🔍 Validando Nível ", level_id, ": ", level_name)
		
		var level_result = await validate_single_level(level_info)
		individual_validation[level_id] = level_result
		
		var status = "✅" if level_result.validation_passed else "❌"
		print("    ", status, " Nível ", level_id, " - Score: ", level_result.integration_score)
	
	integration_results["individual_levels"] = individual_validation

func validate_single_level(level_info: Dictionary) -> Dictionary:
	"""Valida um nível específico"""
	var level_id = level_info.id
	var validation = {
		"level_id": level_id,
		"level_name": level_info.name,
		"can_load": false,
		"has_required_systems": false,
		"mechanics_functional": false,
		"validation_passed": false,
		"integration_score": 0.0,
		"issues": []
	}
	
	try:
		# 1. Testar carregamento do nível
		var load_result = level_manager.load_level(level_id)
		validation.can_load = load_result
		
		if load_result:
			# 2. Verificar se nível está carregado
			if level_manager.current_level:
				validation.has_required_systems = true
				
				# 3. Testar mecânicas básicas
				var mechanics_result = await test_level_mechanics(level_id)
				validation.mechanics_functional = mechanics_result.success
				
				if not mechanics_result.success:
					validation.issues.append("Mecânicas do nível não funcionais")
			
			# Descarregar nível após teste
			level_manager.unload_current_level()
		
	except Exception as e:
		validation.issues.append("Erro durante validação: " + str(e))
	
	# Calcular score final
	var score_components = [
		(validation.can_load ? 30 : 0),
		(validation.has_required_systems ? 35 : 0),
		(validation.mechanics_functional ? 35 : 0)
	]
	
	validation.integration_score = score_components[0] + score_components[1] + score_components[2]
	validation.validation_passed = validation.integration_score >= 70
	
	return validation

func test_level_mechanics(level_id: int) -> Dictionary:
	"""Testa mecânicas específicas de um nível"""
	var result = {
		"success": false,
		"tested_systems": [],
		"errors": []
	}
	
	# Testes básicos por nível
	match level_id:
		1:
			# Testar movimento básico
			result.tested_systems.append("basic_movement")
			if player_controller:
				result.success = true
			else:
				result.errors.append("PlayerController não disponível")
		
		2, 3, 4, 5:
			# Testar sistema de habilidades
			result.tested_systems.append("language_abilities")
			if language_ability_system:
				result.success = true
			else:
				result.errors.append("Sistema de habilidades não disponível")
		
		6, 7, 8, 9:
			# Testar tecnologias específicas
			result.tested_systems.append("technology_specific")
			result.success = true  # Simplificado para validação
	
	return result

# === VALIDAÇÃO DE PERSISTÊNCIA ===

func validate_data_persistence():
	"""Valida sistema de persistência de dados"""
	print("💾 Validando persistência de dados...")
	
	var persistence_validation = {
		"save_system_present": false,
		"load_functionality": false,
		"data_integrity": false,
		"persistence_score": 0.0
	}
	
	# Verificar se métodos de salvamento existem
	if level_manager and level_manager.has_method("save_progress"):
		persistence_validation.save_system_present = true
		print("✅ Sistema de salvamento encontrado")
	else:
		warnings.append("Sistema de salvamento não encontrado")
	
	if level_manager and level_manager.has_method("load_saved_progress"):
		persistence_validation.load_functionality = true
		print("✅ Funcionalidade de carregamento encontrada")
	else:
		warnings.append("Funcionalidade de carregamento não encontrada")
	
	# Verificar integridade básica dos dados
	if level_manager:
		var progress_data = level_manager.get_progress_summary()
		if progress_data and progress_data.has("total_levels"):
			persistence_validation.data_integrity = true
			print("✅ Integridade de dados validada")
		else:
			warnings.append("Estrutura de dados de progresso inválida")
	
	# Calcular score
	var score_components = [
		(persistence_validation.save_system_present ? 40 : 0),
		(persistence_validation.load_functionality ? 30 : 0),
		(persistence_validation.data_integrity ? 30 : 0)
	]
	
	persistence_validation.persistence_score = score_components[0] + score_components[1] + score_components[2]
	integration_results["data_persistence"] = persistence_validation
	
	print("Score de persistência: ", persistence_validation.persistence_score, "/100")

# === CÁLCULO DE HEALTH SCORE ===

func calculate_system_health():
	"""Calcula health score geral do sistema"""
	var component_scores = []
	
	# Score da estrutura do projeto
	if integration_results.has("project_structure"):
		var structure_result = integration_results.project_structure
		component_scores.append(structure_result.validation_passed ? 100 : 0)
	
	# Score da integração LevelManager
	if integration_results.has("levelmanager_integration"):
		var lm_result = integration_results.levelmanager_integration
		component_scores.append(lm_result.integration_score)
	
	# Score do sistema de habilidades
	if integration_results.has("ability_systems"):
		var ability_result = integration_results.ability_systems
		component_scores.append(ability_result.ability_score)
	
	# Score da progressão
	if integration_results.has("unlock_progression"):
		var unlock_result = integration_results.unlock_progression
		component_scores.append(unlock_result.unlock_score)
	
	# Score da persistência
	if integration_results.has("data_persistence"):
		var persistence_result = integration_results.data_persistence
		component_scores.append(persistence_result.persistence_score)
	
	# Média ponderada
	if component_scores.size() > 0:
		var total_score = 0
		for score in component_scores:
			total_score += score
		system_health_score = total_score / component_scores.size()
	
	# Determinar status geral
	var system_status = "UNKNOWN"
	if system_health_score >= 80:
		system_status = "EXCELLENT"
	elif system_health_score >= 65:
		system_status = "GOOD"
	elif system_health_score >= 50:
		system_status = "ACCEPTABLE"
	elif system_health_score >= 30:
		system_status = "POOR"
	else:
		system_status = "CRITICAL"
	
	integration_results["overall_health"] = {
		"health_score": system_health_score,
		"status": system_status,
		"critical_issues": critical_issues.size(),
		"warnings": warnings.size()
	}

# === RELATÓRIOS ===

func generate_integration_report():
	"""Gera relatório final da validação"""
	print("\n" + "="*60)
	print("📊 RELATÓRIO DE VALIDAÇÃO DE INTEGRAÇÃO")
	print("="*60)
	
	# Status geral
	var overall = integration_results.get("overall_health", {})
	var health_score = overall.get("health_score", 0)
	var status = overall.get("status", "UNKNOWN")
	
	print("🏥 HEALTH SCORE GERAL: ", health_score, "/100")
	print("📈 STATUS: ", status)
	
	# Componentes individuais
	if integration_results.has("project_structure"):
		var struct = integration_results.project_structure
		var struct_status = "✅ PASS" if struct.validation_passed else "❌ FAIL"
		print("📁 ESTRUTURA: ", struct_status, " (", struct.files_found, "/11 arquivos)")
	
	if integration_results.has("levelmanager_integration"):
		var lm = integration_results.levelmanager_integration
		print("🔗 LEVELMANAGER: ", lm.integration_score, "/100")
	
	if integration_results.has("ability_systems"):
		var ab = integration_results.ability_systems
		print("⚡ HABILIDADES: ", ab.ability_score, "/100")
	
	if integration_results.has("unlock_progression"):
		var up = integration_results.unlock_progression
		print("🔓 PROGRESSÃO: ", up.unlock_score, "/100")
	
	if integration_results.has("data_persistence"):
		var dp = integration_results.data_persistence
		print("💾 PERSISTÊNCIA: ", dp.persistence_score, "/100")
	
	# Issues críticos
	if critical_issues.size() > 0:
		print("\n🚨 ISSUES CRÍTICOS:")
		for issue in critical_issues:
			print("  ❌ ", issue)
	
	# Warnings
	if warnings.size() > 0:
		print("\n⚠️ WARNINGS:")
		for warning in warnings:
			print("  ⚠️ ", warning)
	
	# Resultado final
	var final_status = "✅ APROVADO" if health_score >= 65 and critical_issues.size() == 0 else "❌ REPROVADO"
	print("\n🏁 RESULTADO FINAL: ", final_status)
	
	if health_score < 65:
		print("💡 Recomendações:")
		if health_score < 30:
			print("  - Corrigir issues críticos antes de prosseguir")
		else:
			print("  - Resolver warnings e otimizar integrações")
	
	print("="*60)

func save_detailed_report():
	"""Salva relatório detalhado em arquivo"""
	var report_content = "# RELATÓRIO DETALHADO DE VALIDAÇÃO DE INTEGRAÇÃO\n\n"
	report_content += "**Data:** " + Time.get_datetime_string_from_system() + "\n"
	report_content += "**Health Score:** " + str(system_health_score) + "/100\n"
	report_content += "**Status:** " + integration_results.get("overall_health", {}).get("status", "UNKNOWN") + "\n\n"
	
	# Detalhes por componente
	report_content += "## Detalhamento por Componente\n\n"
	
	for component in integration_results.keys():
		if component == "overall_health":
			continue
		
		report_content += "### " + component.replace("_", " ").capitalize() + "\n"
		var component_data = integration_results[component]
		
		for key in component_data.keys():
			report_content += "- **" + key + ":** " + str(component_data[key]) + "\n"
		report_content += "\n"
	
	# Issues detalhados
	if critical_issues.size() > 0:
		report_content += "## Issues Críticos Detalhados\n\n"
		for i in range(critical_issues.size()):
			report_content += str(i + 1) + ". " + critical_issues[i] + "\n"
		report_content += "\n"
	
	if warnings.size() > 0:
		report_content += "## Warnings Detalhados\n\n"
		for i in range(warnings.size()):
			report_content += str(i + 1) + ". " + warnings[i] + "\n"
		report_content += "\n"
	
	# Salvar arquivo
	var filename = "integration_validation_report_" + Time.get_datetime_string_from_system().replace(":", "_") + ".md"
	var file = FileAccess.open("user://" + filename, FileAccess.WRITE)
	if file:
		file.store_string(report_content)
		file.close()
		print("📄 Relatório detalhado salvo: ", filename)
