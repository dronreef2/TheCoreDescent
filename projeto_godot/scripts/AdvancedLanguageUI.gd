extends Control
class_name AdvancedLanguageUI

# Interface Avançada para Sistema de Habilidades por Linguagem - SPRINT 3

# Referências
var ability_system: AdvancedLanguageAbilitySystem
var game_manager: Node

# === ELEMENTOS DA INTERFACE ===

# Painel principal de informações avançadas
var info_panel: Panel
var mastery_panel: Panel
var upgrades_panel: Panel
var stats_panel: Panel

# Labels de informação
var current_language_label: Label
var mastery_level_label: Label
var mastery_progress_bar: ProgressBar
var xp_label: Label

# Lista de melhorias disponíveis
var upgrades_container: VBoxContainer
var upgrade_buttons: Array[Button] = []

# Estatísticas globais
var global_stats_label: Label

# === CONFIGURAÇÕES DE DESIGN ===

# Cores por linguagem
var language_colors: Dictionary = {
	AdvancedLanguageAbilitySystem.ProgrammingLanguage.PYTHON: Color(52, 152, 219),
	AdvancedLanguageAbilitySystem.ProgrammingLanguage.JAVA: Color(231, 76, 60),
	AdvancedLanguageAbilitySystem.ProgrammingLanguage.C_SHARP: Color(46, 204, 113),
	AdvancedLanguageAbilitySystem.ProgrammingLanguage.JAVASCRIPT: Color(241, 196, 15)
}

# === ESTADO DA INTERFACE ===

var current_language: int = 0
var showing_stats: bool = false
var auto_update: bool = true

# === SINIAIS ===

signal upgrade_purchased(language_type: int, upgrade_id: String)
signal language_switched(new_language: int)

func _ready():
	setup_advanced_ui()
	connect_signals()
	if auto_update:
		start_auto_update()

func setup_advanced_ui():
	"""Configura interface avançada para Sprint 3"""
	setup_info_panel()
	setup_mastery_panel()
	setup_upgrades_panel()
	setup_stats_panel()
	hide_advanced_ui()

func setup_info_panel():
	"""Configura painel de informações avançadas"""
	
	# Painel principal (atualiza o existente)
	info_panel = Panel.new()
	info_panel.name = "AdvancedInfoPanel"
	info_panel.custom_minimum_size = Vector2(300, 200)
	info_panel.anchor_left = 0.0
	info_panel.anchor_top = 0.0
	info_panel.anchor_right = 0.0
	info_panel.anchor_bottom = 0.0
	info_panel.position = Vector2(10, 70)
	info_panel.add_theme_stylebox_override("panel", create_advanced_panel_style())
	info_panel.visible = false
	add_child(info_panel)
	
	# Container interno
	var container = VBoxContainer.new()
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	container.custom_minimum_size = Vector2(300, 200)
	info_panel.add_child(container)
	
	# Cabeçalho com linguagem atual
	var header = HBoxContainer.new()
	header.custom_minimum_size = Vector2(280, 30)
	container.add_child(header)
	
	# Ícone da linguagem
	var icon_label = Label.new()
	icon_label.custom_minimum_size = Vector2(30, 30)
	icon_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header.add_child(icon_label)
	
	# Label da linguagem
	current_language_label = Label.new()
	current_language_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	current_language_label.add_theme_font_size_override("font_size", 14)
	current_language_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(current_language_label)
	
	# Spacer
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(10, 1)
	header.add_child(spacer)
	
	# Botão de切换 linguagens
	var switch_button = Button.new()
	switch_button.text = "⟲"
	switch_button.custom_minimum_size = Vector2(25, 25)
	switch_button.tooltip_text = "Trocar Linguagem"
	header.add_child(switch_button)
	switch_button.pressed.connect(_on_switch_language_pressed)
	
	# Nível de Maestria
	mastery_level_label = Label.new()
	mastery_level_label.text = "Maestria: Nível 0"
	mastery_level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mastery_level_label.add_theme_font_size_override("font_size", 12)
	mastery_level_label.custom_minimum_size = Vector2(280, 25)
	container.add_child(mastery_level_label)
	
	# Barra de progresso de maestria
	mastery_progress_bar = ProgressBar.new()
	mastery_progress_bar.min_value = 0
	mastery_progress_bar.max_value = 100
	mastery_progress_bar.value = 0
	mastery_progress_bar.custom_minimum_size = Vector2(280, 20)
	container.add_child(mastery_progress_bar)
	
	# XP atual
	xp_label = Label.new()
	xp_label.text = "XP: 0 / 25"
	xp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	xp_label.add_theme_font_size_override("font_size", 10)
	xp_label.custom_minimum_size = Vector2(280, 20)
	container.add_child(xp_label)
	
	# Separador visual
	var separator = HSeparator.new()
	separator.custom_minimum_size = Vector2(280, 5)
	container.add_child(separator)
	
	# Descrição da habilidade atual
	var ability_desc_label = Label.new()
	ability_desc_label.text = ""
	ability_desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ability_desc_label.add_theme_font_size_override("font_size", 9)
	ability_desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	ability_desc_label.custom_minimum_size = Vector2(280, 30)
	container.add_child(ability_desc_label)

