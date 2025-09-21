extends Node2D

@export var next_level_scene: String = "res://levels/level_2.tscn"
@export var current_level_number: int = 1



func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	AudioManager.play_portal()
	
	# If player reached the exit of levels 1..5 and had all stars this run,
	# mark the level "perfect" and unlock the corresponding +5 level (1->6, 2->7, ...).
	if current_level_number >= 1 and current_level_number < 5:
		if GameManager.has_collected_all():
			ProgressManager.mark_level_perfect(current_level_number)
			# Unlock level N+5 (ProgressManager.unlock_level() internally bounds-checks)
			ProgressManager.unlock_level(current_level_number + 5)

	# Keep original behavior for linear progression: unlock next level (1->2, 2->3, etc.)
	# If you do NOT want this, remove the block below.
	if current_level_number < 5:
		ProgressManager.unlock_level(current_level_number + 1)

	if current_level_number == 5 :
			if GameManager.has_collected_all():
				ProgressManager.mark_level_perfect(current_level_number)
			
				ProgressManager.unlock_level(current_level_number + 5)
		
			get_tree().change_scene_to_file("res://menu_scenes/victorymenu1.tscn")
			

	if current_level_number >5:
		get_tree().change_scene_to_file("res://menu_scenes/level_select.tscn")
		
	# small delay (keeps your original await)
	elif current_level_number<5:
		await get_tree().create_timer(0).timeout
		get_tree().change_scene_to_file(next_level_scene)
