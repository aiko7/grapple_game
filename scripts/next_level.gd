extends Node2D

@export var next_level_scene: String = "res://levels/level_2.tscn"  
@export var current_level_number: int = 1  

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ProgressManager.unlock_level(current_level_number + 1)
		
		await get_tree().create_timer(0).timeout
		get_tree().change_scene_to_file(next_level_scene)
