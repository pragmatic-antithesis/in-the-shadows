extends Control

#Menu Canvas#
@onready var menu_background: Material = $MenuCanvas/AlphaTint.material

#Title Canvas#
const MAX_OFFSET: float = 18.0
@onready var title_canvas: CanvasLayer = $MenuCanvas/TitleCanvas
@onready var title_screen: ColorRect = $MenuCanvas/TitleCanvas/TitleScreen
@onready var game_title: RichTextLabel = $MenuCanvas/TitleCanvas/GameTitle

#Buttons#
enum StartOption{ CONTINUE, NEW, TEST }
const MENU_START_SHADER_ALPHA: Vector2 = Vector2(0.085, 0.18)
const MAX_LEVEL: int = 4
@onready var start_menu: VBoxContainer = $MenuCanvas/Buttons/StartMenu
@onready var level_select: VBoxContainer = $MenuCanvas/Buttons/LevelSelect

func _ready() -> void:
	menu_background.set_shader_parameter("aspect_ratio", size.y / size.x)

func _on_menu_button_pressed() -> void:
	for child in get_children():
		child.hide()
	hide()

func _on_menu_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var uv_mouse: Vector2 = get_local_mouse_position() / size
		menu_background.set_shader_parameter("u_mouse", uv_mouse)


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

func _on_level_select_pressed(levels: int) -> void:
	for i in range(min(levels, MAX_LEVEL)):
		var button = level_select.get_child(i)
		if button is BaseButton:
			button.disabled = false

#Title Canvas
func _on_start_game_pressed() -> void:
	for child in title_canvas.get_children():
		child.queue_free()
	title_canvas.queue_free()
	menu_background.set_shader_parameter("disable_darkening", false)

func _on_game_title_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		print("pog")
		var uv_mouse: Vector2 = get_local_mouse_position() / size
		var dir: Vector2 = (uv_mouse - Vector2(0.5, 0.5)) * 2.0
		game_title.add_theme_constant_override("shadow_offset_x", int(-dir.x * MAX_OFFSET))
		game_title.add_theme_constant_override("shadow_offset_y", int(-dir.y * MAX_OFFSET))
		title_screen.material.set_shader_parameter("mouse_pos", uv_mouse)
