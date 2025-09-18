extends CanvasLayer

@onready var resume_button = $Panel/ResumeButton
@onready var settings_button = $Panel/SettingsButton
@onready var level_selector_button = $Panel/LevelSelectorButton
@onready var quit_button = $Panel/QuitButton
func _ready():
	resume_button.pressed.connect(_on_resume_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	level_selector_button.pressed.connect(_on_level_selector_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_resume_pressed():
	get_tree().paused = false
	visible = false

func _on_settings_pressed():
	# Option A: change scene
	# get_tree().change_scene_to_file("res://scenes/SettingsMenu.tscn")
	#
	# Option B: show a hidden settings menu already in scene
	get_tree().change_scene_to_file("res://settingsmenu.tscn")
	_on_resume_pressed()


func _on_level_selector_pressed():
	# Same idea: either load scene or show overlay
	get_tree().change_scene_to_file("res://level_select.tscn")
	_on_resume_pressed()
	
func _on_quit_pressed():
	get_tree().quit()
