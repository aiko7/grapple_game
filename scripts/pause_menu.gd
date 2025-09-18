extends Panel

@onready var resume_button = $ResumeButton
@onready var settings_button = $SettingsButton
@onready var level_selector_button = $LevelSelectorButton
@onready var quit_button = $QuitButton

func _ready():
	resume_button.pressed.connect(_on_resume_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	level_selector_button.pressed.connect(_on_level_selector_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_resume_pressed():
	get_tree().paused = false
	hide()


func _on_settings_pressed():
	# Option A: change scene
	# get_tree().change_scene_to_file("res://scenes/SettingsMenu.tscn")
	#
	# Option B: show a hidden settings menu already in scene
	hide()
	get_parent().get_node("SettingsMenu").show()
	
	#get_tree().change_scene_to_file("res://settingsmenu.tscn")
	#_on_resume_pressed()


func _on_level_selector_pressed():
	# Same idea: either load scene or show overlay
	get_tree().change_scene_to_file("res://level_select.tscn")
	_on_resume_pressed()
	
func _on_quit_pressed():
	get_tree().quit()
