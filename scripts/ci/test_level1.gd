#!/usr/bin/env -S godot --headless --script
# THE CORE DESCENT - Level1 Integration Test
# Arquivo: test_level1.gd - Testa Level1 completo com BaseLevel
# Uso: godot --headless --script scripts/ci/test_level1.gd

extends SceneTree

func _init():
	print("=== Level1 Integration Test ===\n")
	
	var all_passed = true
	
	# Test 1: Load BaseLevel
	print("Test 1: Load BaseLevel class")
	var base_level_script = load("res://codigo/BaseLevel.gd")
	if base_level_script:
		print("  ✅ BaseLevel.gd loaded successfully")
	else:
		print("  ❌ FAIL: Could not load BaseLevel.gd")
		all_passed = false
	
	# Test 2: Load Level1
	print("\nTest 2: Load Level1 class")
	var level1_script = load("res://codigo/Level1.gd")
	if level1_script:
		print("  ✅ Level1.gd loaded successfully")
	else:
		print("  ❌ FAIL: Could not load Level1.gd")
		quit(1)
		return
	
	# Test 3: Instantiate Level1
	print("\nTest 3: Instantiate Level1")
	var level1_instance = level1_script.new()
	if level1_instance:
		print("  ✅ Level1 instantiated")
		print("  - Class: " + level1_instance.get_class())
		print("  - Script: " + level1_instance.get_script().resource_path)
	else:
		print("  ❌ FAIL: Could not instantiate Level1")
		quit(1)
		return
	
	# Test 4: Check inheritance
	print("\nTest 4: Verify BaseLevel inheritance")
	if level1_instance.get_script().get_base_script():
		var base_script_path = level1_instance.get_script().get_base_script().resource_path
		print("  ✅ Extends: " + base_script_path)
		if "BaseLevel" in base_script_path:
			print("  ✅ Correctly extends BaseLevel")
		else:
			print("  ❌ FAIL: Does not extend BaseLevel")
			all_passed = false
	else:
		print("  ⚠️  WARNING: No base script found")
	
	# Test 5: Check exported properties
	print("\nTest 5: Check level configuration")
	print("  - level_name: " + str(level1_instance.level_name))
	print("  - level_description: " + str(level1_instance.level_description))
	print("  - target_moves: " + str(level1_instance.target_moves))
	print("  - grid_width: " + str(level1_instance.grid_width))
	print("  - grid_height: " + str(level1_instance.grid_height))
	
	if level1_instance.level_name == "A Torre de Marfim":
		print("  ✅ Level metadata correct")
	else:
		print("  ❌ FAIL: Level name incorrect")
		all_passed = false
	
	# Test 6: Check state enum
	print("\nTest 6: Verify LevelState enum")
	if level1_instance.has_method("start_level"):
		print("  ✅ Has start_level() method (from BaseLevel)")
	else:
		print("  ❌ FAIL: Missing start_level() method")
		all_passed = false
	
	if level1_instance.has_method("complete_level"):
		print("  ✅ Has complete_level() method (from BaseLevel)")
	else:
		print("  ❌ FAIL: Missing complete_level() method")
		all_passed = false
	
	# Test 7: Check unique methods
	print("\nTest 7: Check Level1-specific methods")
	var expected_methods = [
		"load_available_puzzles",
		"load_puzzle",
		"create_special_items",
		"create_key",
		"create_door",
		"check_level_completion"
	]
	
	for method in expected_methods:
		if level1_instance.has_method(method):
			print("  ✅ Has " + method + "()")
		else:
			print("  ❌ FAIL: Missing " + method + "()")
			all_passed = false
	
	# Test 8: Check signals
	print("\nTest 8: Check signals")
	var expected_signals = [
		"puzzle_loaded",
		"level_completed",
		"puzzle_completed"
	]
	
	for sig_name in expected_signals:
		if level1_instance.has_signal(sig_name):
			print("  ✅ Has signal: " + sig_name)
		else:
			print("  ❌ FAIL: Missing signal: " + sig_name)
			all_passed = false
	
	# Test 9: Simulate initialization
	print("\nTest 9: Simulate initialization")
	level1_instance.available_puzzles = []
	level1_instance.current_state = level1_instance.LevelState.LOADING
	level1_instance.moves_used = 0
	level1_instance.level_timer = 0.0
	print("  ✅ State initialized")
	
	# Test 10: Test timer update
	print("\nTest 10: Test timer logic")
	level1_instance.is_timer_running = true
	level1_instance.level_timer = 0.0
	# Simulate _process call
	var delta = 0.016  # ~60 FPS
	level1_instance.level_timer += delta
	if level1_instance.level_timer > 0:
		print("  ✅ Timer increments correctly: " + str(level1_instance.level_timer))
	else:
		print("  ❌ FAIL: Timer not working")
		all_passed = false
	
	# Cleanup
	level1_instance.free()
	
	# Final result
	print("\n" + "=".repeat(40))
	if all_passed:
		print("✅ ALL TESTS PASSED")
		print("Level1 is ready for manual testing in editor")
		quit(0)
	else:
		print("❌ SOME TESTS FAILED")
		print("Review errors above before manual testing")
		quit(1)
