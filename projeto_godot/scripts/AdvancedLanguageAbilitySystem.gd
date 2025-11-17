extends LanguageAbilitySystem
class_name AdvancedLanguageAbilitySystem

# Sistema Avançado de Habilidades por Linguagem - SPRINT 3
# Expande funcionalidades básicas com mecânicas mais profundas e específicas

# === NOVOS SISTEMAS AVANÇADOS ===

# Sistema de Maestria por Linguagem
var language_mastery: Dictionary = {
	ProgrammingLanguage.PYTHON: 0,  # Experiência no Duck Typing
	ProgrammingLanguage.JAVA: 0,    # Experiência no Garbage Collector
	ProgrammingLanguage.C_SHARP: 0, # Experiência no .NET Framework
	ProgrammingLanguage.JAVASCRIPT: 0 # Experiência no Callback
}

# Sistema de Melhorias Disponíveis
var available_upgrades: Dictionary = {}
var base_cooldown_snapshot: Dictionary = {}

# === EXPANSÕES DAS HABILIDADES ===

# Python - Duck Typing Avançado
var python_dynamic_checks: Dictionary = {}  # Histórico de verificações
var python_type_annotations: Dictionary = {} # Anotações de tipos

# Java - Garbage Collector Avançado
var java_memory_map: Dictionary = {} # Mapeamento de memória/obstáculos
var java_gc_efficiency: float = 1.0  # Eficiência melhorada com maestria

# C# - .NET Framework Avançado
var csharp_bridge_types: Dictionary = {} # Tipos de estruturas disponíveis
var csharp_linq_support: bool = false   # Suporte a LINQ queries

# JavaScript - Callback Avançado
var javascript_event_queue: Array = []   # Fila de eventos pendentes
var javascript_promise_support: bool = false # Suporte a Promises

# === CONFIGURAÇÕES AVANÇADAS ===

# Maestria por níveis
@export var mastery_levels: Array[int] = [0, 25, 75, 150, 300]  # XP necessária por nível
@export var max_mastery_level: int = 5

# Melhorias específicas por linguagem
@export var python_upgrades: Array[String] = ["type_hints", "list_comprehension", "context_manager"]
@export var java_upgrades: Array[String] = ["lambda_expressions", "streams", "optional_class"]
@export var csharp_upgrades: Array[String] = ["linq_queries", "async_await", "extension_methods"]
@export var javascript_upgrades: Array[String] = ["async_functions", "arrow_functions", "destructuring"]

func _ready():
	# Configura sistema avançado
	await setup_advanced_systems()
	# Herda configuração básica do pai
	await super._ready()

func setup_advanced_systems():
	"""Configura sistemas avançados do Sprint 3"""
	setup_mastery_system()
	setup_upgrade_system()
	_cache_base_cooldowns()
	load_saved_progress()

func _cache_base_cooldowns():
	for lang in ProgrammingLanguage.values():
		base_cooldown_snapshot[lang] = ability_cooldown.get(lang, 10.0)

func setup_mastery_system():
	"""Configura sistema de maestria por linguagem"""
	# Inicializa maestria para todas as linguagens
	for lang in ProgrammingLanguage.values():
		language_mastery[lang] = 0
		
	# Configura progressão de XP
	print("Sistema de Maestria inicializado para todas as linguagens")

