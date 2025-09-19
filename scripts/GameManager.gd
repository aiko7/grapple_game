extends Node

var stars_collected = 0
var total_stars_in_level = 0
var ui_manager: UIManager

var pause_menu_scene = preload("res://menu_scenes/Menus.tscn")
var pause_menu
var pause_panel

var settings_panel
var info_panel

func _ready():
	
	pause_menu = pause_menu_scene.instantiate()
	add_child(pause_menu)
	pause_panel = pause_menu.get_node("PauseMenu")

	settings_panel = pause_menu.get_node("SettingsMenu")		
	info_panel = pause_menu.get_node("InfoMenu")
	
	info_panel.hide()
	settings_panel.hide()
	pause_panel.hide()
	

	
func start_level():
	if not ui_manager:
		ui_manager = get_tree().get_first_node_in_group("ui")
		if not ui_manager:
			print("Warning: UIManager not found in 'ui' group!")
			return
	
	stars_collected = 0
	count_total_stars()
	update_star_display()

func collect_star():
	stars_collected += 1
	print("Star collected! Total: ", stars_collected)
	update_star_display()

func update_star_display():
	if ui_manager:
		ui_manager.update_star_count(stars_collected, total_stars_in_level)
	else:
		print("UI Manager not found!")

func count_total_stars():
	print(get_tree())
	
	total_stars_in_level = get_tree().get_nodes_in_group("Star").size()
	print("Total stars in level: ", total_stars_in_level)

func _process(delta):
	if Input.is_action_just_pressed("open_level_selector"):
		get_tree().change_scene_to_file("res://menu_scenes/level_select.tscn")

	if Input.is_action_just_pressed("open_pause_menu"):
		
		
		if info_panel.visible:
			info_panel.hide()
			pause_panel.hide()
			get_tree().paused = false
			
		elif settings_panel.visible:
			settings_panel.hide()
			pause_panel.hide()
			get_tree().paused = false

		elif get_tree().paused:
			get_tree().paused = false
			pause_panel.hide()

		else:
			get_tree().paused = true
			pause_panel.show()
