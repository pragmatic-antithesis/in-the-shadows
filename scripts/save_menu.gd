extends Control

var slots: Array[SaveProfile]
var unsaved_profile: SaveProfile
@export var current_profile: int = Profiler.SLOT_COUNT

func update_progress(new_level: int) -> void:
	if current_profile < Profiler.SLOT_COUNT:
		slots[current_profile].puzzles_unlocked = new_level
	else:
		unsaved_profile.puzzles_unlocked = new_level

	refresh_slot_display()

func _ready() -> void:
	slots = Profiler.get_profiles()
	_reset_unsaved_profile()
	refresh_slot_display()

func get_slot() -> SaveProfile:
	if current_profile < Profiler.SLOT_COUNT:
		return slots[current_profile]
	return unsaved_profile

func _create_profile(slot: int, player_name: String) -> SaveProfile:
	if slot < 0 or slot >= Profiler.SLOT_COUNT:
		_reset_unsaved_profile()
		unsaved_profile.player_name = player_name
		return unsaved_profile

	slots[slot].player_name = player_name
	slots[slot].puzzles_unlocked = 1
	
	Profiler.save_profiles()
	refresh_slot_display()
	return slots[slot]

func _delete_profile(slot: int) -> void:
	slots[slot] = SaveProfile.new()
	Profiler.save_profiles()
	refresh_slot_display()

func _reset_unsaved_profile() -> void:
	unsaved_profile = SaveProfile.new()
	unsaved_profile.player_name = "New Player"
	unsaved_profile.puzzles_unlocked = 1


func refresh_slot_display() -> void:
	for i in slots.size():
		if slots[i].is_empty():
			print("Slot ", i, " is free.")
		else:
			print("Slot ", i, ":", slots[i].player_name, " has ", slots[i].puzzles_unlocked, " puzzles")
	print (unsaved_profile.player_name, " ", unsaved_profile.puzzles_unlocked)
