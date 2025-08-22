extends Control

@onready var puzzle_interface: Node3D = %PuzzleInterface
@onready var current_scene: Node = null

#Menu Canvas#
@onready var alpha_tint: ColorRect = $MenuCanvas/AlphaTint
@onready var menu_background: Material = $MenuCanvas/AlphaTint.material

#Title Canvas#
const MAX_OFFSET: float = 18.0
@onready var title_canvas: CanvasLayer = $MenuCanvas/TitleCanvas
@onready var title_screen: ColorRect = $MenuCanvas/TitleCanvas/TitleScreen
@onready var game_title: RichTextLabel = $MenuCanvas/TitleCanvas/GameTitle

#Puzzle Complete#
@onready var puzzle_complete: CanvasLayer = $MenuCanvas/PuzzleComplete
@onready var congrats_message: Label = $MenuCanvas/PuzzleComplete/Message

#Buttons#
enum StartOption{ CONTINUE, NEW, TEST }
const MENU_START_SHADER_ALPHA: Vector2 = Vector2(0.085, 0.18)
const MAX_LEVEL: int = 4
@onready var start_menu: VBoxContainer = $MenuCanvas/Buttons/StartMenu
@onready var level_select: VBoxContainer = $MenuCanvas/Buttons/LevelSelect
@onready var call_menu: Button = $MenuCanvas/Buttons/CallMenu

func _ready() -> void:
	AudioPlayer.play_music("menu", 2.0)
	menu_background.set_shader_parameter("aspect_ratio", size.y / size.x)

func _on_menu_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var uv_mouse: Vector2 = get_local_mouse_position() / size
		menu_background.set_shader_parameter("u_mouse", uv_mouse)

#Puzzle interface
func _load_scene(scene_path: String) -> void:
	if current_scene:
		current_scene.queue_free()
	var scene: PackedScene = load(scene_path)
	if scene:
		current_scene = scene.instantiate()
		if current_scene is BasePuzzle:
			current_scene.puzzle_solved.connect(_on_puzzle_solved)
			puzzle_interface.add_child(current_scene)
		else:
			push_error("Loaded scene is not a Base Puzzle")
	else:
		push_error("Scene not found: %s" % scene_path)

#Buttons
func _on_start_menu_pressed(option: int) -> void:
	var levels: int = 0
	match option:
		StartOption.CONTINUE:
			levels = 2
		StartOption.NEW:
			levels = 1
		StartOption.TEST:
			levels = MAX_LEVEL

	start_menu.hide()
	level_select.show()
	for i in range(min(levels, MAX_LEVEL)):
		var button = level_select.get_child(i)
		if button is BaseButton:
			button.disabled = false
	menu_background.set_shader_parameter("rect_size", Vector2(0.085, 0.24))

func _on_level_select_pressed(scene_path: String) -> void:
	if not current_scene or current_scene.scene_file_path != scene_path:
		_load_scene(scene_path)
	call_menu.show()
	level_select.hide()
	alpha_tint.hide()
	menu_background.set_shader_parameter("disable_darkening", true)

func _on_call_menu_pressed() -> void:
	call_menu.hide()
	level_select.show()
	alpha_tint.show()
	menu_background.set_shader_parameter("disable_darkening", false)

func _on_start_game_pressed() -> void:
	AudioPlayer.play_music("selection")
	for child in title_canvas.get_children():
		child.queue_free()
	title_canvas.queue_free()

func _on_back_to_menu_pressed() -> void:
	AudioPlayer.play_music("selection")
	start_menu.show()
	level_select.hide()
	menu_background.set_shader_parameter("rect_size", Vector2(0.085, 0.24))

func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()

#Title Canvas
func _on_game_title_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var uv_mouse: Vector2 = get_local_mouse_position() / size
		var dir: Vector2 = (uv_mouse - Vector2(0.5, 0.5)) * 2.0
		game_title.add_theme_constant_override("shadow_offset_x", int(-dir.x * MAX_OFFSET))
		game_title.add_theme_constant_override("shadow_offset_y", int(-dir.y * MAX_OFFSET))
		title_screen.material.set_shader_parameter("mouse_pos", uv_mouse)

func _on_puzzle_solved() -> void:
	puzzle_complete.show()
	_start_pulsing()

func _start_pulsing(outline_size: float = 4.0, pulse_speed: float = 1.0):

	var tween = create_tween()
	tween.set_loops()  # Loop forever

	# Pulse between minimum and maximum outline size
	tween.tween_method(_pulse_outline, 1.0, outline_size, pulse_speed)
	tween.tween_method(_pulse_outline, outline_size, 1.0, pulse_speed)

func _pulse_outline(size: float):
	congrats_message.add_theme_constant_override("outline_size", int(size))
# Optional: Also pulse outline color intensity
	congrats_message.add_theme_color_override("font_outline_color", Color(1, 1, 1, size / 4.0))
