extends CanvasLayer
class_name UIManager

@onready var star_label = $StarContainer/StarLabel

func _ready():
	layer = 10

func update_star_count(collected: int, total: int):
	if star_label:
		star_label.text = str(collected) + " / " + str(total)
		print("UI Updated: ", collected, "/", total)
	else:
		print("StarLabel node not found! Check the path: $StarContainer/StarLabel")
