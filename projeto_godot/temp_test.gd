extends Node
class_name ErrorChecker

func _ready():
var checker = preload('res://scripts/ErrorChecker.gd').new()
var results = checker.check_all_errors()
checker.print_results(results)