func setup_upgrade_system():
	"""Configura sistema de melhorias"""
	available_upgrades = {
		ProgrammingLanguage.PYTHON: {
			"type_hints": {"name": "Type Hints", "cost": 50, "description": "Duck Typing mais inteligente"},
			"list_comprehension": {"name": "List Comprehension", "cost": 75, "description": "Múltiplas verificações de tipo"},
			"context_manager": {"name": "Context Manager", "cost": 100, "description": "Duck Typing persistente"}
		},
		ProgrammingLanguage.JAVA: {
			"lambda_expressions": {"name": "Lambda Expressions", "cost": 60, "description": "GC mais preciso"},
			"streams": {"name": "Streams API", "cost": 80, "description": "GC em área maior"},
			"optional_class": {"name": "Optional Class", "cost": 120, "description": "GC inteligente"}
		},
		ProgrammingLanguage.C_SHARP: {
			"linq_queries": {"name": "LINQ Queries", "cost": 70, "description": "Pontes mais inteligentes"},
			"async_await": {"name": "Async/Await", "cost": 90, "description": "Pontes persistentes"},
			"extension_methods": {"name": "Extension Methods", "cost": 110, "description": "Múltiplas pontes"}
		},
		ProgrammingLanguage.JAVASCRIPT: {
			"async_functions": {"name": "Async Functions", "cost": 65, "description": "Callbacks encadeados"},
			"arrow_functions": {"name": "Arrow Functions", "cost": 85, "description": "Callback instantâneo"},
			"destructuring": {"name": "Destructuring", "cost": 105, "description": "Múltiplos callbacks"}
		}
	}

func load_saved_progress():
	"""Carrega progresso salvo (implementação futura)"""
	# Placeholder para sistema de save
	pass

# === SISTEMA DE MAESTRIA ===

func gain_mastery(language: ProgrammingLanguage, amount: int):
	"""Ganha XP de maestria em uma linguagem específica"""
	var current_xp = language_mastery[language]
	var new_xp = min(current_xp + amount, mastery_levels[max_mastery_level-1])
	language_mastery[language] = new_xp
	
	var new_level = get_mastery_level(language)
	var old_level = get_mastery_level(language) - 1 if new_level > 0 else 0
	
	# Verifica se subiu de nível
	if new_level > old_level:
		notify_mastery_level_up(language, new_level)
		
	# Atualiza habilidades baseadas na maestria
	update_abilities_by_mastery(language)

func update_abilities_by_mastery(language: ProgrammingLanguage):
	"""Ajusta habilidades conforme nível de maestria"""
	var ability = abilities.get(language)
	if ability == null:
		return
	var mastery_level = get_mastery_level(language)

	match language:
		ProgrammingLanguage.PYTHON:
			var max_uses = max(1, 1 + mastery_level / 2)
			ability["max_uses"] = max_uses
			ability["uses_remaining"] = max_uses
		ProgrammingLanguage.JAVA:
			ability["area_multiplier"] = 1.0 + (0.15 * mastery_level)
		ProgrammingLanguage.C_SHARP:
			ability["bridge_duration"] = 15.0 + (5.0 * mastery_level)
		ProgrammingLanguage.JAVASCRIPT:
			ability["queue_size"] = 1 + mastery_level

	abilities[language] = ability

func get_mastery_level(language: ProgrammingLanguage) -> int:
	"""Retorna nível de maestria atual"""
	var xp = language_mastery[language]
	for i in range(max_mastery_level):
		if xp < mastery_levels[i]:
			return i
	return max_mastery_level

func get_mastery_percentage(language: ProgrammingLanguage) -> float:
	"""Retorna porcentagem para próximo nível"""
	var current_level = get_mastery_level(language)
	if current_level >= max_mastery_level:
		return 1.0
		
	var current_xp = language_mastery[language]
	var next_level_xp = mastery_levels[current_level]
	var current_level_xp = mastery_levels[current_level-1] if current_level > 0 else 0
	
	var xp_in_current_level = current_xp - current_level_xp
	var xp_needed_for_next = next_level_xp - current_level_xp
	
	return float(xp_in_current_level) / float(xp_needed_for_next)

func notify_mastery_level_up(language: ProgrammingLanguage, new_level: int):
	"""Notifica subida de nível de maestria"""
	var lang_name = _get_language_name(language)
	print("🎉 Maestria em ", lang_name, " subiu para nível ", new_level, "!")
	
	# Desbloqueia novas melhorias
	unlock_new_upgrades(language, new_level)
	
	# Melhora habilidades base
	enhance_base_abilities(language)