func setup_mastery_panel():
	"""Configura painel de maestria avançada"""
	
	mastery_panel = Panel.new()
	mastery_panel.name = "MasteryPanel"
	mastery_panel.custom_minimum_size = Vector2(400, 300)
	mastery_panel.anchor_left = 0.5
	mastery_panel.anchor_top = 0.5
	mastery_panel.anchor_right = 0.5
	mastery_panel.anchor_bottom = 0.5
	mastery_panel.position = Vector2(-200, -150)
	mastery_panel.visible = false
	mastery_panel.add_theme_stylebox_override("panel", create_modal_panel_style())
	add_child(mastery_panel)
	
	# Header
	var header = HBoxContainer.new()
	header.custom_minimum_size = Vector2(380, 40)
	mastery_panel.add_child(header)
	
	var title = Label.new()
	title.text = "Maestria por Linguagem"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 16)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	
	var close_btn = Button.new()
	close_btn.text = "✕"
	close_btn.custom_minimum_size = Vector2(30, 30)
	close_btn.pressed.connect(func(): mastery_panel.visible = false)
	header.add_child(close_btn)
	
	# Grid de linguagens
	var grid = GridContainer.new()
	grid.columns = 2
	grid.custom_minimum_size = Vector2(380, 200)
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	mastery_panel.add_child(grid)
	
	# Criar cards para cada linguagem
	var languages = AdvancedLanguageAbilitySystem.ProgrammingLanguage.values()
	for lang in languages:
		grid.add_child(create_language_mastery_card(lang))

func setup_upgrades_panel():
	"""Configura painel de melhorias"""
	
	upgrades_panel = Panel.new()
	upgrades_panel.name = "UpgradesPanel"
	upgrades_panel.custom_minimum_size = Vector2(450, 400)
	upgrades_panel.anchor_left = 0.5
	upgrades_panel.anchor_top = 0.5
	upgrades_panel.anchor_right = 0.5
	upgrades_panel.anchor_bottom = 0.5
	upgrades_panel.position = Vector2(-225, -200)
	upgrades_panel.visible = false
	upgrades_panel.add_theme_stylebox_override("panel", create_modal_panel_style())
	add_child(upgrades_panel)
	
	# Header
	var header = HBoxContainer.new()
	header.custom_minimum_size = Vector2(430, 40)
	upgrades_panel.add_child(header)
	
	var title = Label.new()
	title.text = "Melhorias Disponíveis"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 16)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	
	var close_btn = Button.new()
	close_btn.text = "✕"
	close_btn.custom_minimum_size = Vector2(30, 30)
	close_btn.pressed.connect(func(): upgrades_panel.visible = false)
	header.add_child(close_btn)
	
	# Container de melhorias
	upgrades_container = VBoxContainer.new()
	upgrades_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	upgrades_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	upgrades_container.custom_minimum_size = Vector2(430, 300)
	upgrades_panel.add_child(upgrades_container)

