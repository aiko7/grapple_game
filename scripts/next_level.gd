extends Node2D

@export var next_level_scene: String = "res://levels/level_2.tscn"
@export var current_level_number: int = 1



func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
		
	AudioManager.play_portal()
	
	if current_level_number <= 5:
		if GameManager.has_collected_all():
			ProgressManager.mark_level_perfect(current_level_number)
			ProgressManager.unlock_level(current_level_number + 5)
		
		await get_tree().create_timer(0).timeout
		if current_level_number != 5:
			ProgressManager.unlock_level(current_level_number + 1)
			get_tree().change_scene_to_file(next_level_scene)
			return
	
	if current_level_number == 5:			
		get_tree().change_scene_to_file("res://menu_scenes/victory_menu.tscn")			
		return
	get_tree().change_scene_to_file("res://menu_scenes/level_select.tscn")			
	
		