func enhance_base_abilities(language: ProgrammingLanguage):
	"""Aplica bônus de maestria às habilidades base"""
	update_abilities_by_mastery(language)
	var base_cooldown = base_cooldown_snapshot.get(language, ability_cooldown.get(language, 10.0))
	var mastery_level = get_mastery_level(language)
	var reduction = clamp(0.05 * mastery_level, 0.0, 0.5)
	ability_cooldown[language] = max(1.0, base_cooldown * (1.0 - reduction))

func unlock_new_upgrades(language: ProgrammingLanguage, level: int):
	"""Desbloqueia novas melhorias baseado no nível"""
	# Implementação específica baseada no nível
	# Por exemplo, nível 2 pode desbloquear melhoria "type_hints" para Python
	pass

# === HABILIDADES EXPANDIDAS ===

func use_advanced_ability(target_position: Vector2 = Vector2.ZERO) -> bool:
	"""Usa habilidade avançada da linguagem selecionada"""
	if not is_ability_available():
		return false
		
	var ability = get_selected_ability()
	var success = false
	
	match selected_language:
		ProgrammingLanguage.PYTHON:
			success = _use_advanced_python_duck_typing(target_position)
		ProgrammingLanguage.JAVA:
			success = _use_advanced_java_garbage_collector(target_position)
		ProgrammingLanguage.C_SHARP:
			success = _use_advanced_csharp_net_framework(target_position)
		ProgrammingLanguage.JAVASCRIPT:
			success = _use_advanced_javascript_callback(target_position)
	
	if success:
		# Ganha XP de maestria
		gain_mastery(selected_language, 10)
		
		# Atualiza cooldown e feedback
		last_used_time[selected_language] = Time.get_ticks_msec() / 1000.0
		_show_advanced_ability_feedback(ability.color, selected_language)
		
		# Notifica gerenciador
		if game_manager and game_manager.has_method("on_advanced_ability_used"):
			game_manager.on_advanced_ability_used(selected_language, success)
	
	return success

func _use_advanced_python_duck_typing(target_position: Vector2) -> bool:
	"""Python - Duck Typing Avançado com verificações dinâmicas"""
	var mastery_level = get_mastery_level(ProgrammingLanguage.PYTHON)
	
	match mastery_level:
		0, 1:
			# Nível básico - comportamento original
			return _use_python_duck_typing(target_position)
		
		2, 3:
			# Nível intermediário - verifica compatibilidade de tipos
			return _perform_intelligent_type_check(target_position)
		
		4, 5:
			# Nível avançado - Duck Typing persistente
			return _perform_persistent_duck_typing(target_position)
	
	return false

func _perform_intelligent_type_check(target_position: Vector2) -> bool:
	"""Verificação inteligente de tipos para Duck Typing"""
	# Simula verificação de "interface" - se o objeto tem os métodos necessários
	var type_compatibility = _check_interface_compatibility(target_position)
	
	if type_compatibility:
		mark_interaction_allowed(target_position)
		print("Python: Duck Typing com verificação de interface bem-sucedida")
		return true
	return false

func _perform_persistent_duck_typing(target_position: Vector2) -> bool:
	"""Duck Typing persistente - permanece ativo por mais tempo"""
	mark_interaction_allowed_persistent(target_position, 30.0)
	print("Python: Duck Typing persistente ativado (30s)")
	return true

func mark_interaction_allowed(position: Vector2):
	if game_manager and game_manager.has_method("mark_interaction_allowed"):
		game_manager.mark_interaction_allowed(position)
	else:
		print("[AbilitySystem] Interação permitida em ", position)

func mark_interaction_allowed_persistent(position: Vector2, duration: float):
	mark_interaction_allowed(position)
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(func():
		print("[AbilitySystem] Janela de interação expirada em ", position)
		timer.queue_free()
	)
	timer.start()

