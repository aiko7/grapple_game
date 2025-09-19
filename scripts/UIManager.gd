extends CanvasLayer
class_name UIManager

var star_label

func _ready():
	star_label = get_node_or_null("StarContainer/StarLabel")
	# Connect to GameManager's signal if GameManager exists (autoload)
	if typeof(GameManager) != TYPE_NIL:
		GameManager.connect("star_count_changed", Callable(self, "update_star_count"))

func update_star_count(collected: int, total: int):
	star_label = get_node_or_null("StarContainer/StarLabel")
	if star_label:
		star_label.text = str(collected) + " / " + str(total)
		print("UI Updated: ", collected, "/", total)
	else:
		print("StarLabel node not found! Check the path: $StarContainer/StarLabel")
