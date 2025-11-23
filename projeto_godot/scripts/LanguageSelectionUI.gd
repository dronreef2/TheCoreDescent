extends Control
class_name LanguageSelectionUI

# UI para seleção de linguagem de programação

# Referências
var ability_system: LanguageAbilitySystem
var game_manager: Node

# Elementos da interface
var panel: Panel
var title_label: Label
var python_button: Button
var java_button: Button
var csharp_button: Button  
var javascript_button: Button
var confirm_button: Button
var cancel_button: Button

# Estado da UI
var selection_mode: bool = false
var current_selection: int = -1

# Sinais
signal language_selected(language_type: int)
signal ui_closed

func _ready():
    setup_ui()
    setup_connections()

func setup_ui():
    """Configura a interface de usuário"""
    
    # Painel principal
    panel = Panel.new()
    panel.name = "LanguageSelectionPanel"
    panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
    panel.anchor_left = 0.0
    panel.anchor_top = 0.0
    panel.anchor_right = 1.0
    panel.anchor_bottom = 1.0
    panel.modulate = Color(0, 0, 0, 0.8)  # Fundo semi-transparente
    add_child(panel)
    
    # Container interno
    var container = VBoxContainer.new()
    container.name = "Container"
    container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    container.size_flags_vertical = Control.SIZE_EXPAND_FILL
    container.anchor_left = 0.5
    container.anchor_top = 0.5
    container.anchor_right = 0.5
    container.anchor_bottom = 0.5
    container.position = Vector2(-200, -150)  # Centraliza
    container.size = Vector2(400, 300)
    panel.add_child(container)
    
    # Título
    title_label = Label.new()
    title_label.name = "TitleLabel"
    title_label.text = "Selecione uma Linguagem de Programação"
    title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    title_label.custom_minimum_size = Vector2(0, 40)
    title_label.add_theme_font_size_override("font_size", 18)
    container.add_child(title_label)
    
    # Spacer
    var spacer1 = Control.new()
    spacer1.custom_minimum_size = Vector2(0, 20)
    container.add_child(spacer1)
    
    # Grid de botões das linguagens
    var grid = GridContainer.new()
    grid.name = "LanguageGrid"
    grid.columns = 2
    grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    grid.custom_minimum_size = Vector2(0, 200)
    container.add_child(grid)
    
    # Botão Python
    python_button = create_language_button(
        "Python", 
        "🐍", 
        Color(52, 152, 219),
        LanguageAbilitySystem.ProgrammingLanguage.PYTHON
    )
    grid.add_child(python_button)
    
    # Botão Java
    java_button = create_language_button(
        "Java", 
        "☕", 
        Color(231, 76, 60),
        LanguageAbilitySystem.ProgrammingLanguage.JAVA
    )
    grid.add_child(java_button)
    
    # Botão C#
    csharp_button = create_language_button(
        "C#", 
        "#", 
        Color(46, 204, 113),
        LanguageAbilitySystem.ProgrammingLanguage.C_SHARP
    )
    grid.add_child(csharp_button)
    
    # Botão JavaScript
    javascript_button = create_language_button(
        "JavaScript", 
        "⚡", 
        Color(241, 196, 15),
        LanguageAbilitySystem.ProgrammingLanguage.JAVASCRIPT
    )
    grid.add_child(javascript_button)
    
    # Spacer
    var spacer2 = Control.new()
    spacer2.custom_minimum_size = Vector2(0, 20)
    container.add_child(spacer2)
    
    # Container de botões
    var button_container = HBoxContainer.new()
    button_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    button_container.custom_minimum_size = Vector2(0, 40)
    container.add_child(button_container)
    
    # Botão Cancelar
    cancel_button = Button.new()
    cancel_button.name = "CancelButton"
    cancel_button.text = "Cancelar"
    cancel_button.custom_minimum_size = Vector2(100, 30)
    button_container.add_child(cancel_button)
    
    # Spacer
    var spacer3 = Control.new()
    spacer3.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    button_container.add_child(spacer3)
    
    # Botão Confirmar
    confirm_button = Button.new()
    confirm_button.name = "ConfirmButton"
    confirm_button.text = "Confirmar"
    confirm_button.custom_minimum_size = Vector2(100, 30)
    confirm_button.disabled = true
    button_container.add_child(confirm_button)
    
    # Inicia oculta
    hide_ui()

func setup_connections():
    """Configura as conexões de sinais"""
    
    # Botões de linguagem
    python_button.pressed.connect(_on_python_selected)
    java_button.pressed.connect(_on_java_selected)
    csharp_button.pressed.connect(_on_csharp_selected)
    javascript_button.pressed.connect(_on_javascript_selected)
    
    # Botões de ação
    confirm_button.pressed.connect(_on_confirm_pressed)
    cancel_button.pressed.connect(_on_cancel_pressed)