func _use_advanced_java_garbage_collector(target_position: Vector2) -> bool:
	"""Java - Garbage Collector Avançado com otimizações"""
	var mastery_level = get_mastery_level(ProgrammingLanguage.JAVA)
	
	match mastery_level:
		0, 1:
			return _use_java_garbage_collector(target_position)
		
		2, 3:
			return _use_precise_gc(target_position)
		
		4, 5:
			return _use_intelligent_gc(target_position)
	
	return false

func _use_precise_gc(target_position: Vector2) -> bool:
	"""GC preciso com detecção de tipo de obstáculo"""
	var obstacles = game_manager.get_overlapping_objects(target_position, "obstacle")
	var collected = 0
	
	for obstacle in obstacles:
		if _should_collect_obstacle(obstacle):
			if obstacle and obstacle.has_method("queue_free"):
				obstacle.queue_free()
				collected += 1
	
	if collected > 0:
		print("Java: GC preciso coletou ", collected, " obstáculos")
		return true
	return false

func _use_intelligent_gc(target_position: Vector2) -> bool:
	"""GC inteligente que coleta obstacles relacionados"""
	var obstacles = game_manager.get_overlapping_objects(target_position, "obstacle")
	var collected = 0
	var area_center = target_position
	
	# Coleta obstáculo principal e relacionados na área
	for obstacle in obstacles:
		if obstacle and obstacle.has_method("queue_free"):
			# Verifica se há obstáculos relacionados próximos
			if _has_related_obstacles(obstacle, area_center):
				obstacle.queue_free()
				collected += 1
	
	if collected > 0:
		print("Java: GC inteligente coletou ", collected, " obstáculos relacionados")
		return true
	return false

func _use_advanced_csharp_net_framework(target_position: Vector2) -> bool:
	"""C# - .NET Framework Avançado com tipos múltiplos"""
	var mastery_level = get_mastery_level(ProgrammingLanguage.C_SHARP)
	
	match mastery_level:
		0, 1:
			return _use_csharp_net_framework(target_position)
		
		2, 3:
			return _create_smart_bridge(target_position)
		
		4, 5:
			return _create_multiple_structures(target_position)
	
	return false

func _create_smart_bridge(target_position: Vector2) -> bool:
	"""Cria ponte inteligente que se adapta ao ambiente"""
	var bridge_type = _determine_optimal_bridge_type(target_position)
	var bridge = _create_adaptive_bridge(target_position, bridge_type)
	
	if bridge:
		print("C#: Ponte inteligente criada (tipo: ", bridge_type, ")")
		return true
	return false

func _create_multiple_structures(target_position: Vector2) -> bool:
	"""Cria múltiplas estruturas simultaneamente"""
	var structures_created = 0
	var nearby_positions = _get_nearby_gap_positions(target_position)
	
	for pos in nearby_positions:
		var structure = _create_adaptive_bridge(pos, _determine_optimal_bridge_type(pos))
		if structure:
			structures_created += 1
	
	if structures_created > 0:
		print("C#: ", structures_created, " estruturas criadas automaticamente")
		return true
	return false

func _use_advanced_javascript_callback(target_position: Vector2) -> bool:
	"""JavaScript - Callback Avançado com sistema de eventos"""
	var mastery_level = get_mastery_level(ProgrammingLanguage.JAVASCRIPT)
	
	match mastery_level:
		0, 1:
			return _use_javascript_callback(target_position)
		
		2, 3:
			return _create_callback_chain(target_position)
		
		4, 5:
			return _create_async_callback_system(target_position)
	
	return false

func _create_callback_chain(target_position: Vector2) -> bool:
	"""Cria cadeia de callbacks para múltiplos teletransportes"""
	javascript_event_queue.append({
		"position": target_position,
		"timestamp": Time.get_ticks_msec(),
		"type": "callback_chain"
	})
	
	# Se temos callbacks na fila, executa o próximo
	if javascript_event_queue.size() > 1:
		_execute_next_callback_in_chain()
	
	print("JavaScript: Callback adicionado à cadeia (", javascript_event_queue.size(), " total)")
	return true

