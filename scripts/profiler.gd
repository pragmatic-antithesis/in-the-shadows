extends Node
class_name ProfileManager

const SAVE_PATH: String = "user://profiles.save"
const SLOT_COUNT: int = 3

var profiles: Array[SaveProfile] = []

func _ready() -> void:
	load_profiles()  # This will initialize slots if needed

func get_profiles() -> Array[SaveProfile]:
	return profiles

func save_profiles() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		# Convert all profiles to dictionaries for serialization
		var save_data := []
		for profile in profiles:
			save_data.append(profile.to_dict())
		file.store_var(save_data)
		file.close()
	else:
		push_error("Failed to save profiles!")

func load_profiles() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		# Initialize empty slots if no save file exists
		_init_empty_slots()
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("Failed to load profiles!")
		_init_empty_slots()
		return

	var data = file.get_var()
	file.close()
	
	if typeof(data) != TYPE_ARRAY:
		push_error("Corrupted profile save file!")
		_init_empty_slots()
		return
	
	# Clear and rebuild from save data
	profiles.clear()
	for i in SLOT_COUNT:
		if i < data.size() and typeof(data[i]) == TYPE_DICTIONARY:
			# Use from_dict to create SaveProfile instances
			profiles.append(SaveProfile.from_dict(data[i]))
		else:
			# Add empty profile if no data for this slot
			profiles.append(SaveProfile.new())

func _init_empty_slots() -> void:
	profiles.clear()
	for i in SLOT_COUNT:
		profiles.append(SaveProfile.new())

func _print_profiles():
	for i in range(0, 3):
		print("name: ", profiles[i].player_name)
