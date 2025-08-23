extends Node
class_name ProfileManager

const SAVE_PATH: String = "user://profiles.save"
const SLOT_COUNT: int = 3

var profiles: Array[SaveProfile] = []

func _ready() -> void:
	_init_slots()
	load_profiles()

func _init_slots() -> void:
	profiles.clear()
	for i in SLOT_COUNT:
		profiles.append(SaveProfile.new())

func get_profiles() -> Array[SaveProfile]:
	return profiles

func save_profiles() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(profiles)
		file.close()
	else:
		push_error("Failed to save profiles!")

func load_profiles() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("Failed to load profiles!")
		return

	var data = file.get_var()
	if typeof(data) != TYPE_ARRAY:
		push_error("Corrupted profile save file!")
	else:
		_init_slots()
		for i in min(SLOT_COUNT, data.size()):
			var slot = data[i]
			if typeof(slot) == TYPE_DICTIONARY:
				profiles[i].player_name = slot.get("player_name", "")
				profiles[i].puzzles_unlocked = slot.get("puzzles_unlocked", 0)
	file.close()
