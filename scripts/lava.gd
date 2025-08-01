extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Something touched the lava: ", body)
	if body.is_in_group("player"):
		body.die()
