extends Control
class_name CooldownIndicator

# Indicador visual de cooldown das habilidades

# Referências
var ability_system: LanguageAbilitySystem

# Elementos da interface
var cooldown_panel: Panel
var ability_icon: Label
var cooldown_text: Label
var progress_circle: Control
var ready_label: Label

# Estado
var is_visible: bool = false

func _ready():
	setup_ui()
	hide_cooldown()

func setup_ui():
	"""Configura a interface do indicador"""
	
	# Painel principal
	cooldown_panel = Panel.new()
	cooldown_panel.name = "CooldownPanel"
	cooldown_panel.custom_minimum_size = Vector2(80, 80)
	cooldown_panel.anchor_right = 1.0
	cooldown_panel.anchor_bottom = 0.0
	cooldown_panel.position = Vector2(-90, 10)  # Canto superior direito
	cooldown_panel.add_theme_stylebox_override("panel", create_panel_style())
	cooldown_panel.visible = false
	add_child(cooldown_panel)
	
	# Container interno
	var container = VBoxContainer.new()
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	container.custom_minimum_size = Vector2(80, 80)
	cooldown_panel.add_child(container)
	
	# Ícone da habilidade
	ability_icon = Label.new()
	ability_icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ability_icon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	ability_icon.custom_minimum_size = Vector2(80, 40)
	ability_icon.add_theme_font_size_override("font_size", 24)
	container.add_child(ability_icon)
	
	# Texto do cooldown
	cooldown_text = Label.new()
	cooldown_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cooldown_text.custom_minimum_size = Vector2(80, 20)
	cooldown_text.add_theme_font_size_override("font_size", 12)
	container.add_child(cooldown_text)
	
	# Label "Pronta"
	ready_label = Label.new()
	ready_label.text = "PRONTA"
	ready_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ready_label.custom_minimum_size = Vector2(80, 15)
	ready_label.add_theme_font_size_override("font_size", 10)
	ready_label.add_theme_color_override("font_color", Color.GREEN)
	ready_label.visible = false
	container.add_child(ready_label)

func create_panel_style() -> StyleBoxFlat:
	"""Cria o estilo do painel de cooldown"""
	var style = StyleBoxFlat.new()
	style.bg_color = Color(20, 20, 20, 200)
	style.border_color = Color(100, 100, 100)
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	return style

func set_ability_system(ability_sys: LanguageAbilitySystem):
	"""Define o sistema de habilidades"""
	ability_system = ability_sys

func show_cooldown(language_type: int, ability_data: Dictionary):
	"""Mostra o indicador de cooldown para uma habilidade"""
	if not ability_system:
		return
		
	# Atualiza ícone baseado na linguagem
	match language_type:
		LanguageAbilitySystem.ProgrammingLanguage.PYTHON:
			ability_icon.text = "🐍"
		LanguageAbilitySystem.ProgrammingLanguage.JAVA:
			ability_icon.text = "☕"
		LanguageAbilitySystem.ProgrammingLanguage.C_SHARP:
			ability_icon.text = "#"
		LanguageAbilitySystem.ProgrammingLanguage.JAVASCRIPT:
			ability_icon.text = "⚡"
	
	cooldown_panel.visible = true
	cooldown_panel.modulate = Color(ability_data.get("color", Color.WHITE))
	is_visible = true
	ready_label.visible = false

func hide_cooldown():
	"""Esconde o indicador de cooldown"""
	cooldown_panel.visible = false
	is_visible = false

func update_cooldown_display():
	"""Atualiza a exibição do cooldown"""
	if not is_visible or not ability_system:
		return
		
	var remaining_time = ability_system.get_remaining_cooldown()
	
	if remaining_time <= 0:
		# Habilidade está pronta
		cooldown_text.text = ""
		ready_label.visible = true
		cooldown_panel.modulate.a = 1.0
	else:
		# Mostra tempo restante
		cooldown_text.text = str(round(remaining_time * 10) / 10) + "s"
		ready_label.visible = false
		
		# Calcula alpha baseado no cooldown
		var total_cooldown = ability_system.ability_cooldown.get(ability_system.selected_language, 10.0)
		var alpha = 0.3 + (0.7 * (1.0 - (remaining_time / total_cooldown)))
		cooldown_panel.modulate.a = alpha

func _process(_delta):
	"""Processa atualizações do cooldown"""
	update_cooldown_display()