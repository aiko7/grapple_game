extends Control

func _ready():
	var resetButton = $ResetButton
	resetButton.pressed.connect(_on_reset_pressed)
	
	var grid = $VBoxContainer/GridContainer
	for i in range(1, 11):
		var button = grid.get_child(i - 1)
		#button.text = "%d" % i
		button.disabled = not ProgressManager.is_level_unlocked(i)
		button.pressed.connect(_on_level_pressed.bind(i))

func _on_level_pressed(level_number: int):
	var path = "res://levels/level_%d.tscn" % level_number
	get_tree().change_scene_to_file(path)

func _on_reset_pressed():
	ProgressManager.reset_progress()
	var a = "res://levels/level_1.tscn"
	get_tree().change_scene_to_file(a)	