func create_language_button(name: String, icon: String, color: Color, lang_type: int) -> Button:
    """Cria um botão para seleção de linguagem"""
    var button = Button.new()
    button.name = name + "Button"
    button.custom_minimum_size = Vector2(180, 80)
    button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    button.size_flags_vertical = Control.SIZE_EXPAND_FILL
    
    # Container do botão
    var container = VBoxContainer.new()
    container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    container.size_flags_vertical = Control.SIZE_EXPAND_FILL
    
    # Ícone
    var icon_label = Label.new()
    icon_label.text = icon
    icon_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    icon_label.custom_minimum_size = Vector2(0, 40)
    icon_label.add_theme_font_size_override("font_size", 24)
    container.add_child(icon_label)
    
    # Nome da linguagem
    var name_label = Label.new()
    name_label.text = name
    name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    name_label.custom_minimum_size = Vector2(0, 30)
    container.add_child(name_label)
    
    # Descrição da habilidade
    var desc_label = Label.new()
    desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    desc_label.custom_minimum_size = Vector2(0, 20)
    desc_label.add_theme_font_size_override("font_size", 10)
    
    match lang_type:
        LanguageAbilitySystem.ProgrammingLanguage.PYTHON:
            desc_label.text = "Duck Typing"
        LanguageAbilitySystem.ProgrammingLanguage.JAVA:
            desc_label.text = "Garbage Collector"
        LanguageAbilitySystem.ProgrammingLanguage.C_SHARP:
            desc_label.text = ".NET Framework"
        LanguageAbilitySystem.ProgrammingLanguage.JAVASCRIPT:
            desc_label.text = "Callback"
    
    container.add_child(desc_label)
    
    # Adiciona container ao botão
    button.add_child(container)
    
    # Armazena o tipo de linguagem
    button.set_meta("language_type", lang_type)
    button.set_meta("name", name)
    button.set_meta("color", color)
    
    return button

func show_ui():
    """Mostra a interface de seleção"""
    panel.visible = true
    panel.mouse_filter = Control.MOUSE_FILTER_STOP
    selection_mode = true
    current_selection = -1
    confirm_button.disabled = true
    reset_button_styles()

func hide_ui():
    """Esconde a interface de seleção"""
    panel.visible = false
    panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
    selection_mode = false

func reset_button_styles():
    """Reseta o estilo de todos os botões"""
    var buttons = [python_button, java_button, csharp_button, javascript_button]
    
    for button in buttons:
        button.modulate = Color.WHITE
        button.add_theme_stylebox_override("normal", create_normal_style())

func create_normal_style() -> StyleBoxFlat:
    """Cria um estilo normal para botões"""
    var style = StyleBoxFlat.new()
    style.bg_color = Color(60, 60, 60, 180)
    style.corner_radius_top_left = 8
    style.corner_radius_top_right = 8
    style.corner_radius_bottom_left = 8
    style.corner_radius_bottom_right = 8
    return style

func create_selected_style(color: Color) -> StyleBoxFlat:
    """Cria um estilo para botão selecionado"""
    var style = StyleBoxFlat.new()
    style.bg_color = color
    style.corner_radius_top_left = 8
    style.corner_radius_top_right = 8
    style.corner_radius_bottom_left = 8
    style.corner_radius_bottom_right = 8
    return style

func _on_python_selected():
    _select_language(python_button)

func _on_java_selected():
    _select_language(java_button)

func _on_csharp_selected():
    _select_language(csharp_button)

func _on_javascript_selected():
    _select_language(javascript_button)

func _select_language(button: Button):
    """Seleciona uma linguagem específica"""
    reset_button_styles()
    
    # Aplica estilo selecionado
    var color = button.get_meta("color")
    button.add_theme_stylebox_override("focused", create_selected_style(color))
    button.modulate = Color(color.r * 1.2, color.g * 1.2, color.b * 1.2)
    
    # Atualiza seleção
    current_selection = button.get_meta("language_type")
    confirm_button.disabled = false

func _on_confirm_pressed():
    """Confirma a seleção da linguagem"""
    if current_selection >= 0:
        emit_signal("language_selected", current_selection)
        hide_ui()

func _on_cancel_pressed():
    """Cancela a seleção"""
    hide_ui()
    emit_signal("ui_closed")

func set_ability_system(ability_sys: LanguageAbilitySystem):
    """Define o sistema de habilidades"""
    ability_system = ability_sys

func set_game_manager(gm: Node):
    """Define o gerenciador do jogo"""
    game_manager = gm

# Função para chamada externa - força seleção de linguagem
func force_language_selection():
    """Força a seleção de linguagem e não permite continuar sem ela"""
    show_ui()
    
    # Desabilita a opção de cancelar
    cancel_button.disabled = true
    cancel_button.visible = false