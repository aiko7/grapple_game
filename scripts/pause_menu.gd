extends Panel

@onready var resume_button = $ResumeButton
@onready var settings_button = $SettingsButton
@onready var level_selector_button = $LevelSelectorButton
@onready var info_button = $InfoButton
@onready var quit_button = $QuitButton

func _ready():
	resume_button.pressed.connect(_on_resume_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	level_selector_button.pressed.connect(_on_level_selector_pressed)
	info_button.pressed.connect(_on_info_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_resume_pressed():
	get_tree().paused = false
	hide()


func _on_settings_pressed():

	hide()
	get_parent().get_node("SettingsMenu").show()
	
	#get_tree().change_scene_to_file("res://settingsmenu.tscn")
	#_on_resume_pressed()


func _on_level_selector_pressed():
	# Same idea: either load scene or show overlay
	get_tree().change_scene_to_file("res://menu_scenes/level_select.tscn")
	_on_resume_pressed()
	
	
func _on_info_pressed():
	hide()
	get_parent().get_node("InfoMenu").show()
		
	
	
func _on_quit_pressed():
	get_tree().quit()
