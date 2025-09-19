extends Node

var unlocked_levels: Array[bool] = []
var perfect_completions: Array[bool] = []  # true if level was finished with all stars
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

# mark that level was completed with all stars
func mark_level_perfect(level: int) -> void:
	if level >= 1 and level <= perfect_completions.size():
		perfect_completions[level - 1] = true
		save_progress()

func is_level_perfect(level: int) -> bool:
	if level >= 1 and level <= perfect_completions.size():
		return perfect_completions[level - 1]
	return false

# check if all levels in [start, end] (inclusive) are perfect
func all_levels_perfect(start_level: int, end_level: int) -> bool:
	if start_level < 1:
		start_level = 1
	if end_level > perfect_completions.size():
		end_level = perfect_completions.size()
	for i in range(start_level - 1, end_level):
		if not perfect_completions[i]:
			return false
	return true

func save_progress():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		var save_data = {
			"unlocked_levels": unlocked_levels,
			"perfect_completions": perfect_completions
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
					var loaded_levels = save_data["unlocked_levels"]
					unlocked_levels = []
					for level in loaded_levels:
						unlocked_levels.append(bool(level))
				else:
					initialize_default_progress()

				# load perfect completions if present
				if save_data.has("perfect_completions"):
					var loaded_perfect = save_data["perfect_completions"]
					perfect_completions = []
					for p in loaded_perfect:
						perfect_completions.append(bool(p))
				else:
					# if missing, ensure same length as unlocked_levels
					perfect_completions = []
					for i in range(unlocked_levels.size()):
						perfect_completions.append(false)
				print("Progress loaded!")
			else:
				initialize_default_progress()
	else:
		initialize_default_progress()

func initialize_default_progress():
	unlocked_levels = []
	perfect_completions = []
	for i in range(10):
		unlocked_levels.append(i == 0)  # level 1 unlocked by default
		perfect_completions.append(false)
	print("Default progress initialized")
	
func reset_progress() -> void:
	initialize_default_progress()  # re-create unlocked_levels and perfect_completions defaults
	save_progress()
	print("ProgressManager: progress reset to defaults and saved.")
