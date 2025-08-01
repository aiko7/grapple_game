extends Node

var unlocked_levels: Array[bool] = []
const SAVE_FILE = "user://progress.dat"

func _ready():
	load_progress()
	
	
func _exit_tree():
	save_progress()

func unlock_level(level: int) -> void:
	if level >= 1 and level <= unlocked_levels.size():
		unlocked_levels[level - 1] = true
		save_progress()  

func is_level_unlocked(level: int) -> bool:
	if level >= 1 and level <= unlocked_levels.size():
		return unlocked_levels[level - 1]
	return false

func save_progress():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		var save_data = {
			"unlocked_levels": unlocked_levels
		}
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Progress saved!")  

func load_progress():
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			
			if parse_result == OK:
				var save_data = json.data
				if save_data.has("unlocked_levels"):
					# Convert the generic array to Array[bool]
					var loaded_levels = save_data["unlocked_levels"]
					unlocked_levels = []
					for level in loaded_levels:
						unlocked_levels.append(bool(level))
					print("Progress loaded!")  
				else:
					initialize_default_progress()
			else:
				initialize_default_progress()
	else:
		initialize_default_progress()

func initialize_default_progress():
	unlocked_levels = []
	for i in range(10):
		unlocked_levels.append(i == 0)  
	print("Default progress initialized")  
