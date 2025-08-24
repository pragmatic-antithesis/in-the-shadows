extends Control

signal profile_chosen(profile: SaveProfile)

@onready var save_canvas: CanvasLayer = $SaveCanvas
@onready var save_menu_background: Panel = $SaveCanvas/BorderContainer/SaveMenuBackground
@onready var line_edit: LineEdit = $SaveCanvas/BorderContainer/SaveMenuBackground/VBoxContainer/LineEdit
@onready var level_status: Label = $SaveCanvas/BorderContainer/SaveMenuBackground/VBoxContainer/LevelStatus
@onready var slot_name: Array[Label] = [
	$SaveCanvas/BorderContainer/SaveMenuBackground/VBoxContainer/Slot1/SlotName,
	$SaveCanvas/BorderContainer/SaveMenuBackground/VBoxContainer/Slot2/SlotName,
	$SaveCanvas/BorderContainer/SaveMenuBackground/VBoxContainer/Slot3/SlotName,
	$SaveCanvas/BorderContainer/SaveMenuBackground/VBoxContainer/Slot4/SlotName,	
]

var slots: Array[SaveProfile]
var unsaved_profile: SaveProfile
@export var current_profile: int = Profiler.SLOT_COUNT

func update_progress(new_level: int) -> void:
	if current_profile < Profiler.SLOT_COUNT:
		slots[current_profile].puzzles_unlocked = new_level
	else:
		unsaved_profile.puzzles_unlocked = new_level
	_refresh_slot_display()
	Profiler.save_profiles()

func _ready() -> void:
	slots = Profiler.get_profiles()
	_reset_unsaved_profile()
	_refresh_slot_display()

func get_slot() -> SaveProfile:
	if current_profile < Profiler.SLOT_COUNT:
		return slots[current_profile]
	return unsaved_profile

func show_ui() -> void:
	_refresh_slot_display()
	save_canvas.show()

func _reset_unsaved_profile() -> void:
	unsaved_profile = SaveProfile.new()
	unsaved_profile.player_name = "New Player"
	unsaved_profile.puzzles_unlocked = 1

func _refresh_slot_display() -> void:
	var level_display: int
	if current_profile < Profiler.SLOT_COUNT:
		level_display = slots[current_profile].puzzles_unlocked
	else:
		level_display = unsaved_profile.puzzles_unlocked
	for i in slots.size():
		slot_name[i].text = slots[i].player_name if slots[i].player_name else "void"
	slot_name[Profiler.SLOT_COUNT].text = unsaved_profile.player_name if unsaved_profile.player_name else "void"
	var display_text: String = str(level_display) if level_display else " -"
	level_status.text = "Available puzzles:  " + display_text

func _on_check_button_toggled(_toggled_on: bool, vector_y: float, slot: int) -> void:
	current_profile = slot
	save_menu_background.material.set_shader_parameter("mouse_pos", Vector2(0.5, vector_y))
	_refresh_slot_display()

func _on_line_edit_text_submitted(new_text: String) -> void:
	line_edit.clear()
	if current_profile < Profiler.SLOT_COUNT:
		slots[current_profile].player_name = new_text
	else:
		unsaved_profile.player_name = new_text
	_refresh_slot_display()

func _on_delete_profile_pressed() -> void:
	if current_profile == Profiler.SLOT_COUNT:
		_reset_unsaved_profile()
	else:
		slots[current_profile] = SaveProfile.new()
		Profiler.save_profiles()
	_refresh_slot_display()

func _on_select_profile_pressed() -> void:
	if line_edit.text:
		line_edit.text_submitted.emit(line_edit.text)
	var profile_reference: SaveProfile = get_slot()
	if !profile_reference.player_name:
		profile_reference.player_name = "Unnamed One"
	if !profile_reference.puzzles_unlocked:
		profile_reference.puzzles_unlocked = 1
	Profiler.save_profiles()
	emit_signal("profile_chosen", profile_reference)
	save_canvas.hide()
	hide()