func setup_stats_panel():
	"""Configura painel de estatísticas globais"""
	
	stats_panel = Panel.new()
	stats_panel.name = "GlobalStatsPanel"
	stats_panel.custom_minimum_size = Vector2(500, 350)
	stats_panel.anchor_left = 0.5
	stats_panel.anchor_top = 0.5
	stats_panel.anchor_right = 0.5
	stats_panel.anchor_bottom = 0.5
	stats_panel.position = Vector2(-250, -175)
	stats_panel.visible = false
	stats_panel.add_theme_stylebox_override("panel", create_modal_panel_style())
	add_child(stats_panel)
	
	# Header
	var header = HBoxContainer.new()
	header.custom_minimum_size = Vector2(480, 40)
	stats_panel.add_child(header)
	
	var title = Label.new()
	title.text = "Estatísticas Globais"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 16)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	
	var close_btn = Button.new()
	close_btn.text = "✕"
	close_btn.custom_minimum_size = Vector2(30, 30)
	close_btn.pressed.connect(func(): stats_panel.visible = false)
	header.add_child(close_btn)
	
	# Container de estatísticas
	var stats_container = VBoxContainer.new()
	stats_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stats_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stats_container.custom_minimum_size = Vector2(480, 280)
	stats_panel.add_child(stats_container)

func create_language_mastery_card(language: int) -> Panel:
	"""Cria card de maestria para uma linguagem específica"""
	var card = Panel.new()
	card.custom_minimum_size = Vector2(180, 120)
	card.add_theme_stylebox_override("panel", create_card_style(language_colors[language]))
	
	var container = VBoxContainer.new()
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	card.add_child(container)
	
	# Cabeçalho do card
	var header = HBoxContainer.new()
	header.custom_minimum_size = Vector2(160, 25)
	container.add_child(header)
	
	var icon = Label.new()
	icon.text = get_language_icon(language)
	icon.add_theme_font_size_override("font_size", 16)
	header.add_child(icon)
	
	var name = Label.new()
	name.text = get_language_name(language)
	name.add_theme_font_size_override("font_size", 12)
	header.add_child(name)
	
	# Nível de maestria
	var level_label = Label.new()
	level_label.text = "Nível 0"
	level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_label.add_theme_font_size_override("font_size", 11)
	level_label.custom_minimum_size = Vector2(160, 20)
	container.add_child(level_label)
	
	# Barra de progresso
	var progress_bar = ProgressBar.new()
	progress_bar.custom_minimum_size = Vector2(160, 15)
	progress_bar.min_value = 0
	progress_bar.max_value = 100
	progress_bar.value = 0
	container.add_child(progress_bar)
	
	# XP
	var xp_label = Label.new()
	xp_label.text = "0 / 25 XP"
	xp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	xp_label.add_theme_font_size_override("font_size", 9)
	xp_label.custom_minimum_size = Vector2(160, 20)
	container.add_child(xp_label)
	
	# Botão de ver melhorias
	var view_btn = Button.new()
	view_btn.text = "Ver Melhorias"
	view_btn.custom_minimum_size = Vector2(160, 25)
	view_btn.pressed.connect(func(): show_upgrades_for_language(language))
	container.add_child(view_btn)
	
	# Atualiza dados do card
	update_card_data(card, language)
	
	return card

func create_advanced_panel_style() -> StyleBoxFlat:
	"""Cria estilo avançado para painéis"""
	var style = StyleBoxFlat.new()
	style.bg_color = Color(25, 25, 25, 220)
	style.border_color = Color(80, 80, 80)
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	return style

func create_modal_panel_style() -> StyleBoxFlat:
	"""Cria estilo para painéis modais"""
	var style = StyleBoxFlat.new()
	style.bg_color = Color(35, 35, 35, 240)
	style.border_color = Color(100, 100, 100)
	style.border_width_left = 3
	style.border_width_right = 3
	style.border_width_top = 3
	style.border_width_bottom = 3
	style.corner_radius_top_left = 15
	style.corner_radius_top_right = 15
	style.corner_radius_bottom_left = 15
	style.corner_radius_bottom_right = 15
	return style

func create_card_style(color: Color) -> StyleBoxFlat:
	"""Cria estilo para cards de maestria"""
	var style = StyleBoxFlat.new()
	style.bg_color = color.lightened(0.7)
	style.border_color = color
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	return style

# === MÉTODOS DE ATUALIZAÇÃO ===

