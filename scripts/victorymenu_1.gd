extends Panel

@onready var back_button = $"Level Selector"

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	

func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu_scenes/level_select.tscn")
	
