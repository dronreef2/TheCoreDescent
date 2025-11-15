#!/usr/bin/env -S godot --headless --script
# THE CORE DESCENT - Scene Validation Script
# Arquivo: validate_scene.gd - Testa carregamento headless de cenas/scripts
# Uso: godot --headless --script scripts/ci/validate_scene.gd -- <scene_path>

extends SceneTree

var exit_code = 0

func _init():
	print("=== Scene Validation Test ===")
	
	# Parse argumentos
	var args = OS.get_cmdline_user_args()
	if args.is_empty():
		print("❌ ERROR: No scene path provided")
		print("Usage: godot --headless --script validate_scene.gd -- <scene_path>")
		quit(1)
		return
	
	var scene_path = args[0]
	print("Testing scene: " + scene_path)
	
	# Testar carregamento
	var result = validate_scene(scene_path)
	
	if result.success:
		print("✅ PASS: Scene validation successful")
		print("  - Root node: " + result.root_name)
		print("  - Child count: " + str(result.child_count))
		print("  - Node type: " + result.node_type)
		quit(0)
	else:
		print("❌ FAIL: " + result.error)
		quit(1)

func validate_scene(path: String) -> Dictionary:
	"""Valida que cena/script pode ser carregado"""
	
	# Verificar se arquivo existe
	if not FileAccess.file_exists(path) and not path.begins_with("res://"):
		return {
			"success": false,
			"error": "File not found: " + path
		}
	
	var instance = null
	
	# Tentar carregar como script (.gd)
	if path.ends_with(".gd"):
		print("  Loading as GDScript...")
		var script = load(path)
		if not script:
			return {
				"success": false,
				"error": "Failed to load script: " + path
			}
		
		# Instanciar script
		instance = script.new()
		if not instance:
			return {
				"success": false,
				"error": "Failed to instantiate script"
			}
	
	# Tentar carregar como cena (.tscn)
	elif path.ends_with(".tscn"):
		print("  Loading as PackedScene...")
		var packed_scene = load(path)
		if not packed_scene:
			return {
				"success": false,
				"error": "Failed to load packed scene: " + path
			}
		
		instance = packed_scene.instantiate()
		if not instance:
			return {
				"success": false,
				"error": "Failed to instantiate scene"
			}
	else:
		return {
			"success": false,
			"error": "Unsupported file type (expected .gd or .tscn): " + path
		}
	
	# Validar instância
	var root_name = instance.name if instance else "null"
	var child_count = instance.get_child_count() if instance else 0
	var node_type = instance.get_class() if instance else "null"
	
	print("  Instance created: " + root_name)
	print("  Type: " + node_type)
	print("  Children: " + str(child_count))
	
	# Verificar métodos esperados (para níveis)
	if instance.has_method("_ready"):
		print("  ✓ Has _ready() method")
	
	if instance.has_method("load_available_puzzles"):
		print("  ✓ Has load_available_puzzles() method")
	
	# Cleanup
	instance.free()
	
	return {
		"success": true,
		"root_name": root_name,
		"child_count": child_count,
		"node_type": node_type
	}