func update_advanced_ui(language: int, stats: Dictionary):
	"""Atualiza interface avançada com novos dados"""
	if not info_panel.visible:
		return
		
	current_language = language
	var lang_stats = stats.get(get_language_name(language), {})
	
	# Atualiza informação básica
	var icon = get_language_icon(language)
	var name = get_language_name(language)
	var level = lang_stats.get("mastery_level", 0)
	var xp = lang_stats.get("mastery_xp", 0)
	var percentage = lang_stats.get("mastery_percentage", 0.0)
	
	# Atualiza labels
	var header_container = info_panel.get_node("VBoxContainer/HBoxContainer")
	var icon_label = header_container.get_child(0)
	var current_lang_label = header_container.get_child(1)
	
	icon_label.text = icon
	current_lang_label.text = name
	
	mastery_level_label.text = "Maestria: Nível " + str(level)
	xp_label.text = "XP: " + str(xp) + " / " + str(_get_next_level_xp(level))
	
	# Atualiza barra de progresso
	mastery_progress_bar.value = percentage * 100
	mastery_progress_bar.modulate = language_colors[language]
	
	# Atualiza descrição da habilidade
	var desc_label = info_panel.get_node("VBoxContainer/Label[5]")
	desc_label.text = get_ability_description(language, level)

func _get_next_level_xp(current_level: int) -> int:
	"""Retorna XP necessária para próximo nível"""
	var levels = ability_system.mastery_levels if ability_system else [0, 25, 75, 150, 300]
	if current_level >= levels.size() - 1:
		return levels[levels.size() - 1]
	return levels[current_level]

# === MÉTODOS DE INTERAÇÃO ===

func show_advanced_ui(language: int):
	"""Mostra interface avançada para uma linguagem"""
	if not ability_system:
		return
		
	info_panel.visible = true
	
	# Atualiza com dados atuais
	var stats = ability_system.get_language_stats()
	update_advanced_ui(language, stats)

func hide_advanced_ui():
	"""Esconde interface avançada"""
	info_panel.visible = false

func show_mastery_overview():
	"""Mostra overview de maestria de todas as linguagens"""
	mastery_panel.visible = true

func show_upgrades_for_language(language: int):
	"""Mostra melhorias disponíveis para uma linguagem específica"""
	if not ability_system:
		return
		
	# Limpa container anterior
	for child in upgrades_container.get_children():
		child.queue_free()
	
	# Atualiza título
	var title_label = upgrades_panel.get_node("HBoxContainer/Label")
	title_label.text = "Melhorias - " + get_language_name(language)
	
	# Busca melhorias disponíveis
	var available_upgrades = ability_system.get_available_upgrades(language)
	
	if available_upgrades.is_empty():
		var no_upgrades_label = Label.new()
		no_upgrades_label.text = "Nenhuma melhoria disponível ainda.\nContinue usando habilidades para ganhar XP!"
		no_upgrades_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		no_upgrades_label.add_theme_font_size_override("font_size", 12)
		upgrades_container.add_child(no_upgrades_label)
	else:
		# Cria botões para cada melhoria
		for upgrade_id in available_upgrades.keys():
			var upgrade = available_upgrades[upgrade_id]
			var upgrade_btn = create_upgrade_button(upgrade_id, upgrade, language)
			upgrades_container.add_child(upgrade_btn)
	
	upgrades_panel.visible = true

