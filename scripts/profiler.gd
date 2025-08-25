extends Node
class_name ProfileManager

const SAVE_PATH: String = "user://profiles.save"
var selected_profile: int = SLOT_COUNT
const SLOT_COUNT: int = 3

var profiles: Array[SaveProfile] = []

func _ready() -> void:
	load_profiles()

func get_profiles() -> Array[SaveProfile]:
	return profiles


func save_profiles() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var save_data := []
		for profile in profiles:
			save_data.append(profile.to_dict())

		var full_save := {
			"profiles": save_data,
			"last_option": selected_profile
		}

		file.store_var(full_save)
		file.close()
	else:
		push_error("Failed to save profiles!")

func load_profiles() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_init_empty_slots()
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("Failed to load profiles!")
		_init_empty_slots()
		return

	var data = file.get_var()
	file.close()

	if typeof(data) != TYPE_DICTIONARY:
		push_error("Corrupted profile save file!")
		_init_empty_slots()
		return

	if data.has("profiles") and typeof(data["profiles"]) == TYPE_ARRAY:
		profiles.clear()
		for i in SLOT_COUNT:
			if i < data["profiles"].size() and typeof(data["profiles"][i]) == TYPE_DICTIONARY:
				profiles.append(SaveProfile.from_dict(data["profiles"][i]))
			else:
				profiles.append(SaveProfile.new())
	else:
		_init_empty_slots()

	if data.has("last_option") and typeof(data["last_option"]) == TYPE_INT:
		selected_profile = data["last_option"]
	else:
		selected_profile = SLOT_COUNT


func _init_empty_slots() -> void:
	profiles.clear()
	for i in SLOT_COUNT:
		profiles.append(SaveProfile.new())

func set_selected_profile(opt: int) -> void:
	selected_profile = opt

func get_selected_profile() -> int:
	return selected_profile