func _create_async_callback_system(target_position: Vector2) -> bool:
	"""Sistema assíncrono de callbacks"""
	# Cria múltiplas posições de retorno
	var return_positions = _generate_multiple_return_points(target_position)
	
	# Sistema Promise-like para callbacks
	var promise = {
		"then": func(callback):
			javascript_event_queue.append({
				"position": return_positions[0],
				"callback": callback,
				"type": "async_callback"
			}),
		"catch": func(error_callback):
			javascript_event_queue.append({
				"position": target_position,  # Fallback
				"error_callback": error_callback,
				"type": "async_error_callback"
			})
	}
	
	print("JavaScript: Sistema assíncrono de callbacks criado")
	return true

# === MÉTODOS UTILITÁRIOS AVANÇADOS ===

func _check_interface_compatibility(position: Vector2) -> bool:
	"""Verifica compatibilidade de interface (Python)"""
	# Implementação simplificada - verifica se objeto tem "métodos" necessários
	var world_2d = _get_world_2d()
	if world_2d == null:
		return false
	var query = PhysicsRayQueryParameters2D.create(position, position + Vector2(1, 0))
	var result = world_2d.direct_space_state.intersect_ray(query)
	
	# Simula verificação de interface
	return result.size() > 0 and randi() % 3 != 0  # 66% chance de sucesso

func _has_related_obstacles(obstacle: Object, center: Vector2) -> bool:
	"""Verifica se há obstáculos relacionados (Java)"""
	# Implementação simplificada - verifica área ao redor
	return randi() % 2 == 0  # 50% chance de encontrar relacionados

func _determine_optimal_bridge_type(position: Vector2) -> String:
	"""Determina tipo ótimo de estrutura (C#)"""
	var is_water_below = _check_water_below(position)
	var gap_width = _measure_gap_width(position)
	
	if is_water_below:
		return "floating_bridge"
	elif gap_width > 64:
		return "suspension_bridge"
	else:
		return "solid_bridge"

func _get_nearby_gap_positions(center: Vector2) -> Array:
	"""Retorna posições próximas que precisam de estruturas (C#)"""
	var positions = []
	var offsets = [Vector2(-64, 0), Vector2(64, 0), Vector2(0, -32), Vector2(0, 32)]
	
	for offset in offsets:
		var test_pos = center + offset
		if _check_gap_or_water(test_pos):
			positions.append(test_pos)
	
	return positions

func _generate_multiple_return_points(position: Vector2) -> Array:
	"""Gera múltiplos pontos de retorno (JavaScript)"""
	return [
		position + Vector2(-32, 0),  # Esquerda
		position + Vector2(32, 0),   # Direita  
		position + Vector2(0, -32),  # Cima
		position + Vector2(0, 32)    # Baixo
	]

# === SISTEMA DE MELHORIAS ===

func get_available_upgrades(language: ProgrammingLanguage) -> Dictionary:
	"""Retorna melhorias disponíveis para uma linguagem"""
	return available_upgrades.get(language, {})

func purchase_upgrade(language: ProgrammingLanguage, upgrade_id: String) -> bool:
	"""Compra uma melhoria específica"""
	var upgrades = available_upgrades.get(language, {})
	var upgrade = upgrades.get(upgrade_id)
	
	if not upgrade:
		return false
		
	var cost = upgrade.get("cost", 0)
	var current_xp = language_mastery[language]
	
	if current_xp >= cost:
		language_mastery[language] -= cost
		_activate_upgrade(language, upgrade_id)
		print("Melhoria '", upgrade.get("name"), "' comprada!")
		return true
	
	print("XP insuficiente para comprar melhoria")
	return false

