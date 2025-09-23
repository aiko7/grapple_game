extends Node

signal star_count_changed(collected: int, total: int)

var current_level_number: int = 0
var stars_collected: int = 0
var total_stars_in_level: int = 0
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

# start_level optionally receives level_number
# IMPORTANT: we do NOT zero out total_stars_in_level here if stars have already registered themselves
func start_level(level_number: int = 0) -> void:
	# optional level number; if passed, store it
	if level_number > 0:
		current_level_number = level_number

	if not ui_manager:
		ui_manager = get_tree().get_first_node_in_group("ui")
		if not ui_manager:
			print("Warning: UIManager not found in 'ui' group!")

	# reset collected count for the new run
	stars_collected = 0

	# reset total so we don't accumulate across runs
	total_stars_in_level = 0

	# wait one frame so the level's nodes (stars) finish _ready / are instanced
	await get_tree().process_frame

	# now count stars in the group exactly once
	count_total_stars()
	_update_ui()


# Backward-compatible registration function for stars that call this in their _ready()
func register_star() -> void:
	# Increment total (used when stars register themselves). This is tolerant:
	# if you also use group counting, start_level will prefer already-registered value.
	total_stars_in_level += 1
	_update_ui()

func collect_star() -> void:
	stars_collected += 1
	print("Star collected! Total: ", stars_collected)
	_update_ui()

func get_collected() -> int:
	return stars_collected

func get_total() -> int:
	return total_stars_in_level

func has_collected_all() -> bool:
	# only counts as "all" if there was at least one star and we collected them all
	return total_stars_in_level > 0 and stars_collected == total_stars_in_level

# kept for compatibility with other code
func update_star_display():
	_update_ui()

func _update_ui() -> void:
	# emit signal for any listeners, and also call UI directly if present
	emit_signal("star_count_changed", stars_collected, total_stars_in_level)
	if ui_manager:
		ui_manager.update_star_count(stars_collected, total_stars_in_level)
	else:
		# helpful debug print
		print("UI Manager not found when updating stars. Collected:", stars_collected, " Total:", total_stars_in_level)

func count_total_stars() -> void:
	# count star nodes in group "Star"
	var group_count = get_tree().get_nodes_in_group("Star").size()
	# overwrite total every time (no indefinite growth)
	total_stars_in_level = group_count
	print("Total stars in level: ", total_stars_in_level)
	_update_ui()


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
