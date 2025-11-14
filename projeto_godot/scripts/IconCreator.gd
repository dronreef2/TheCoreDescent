extends Control

# Classe para criar um ícone simples programaticamente
class_name IconCreator

func create_simple_icon():
	"""Cria um ícone simples programaticamente"""
	var image = Image.create(128, 128, false, Image.FORMAT_RGBA8)
	
	# Fundo
	image.fill(Color(0.2, 0.3, 0.8))
	
	# Desenhar círculo central
	var center = Vector2(64, 64)
	var radius = 30
	
	for x in range(128):
		for y in range(128):
			var pos = Vector2(x, y)
			if pos.distance_to(center) <= radius:
				image.set_pixel(x, y, Color(0.0, 1.0, 1.0))
	
	# Adicionar texto "TC" no centro (simulado com pixels)
	for x in range(40, 88):
		for y in range(60, 68):
			image.set_pixel(x, y, Color.WHITE)
	
	for x in range(50, 78):
		for y in range(70, 78):
			image.set_pixel(x, y, Color.WHITE)
	
	return ImageTexture.create_from_image(image)

func _ready():
	# Criar e salvar ícone
	var icon_texture = create_simple_icon()
	# O Godot automaticamente usa este script se não houver icon.png
	pass