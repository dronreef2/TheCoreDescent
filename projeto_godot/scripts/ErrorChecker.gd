extends Node
class_name ErrorChecker

"""
Script para verificação de erros comuns no projeto The Core Descent
Verifica referências quebradas, sintaxe incorreta e configurações inválidas
"""

func check_all_errors() -> Dictionary:
	var results = {
		"total_files_checked": 0,
		"files_with_errors": 0,
		"critical_errors": [],
		"warnings": [],
		"references": {},
		"unresolved_references": [],
		"syntax_errors": [],
		"config_errors": []
	}
	
	# Verificar projeto.godot
	_check_project_config(results)
	
	# Verificar arquivos principais
	_check_main_files(results)
	
	# Verificar sistema MCP
	_check_mcp_system(results)
	
	# Verificar scripts de níveis
	_check_level_scripts(results)
	
	# Verificar referências
	_check_references(results)
	
	return results

func _check_project_config(results: Dictionary) -> void:
	results["total_files_checked"] += 1
	
	var project_file = "/workspace/projeto_godot/project.godot"
	var content = _read_file_content(project_file)
	
	if not content:
		results["critical_errors"].append("Arquivo project.godot não encontrado")
		results["files_with_errors"] += 1
		return
	
	# Verificar versão do Godot
	if "4.5" in content:
		results["references"]["godot_version"] = "4.5 (correto)"
	elif "4.3" in content:
		results["config_errors"].append("project.godot ainda está configurado para Godot 4.3, deve ser 4.5")
	
	# Verificar cena principal
	if 'run/main_scene="res://scenes/Main.tscn"' in content:
		results["references"]["main_scene"] = "scenes/Main.tscn"
	else:
		results["config_errors"].append("Cena principal não configurada corretamente")
	
	# Verificar se Main.tscn existe
	if not _file_exists("/workspace/projeto_godot/scenes/Main.tscn"):
		results["critical_errors"].append("Main.tscn não encontrado em scenes/")
		results["files_with_errors"] += 1

func _check_main_files(results: Dictionary) -> void:
	var main_files = [
		"GameManager.gd",
		"LevelManager.gd", 
		"LanguageAbilitySystem.gd"
	]
	
	for file_name in main_files:
		results["total_files_checked"] += 1
		var file_path = "/workspace/projeto_godot/scripts/" + file_name
		var content = _read_file_content(file_path)
		
		if not content:
			results["critical_errors"].append(f"Arquivo {file_name} não encontrado")
			results["files_with_errors"] += 1
			continue
		
		# Verificar sintaxe básica
		if not content.contains("extends"):
			results["syntax_errors"].append(f"{file_name}: Não tem 'extends' declarado")
		
		if not content.contains("class_name"):
			results["warnings"].append(f"{file_name}: Recomendado declarar 'class_name'")

func _check_mcp_system(results: Dictionary) -> void:
	results["total_files_checked"] += 1
	
	var mcp_files = [
		"addons/plugin.cfg",
		"addons/mcp_server.gd",
		"addons/commands/base_command_processor.gd"
	]
	
	for file_path in mcp_files:
		var full_path = "/workspace/projeto_godot/" + file_path
		if not _file_exists(full_path):
			results["critical_errors"].append(f"Arquivo MCP {file_path} não encontrado")
			results["files_with_errors"] += 1
		else:
			results["references"]["mcp_files"] = results["references"].get("mcp_files", []) + [file_path]
	
	# Verificar comandos MCP
	var commands_dir = "/workspace/projeto_godot/addons/commands"
	var commands_files = [
		"analytics_commands.gd",
		"level_management_commands.gd", 
		"educational_content_commands.gd",
		"testing_commands.gd",
		"version_control_commands.gd"
	]
	
	for cmd_file in commands_files:
		var full_path = commands_dir + "/" + cmd_file
		var content = _read_file_content(full_path)
		if content and "extends MCPBaseCommandProcessor" in content:
			results["references"]["mcp_commands"] = results["references"].get("mcp_commands", []) + [cmd_file]

func _check_level_scripts(results: Dictionary) -> void:
	for i in range(1, 15):  # Levels 1-14
		results["total_files_checked"] += 1
		
		var file_path = f"/workspace/projeto_godot/scripts/Level{i}.gd"
		var content = _read_file_content(file_path)
		
		if not content:
			results["critical_errors"].append(f"Level{i}.gd não encontrado")
			results["files_with_errors"] += 1
			continue
		
		# Verificar estrutura básica
		if not content.contains("func _ready()"):
			results["warnings"].append(f"Level{i}.gd: Não tem função _ready()")
		
		if not content.contains("func"):
			results["syntax_errors"].append(f"Level{i}.gd: Não tem funções definidas")
		
		# Verificar se termina corretamente
		if not content.contains("_exit_tree()"):
			results["warnings"].append(f"Level{i}.gd: Não tem função _exit_tree() para cleanup")

func _check_references(results: Dictionary) -> void:
	# Verificar referências comuns que podem estar quebradas
	var common_references = [
		"LanguageAbilitySystem",
		"AdvancedLanguageAbilitySystem", 
		"DragAndDropSystem",
		"MCPBaseCommandProcessor"
	]
	
	for ref in common_references:
		var ref_count = 0
		var files_to_check = ["scripts/GameManager.gd", "addons/commands/analytics_commands.gd"]
		
		for file_path in files_to_check:
			var full_path = "/workspace/projeto_godot/" + file_path
			var content = _read_file_content(full_path)
			if content and ref in content:
				ref_count += 1
		
		results["references"][ref] = f"Used in {ref_count} arquivos"

func _read_file_content(file_path: String) -> String:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return ""
	var content = file.get_as_text()
	file.close()
	return content

func _file_exists(file_path: String) -> bool:
	return FileAccess.file_exists(file_path)

func print_results(results: Dictionary) -> void:
	print("=== RELATÓRIO DE VERIFICAÇÃO DE ERROS ===")
	print(f"Total de arquivos verificados: {results['total_files_checked']}")
	print(f"Arquivos com erros: {results['files_with_errors']}")
	
	if results["critical_errors"]:
		print("\n🚨 ERROS CRÍTICOS:")
		for error in results["critical_errors"]:
			print(f"  - {error}")
	
	if results["config_errors"]:
		print("\n⚙️ ERROS DE CONFIGURAÇÃO:")
		for error in results["config_errors"]:
			print(f"  - {error}")
	
	if results["syntax_errors"]:
		print("\n📝 ERROS DE SINTAXE:")
		for error in results["syntax_errors"]:
			print(f"  - {error}")
	
	if results["warnings"]:
		print("\n⚠️ AVISOS:")
		for warning in results["warnings"]:
			print(f"  - {warning}")
	
	print("\n📊 REFERÊNCIAS:")
	for key, value in results["references"]:
		print(f"  - {key}: {value}")
	
	# Resumo
	if results["files_with_errors"] == 0:
		print("\n✅ NENHUM ERRO CRÍTICO ENCONTRADO!")
	else:
		print(f"\n❌ {results['files_with_errors']} ARQUIVOS COM PROBLEMAS")