func _activate_upgrade(language: ProgrammingLanguage, upgrade_id: String):
	"""Ativa uma melhoria específica"""
	match language:
		ProgrammingLanguage.PYTHON:
			_activate_python_upgrade(upgrade_id)
		ProgrammingLanguage.JAVA:
			_activate_java_upgrade(upgrade_id)
		ProgrammingLanguage.C_SHARP:
			_activate_csharp_upgrade(upgrade_id)
		ProgrammingLanguage.JAVASCRIPT:
			_activate_javascript_upgrade(upgrade_id)

func _activate_python_upgrade(upgrade_id: String):
	"""Ativa melhoria específica do Python"""
	match upgrade_id:
		"type_hints":
			python_type_annotations["enhanced"] = true
			print("Python: Type Hints melhorados ativados!")
		"list_comprehension":
			python_dynamic_checks["multiple_checks"] = true
			print("Python: List Comprehension ativado!")

func _activate_java_upgrade(upgrade_id: String):
	"""Ativa melhoria específica do Java"""
	match upgrade_id:
		"lambda_expressions":
			java_memory_map["smart_detection"] = true
			print("Java: Lambda Expressions ativados!")
		"streams":
			java_memory_map["area_detection"] = true
			print("Java: Streams API ativado!")

func _activate_csharp_upgrade(upgrade_id: String):
	"""Ativa melhoria específica do C#"""
	match upgrade_id:
		"linq_queries":
			csharp_linq_support = true
			print("C#: LINQ Queries ativadas!")
		"async_await":
			csharp_bridge_types["persistent"] = true
			print("C#: Async/Await ativado!")

func _activate_javascript_upgrade(upgrade_id: String):
	"""Ativa melhoria específica do JavaScript"""
	match upgrade_id:
		"async_functions":
			javascript_promise_support = true
			print("JavaScript: Async Functions ativadas!")
		"arrow_functions":
			javascript_event_queue.append({"type": "arrow_function_unlocked"})
			print("JavaScript: Arrow Functions ativadas!")

# === FEEDBACK AVANÇADO ===

func _show_advanced_ability_feedback(color: Color, language: ProgrammingLanguage):
	"""Mostra feedback visual avançado para habilidades"""
	var effect = Sprite2D.new()
	effect.modulate = color
	effect.modulate.a = 0.8
	
	# Efeito baseado na maestria
	var mastery_level = get_mastery_level(language)
	var intensity = 0.5 + (0.5 * float(mastery_level) / float(max_mastery_level))
	
	# Sprite do efeito
	var circle_texture = _create_circle_texture(32 + (mastery_level * 8), color)
	effect.texture = circle_texture
	effect.scale = Vector2(intensity * 1.5, intensity * 1.5)
	
	# Posiciona no jogador
	if player:
		effect.global_position = player.global_position
	else:
		effect.position = Vector2(640, 360)
	
	# Adiciona ao mundo
	get_tree().get_root().add_child(effect)
	
	# Anima e remove
	var tween = create_tween()
	tween.tween_property(effect, "modulate:a", 0.0, 1.5)
	tween.tween_property(effect, "scale", Vector2(0.2, 0.2), 1.5)
	tween.finished.connect(func(): effect.queue_free())
	tween.play()
	
	# Efeito de partículas de maestria
	if mastery_level >= 3:
		_create_mastery_particles(effect.global_position, color, mastery_level)

func _create_mastery_particles(position: Vector2, color: Color, level: int):
	"""Cria efeito de partículas para maestria alta"""
	var particle_count = level * 3
	for i in range(particle_count):
		var particle = Sprite2D.new()
		particle.texture = _create_circle_texture(4, color.lightened(0.3))
		particle.global_position = position + Vector2(randi() % 40 - 20, randi() % 40 - 20)
		particle.modulate.a = 0.0
		
		get_tree().get_root().add_child(particle)
		
		var tween = create_tween()
		tween.tween_property(particle, "modulate:a", 0.8, 0.2)
		tween.tween_property(particle, "scale", Vector2(0.1, 0.1), 0.5)
		tween.tween_property(particle, "modulate:a", 0.0, 0.3)
		tween.finished.connect(func(): particle.queue_free())
		tween.play()

