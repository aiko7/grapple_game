extends Node

var stars_collected = 0
var total_stars_in_level = 0
var ui_manager: UIManager

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