func create_upgrade_button(upgrade_id: String, upgrade_data: Dictionary, language: int) -> Button:
	"""Cria botão para uma melhoria específica"""
	var button = Button.new()
	button.custom_minimum_size = Vector2(410, 60)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	# Container interno
	var container = HBoxContainer.new()
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.custom_minimum_size = Vector2(410, 60)
	button.add_child(container)
	
	# Informações da melhoria
	var info_container = VBoxContainer.new()
	info_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_container.custom_minimum_size = Vector2(300, 50)
	container.add_child(info_container)
	
	# Nome da melhoria
	var name_label = Label.new()
	name_label.text = upgrade_data.get("name", upgrade_id)
	name_label.add_theme_font_size_override("font_size", 12)
	name_label.custom_minimum_size = Vector2(300, 20)
	info_container.add_child(name_label)
	
	# Descrição
	var desc_label = Label.new()
	desc_label.text = upgrade_data.get("description", "")
	desc_label.add_theme_font_size_override("font_size", 9)
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	desc_label.custom_minimum_size = Vector2(300, 30)
	info_container.add_child(desc_label)
	
	# Custo de XP
	var cost_label = Label.new()
	var cost = upgrade_data.get("cost", 0)
	cost_label.text = "Custo: " + str(cost) + " XP"
	cost_label.add_theme_font_size_override("font_size", 10)
	cost_label.custom_minimum_size = Vector2(80, 30)
	info_container.add_child(cost_label)
	
	# Espaçador
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(10, 1)
	container.add_child(spacer)
	
	# Botão de compra
	var buy_btn = Button.new()
	buy_btn.text = "Comprar"
	buy_btn.custom_minimum_size = Vector2(80, 40)
	buy_btn.pressed.connect(func():
		if ability_system.purchase_upgrade(language, upgrade_id):
			emit_signal("upgrade_purchased", language, upgrade_id)
			show_upgrades_for_language(language)  # Atualiza lista
	)
	container.add_child(buy_btn)
	
	# Verifica se pode comprar
	var current_xp = 0
	if ability_system:
		current_xp = ability_system.language_mastery.get(language, 0)
	
	if current_xp < cost:
		buy_btn.disabled = true
		buy_btn.modulate = Color.GRAY
	
	return button

func show_global_statistics():
	"""Mostra estatísticas globais do progresso"""
	if not ability_system:
		return
		
	# Limpa container anterior
	var stats_container = stats_panel.get_node("VBoxContainer")
	for child in stats_container.get_children():
		if child.name != "HBoxContainer":  # Preserva header
			child.queue_free()
	
	# Busca estatísticas globais
	var global_stats = ability_system.get_language_stats()
	
	# Cria seção para cada linguagem
	for lang_name in global_stats.keys():
		var lang_stats = global_stats[lang_name]
		
		var lang_section = VBoxContainer.new()
		lang_section.custom_minimum_size = Vector2(460, 60)
		stats_container.add_child(lang_section)
		
		# Cabeçalho da linguagem
		var header = Label.new()
		header.text = lang_name + ":"
		header.add_theme_font_size_override("font_size", 14)
		header.custom_minimum_size = Vector2(460, 20)
		lang_section.add_child(header)
		
		# Estatísticas detalhadas
		var stats_text = Label.new()
		var level = lang_stats.get("mastery_level", 0)
		var xp = lang_stats.get("mastery_xp", 0)
		var percentage = int(lang_stats.get("mastery_percentage", 0.0) * 100)
		var upgrades = lang_stats.get("available_upgrades", 0)
		
		stats_text.text = "  Nível: " + str(level) + " | XP: " + str(xp) + " | Progresso: " + str(percentage) + "% | Melhorias: " + str(upgrades)
		stats_text.add_theme_font_size_override("font_size", 11)
		stats_text.custom_minimum_size = Vector2(460, 30)
		lang_section.add_child(stats_text)
	
	stats_panel.visible = true

# === MÉTODOS UTILITÁRIOS ===

func get_language_name(language: int) -> String:
	"""Retorna nome da linguagem"""
	match language:
		AdvancedLanguageAbilitySystem.ProgrammingLanguage.PYTHON:
			return "Python"
		AdvancedLanguageAbilitySystem.ProgrammingLanguage.JAVA:
			return "Java"
		AdvancedLanguageAbilitySystem.ProgrammingLanguage.C_SHARP:
			return "C#"
		AdvancedLanguageAbilitySystem.ProgrammingLanguage.JAVASCRIPT:
			return "JavaScript"
		_:
			return "Unknown"

func get_language_icon(language: int) -> String:
	"""Retorna ícone da linguagem"""
	match language:
		AdvancedLanguageAbilitySystem.ProgrammingLanguage.PYTHON:
			return "🐍"
		AdvancedLanguageAbilitySystem.ProgrammingLanguage.JAVA:
			return "☕"
		AdvancedLanguageAbilitySystem.ProgrammingLanguage.C_SHARP:
			return "#"
		AdvancedLanguageAbilitySystem.ProgrammingLanguage.JAVASCRIPT:
			return "⚡"
		_:
			return "?"

