extends Control

func _ready():
	var grid = $VBoxContainer/GridContainer
	for i in range(1, 11):
		var button = grid.get_child(i - 1)
		button.text = "Level %d" % i
		button.disabled = not ProgressManager.is_level_unlocked(i)
		button.pressed.connect(_on_level_pressed.bind(i))

func _on_level_pressed(level_number: int):
	var path = "res://levels/level_%d.tscn" % level_number
	get_tree().change_scene_to_file(path)