# === MÉTODOS DE QUERY AVANÇADOS ===

func _check_water_below(position: Vector2) -> bool:
	"""Verifica se há água abaixo (C#)"""
	# Implementação simplificada
	return randi() % 3 == 0

func _measure_gap_width(position: Vector2) -> float:
	"""Mede largura do gap (C#)"""
	return float(randi() % 128 + 32)  # 32-160 pixels

func _should_collect_obstacle(obstacle: Object) -> bool:
	"""Determina se obstáculo deve ser coletado (Java)"""
	# Lógica inteligente baseada no tipo de obstáculo
	return obstacle != null and obstacle.has_method("queue_free")

# === MÉTODOS DE EXECUÇÃO ASSÍNCRONA ===

func _execute_next_callback_in_chain():
	"""Executa próximo callback na cadeia (JavaScript)"""
	if javascript_event_queue.size() >= 2:
		var current_callback = javascript_event_queue.pop_front()
		if player and player.has_method("force_move_to"):
			player.force_move_to(current_callback.get("position", player.global_position))
		
		print("JavaScript: Callback da cadeia executado")

# === MÉTODOS PÚBLICOS AVANÇADOS ===

func get_language_stats() -> Dictionary:
	"""Retorna estatísticas completas por linguagem"""
	var stats = {}
	for lang in ProgrammingLanguage.values():
		var lang_name = _get_language_name(lang)
		stats[lang_name] = {
			"mastery_level": get_mastery_level(lang),
			"mastery_xp": language_mastery[lang],
			"mastery_percentage": get_mastery_percentage(lang),
			"available_upgrades": get_available_upgrades(lang).size()
		}
	return stats

func save_progress():
	"""Salva progresso do jogador (implementação futura)"""
	# Placeholder para sistema de save
	pass

func reset_all_progress():
	"""Reseta todo o progresso (para testes)"""
	for lang in ProgrammingLanguage.values():
		language_mastery[lang] = 0
	available_upgrades.clear()
	setup_upgrade_system()

func _get_language_name(language: ProgrammingLanguage) -> String:
	match language:
		ProgrammingLanguage.PYTHON:
			return "Python"
		ProgrammingLanguage.JAVA:
			return "Java"
		ProgrammingLanguage.C_SHARP:
			return "C#"
		ProgrammingLanguage.JAVASCRIPT:
			return "JavaScript"
		_:
			return "Unknown"

func _create_adaptive_bridge(position: Vector2, bridge_type: String) -> Node2D:
	var bridge = Node2D.new()
	bridge.name = "AdaptiveBridge"
	bridge.position = position

	var sprite = Sprite2D.new()
	sprite.texture = _create_bridge_texture()
	bridge.add_child(sprite)

	var collision = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = Vector2(64, 8)
	collision.shape = rect_shape
	bridge.add_child(collision)

	match bridge_type:
		"floating_bridge":
			sprite.modulate = Color(0.3, 0.7, 1.0)
			rect_shape.size = Vector2(72, 6)
		"suspension_bridge":
			sprite.scale = Vector2(1.6, 1.0)
			rect_shape.size = Vector2(110, 10)
		"solid_bridge":
			sprite.modulate = Color(0.8, 0.6, 0.4)

	get_tree().get_root().add_child(bridge)

	var lifespan = 20.0
	if bridge_type == "suspension_bridge":
		lifespan = 30.0
	elif bridge_type == "floating_bridge":
		lifespan = 15.0

	if csharp_bridge_types.get("persistent", false):
		lifespan = 0.0

	if lifespan > 0.0:
		var timer = Timer.new()
		timer.wait_time = lifespan
		timer.one_shot = true
		bridge.add_child(timer)
		timer.timeout.connect(func():
			if bridge and bridge.is_inside_tree():
				bridge.queue_free()
		)
		timer.start()

	return bridge