func get_ability_description(language: int, mastery_level: int) -> String:
	"""Retorna descrição da habilidade baseada no nível de maestria"""
	match language:
		AdvancedLanguageAbilitySystem.ProgrammingLanguage.PYTHON:
			if mastery_level >= 4:
				return "Duck Typing Persistente: Permite uso de chaves incorretas por 30 segundos"
			elif mastery_level >= 2:
				return "Duck Typing Inteligente: Verifica compatibilidade de interface antes de permitir acesso"
			else:
				return "Duck Typing Básico: Permite usar chave errada uma vez"
		
		AdvancedLanguageAbilitySystem.ProgrammingLanguage.JAVA:
			if mastery_level >= 4:
				return "GC Inteligente: Remove obstáculo principal e relacionados automaticamente"
			elif mastery_level >= 2:
				return "GC Preciso: Detecta tipo de obstáculo e remove apenas os desnecessários"
			else:
				return "Garbage Collector Básico: Remove qualquer obstáculo próximo"
		
		AdvancedLanguageAbilitySystem.ProgrammingLanguage.C_SHARP:
			if mastery_level >= 4:
				return "Multi-estruturas: Cria automaticamente múltiplas pontes próximas"
			elif mastery_level >= 2:
				return "Ponte Inteligente: Adapta tipo de estrutura ao ambiente"
			else:
				return ".NET Framework Básico: Cria ponte padrão sobre vazios"
		
		AdvancedLanguageAbilitySystem.ProgrammingLanguage.JAVASCRIPT:
			if mastery_level >= 4:
				return "Sistema Assíncrono: Criar cadeias de callbacks e teletransportes múltiplos"
			elif mastery_level >= 2:
				return "Cadeia de Callbacks: Permite múltiplos teletransportes em sequência"
			else:
				return "Callback Básico: Teleporte para posição marcada"
		
		_:
			return "Habilidade ainda não desbloqueada"

# === CONTROLE DE SINAIS ===

func connect_signals():
	"""Conecta sinais do sistema"""
	pass

func _on_switch_language_pressed():
	"""Callback para trocar linguagem"""
	var gm = get_tree().get_root().get_node("Main").get_node("GameManager")
	if gm and gm.has_method("show_language_selection_ui"):
		gm.show_language_selection_ui()

func start_auto_update():
	"""Inicia atualização automática da UI"""
	var timer = Timer.new()
	timer.wait_time = 0.5  # Atualiza a cada 0.5 segundos
	timer.one_shot = false
	timer.timeout.connect(_on_auto_update_timeout)
	add_child(timer)
	timer.start()

func _on_auto_update_timeout():
	"""Callback de atualização automática"""
	if ability_system and info_panel.visible:
		var stats = ability_system.get_language_stats()
		update_advanced_ui(current_language, stats)

# === MÉTODOS PÚBLICOS ===

func set_ability_system(ability_sys: AdvancedLanguageAbilitySystem):
	"""Define o sistema de habilidades avançado"""
	ability_system = ability_sys

func show_language_mastery():
	"""Mostra overview de maestria"""
	show_mastery_overview()

func show_current_upgrades():
	"""Mostra melhorias da linguagem atual"""
	show_upgrades_for_language(current_language)

func show_statistics():
	"""Mostra estatísticas globais"""
	show_global_statistics()

func update_card_data(card: Panel, language: int):
	"""Atualiza dados de um card de maestria específico"""
	if not ability_system:
		return
		
	var stats = ability_system.language_mastery
	var level = ability_system.get_mastery_level(language)
	var xp = stats.get(language, 0)
	var percentage = ability_system.get_mastery_percentage(language)
	
	# Atualiza labels no card
	var container = card.get_node("VBoxContainer")
	var level_label = container.get_node("Label[2]")
	var progress_bar = container.get_child(2)  # Index 2 é a progress bar
	var xp_label = container.get_node("Label[4]")
	
	level_label.text = "Nível " + str(level)
	progress_bar.value = percentage * 100
	xp_label.text = str(xp) + " / " + str(_get_next_level_xp(level)) + " XP"
	
	# Atualiza cor da barra de progresso
	progress_bar.modulate = language_colors[language]