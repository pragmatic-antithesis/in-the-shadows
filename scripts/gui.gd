extends Control

@onready var menu_background: Material = $MenuCanvas/AlphaTint.material

const MAX_OFFSET: float = 18.0
var display_title: bool = true

func _ready() -> void:
	var button: MenuButton = $MenuCanvas/Menu/MenuButton
	button.pressed.connect(_on_start_button_pressed)
	button.hide()
	menu_background.set_shader_parameter("aspect_ratio", size.y / size.x)

func _on_start_button_pressed() -> void:
	for child in get_children():
		child.hide()
	hide()

func _on_alpha_tint_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var uv_mouse: Vector2 = get_local_mouse_position() / size
		menu_background.set_shader_parameter("u_mouse", uv_mouse)
		if display_title:
			_cast_shadow_on_title(uv_mouse)

func _on_start_game_pressed() -> void:
	display_title = false
	for child in $TitleCanvas.get_children():
		child.queue_free()
	$TitleCanvas.queue_free()
	$MenuCanvas/StartGame.queue_free()
	$MenuCanvas/Menu/MenuButton.show()
	menu_background.set_shader_parameter("disable_darkening", false)

func _cast_shadow_on_title(uv_mouse: Vector2) -> void:
	var dir: Vector2 = (uv_mouse - Vector2(0.5, 0.5)) * 2.0
	$TitleCanvas/GameTitle.add_theme_constant_override("shadow_offset_x", int(-dir.x * MAX_OFFSET))
	$TitleCanvas/GameTitle.add_theme_constant_override("shadow_offset_y", int(-dir.y * MAX_OFFSET))
	$TitleCanvas/TitleScreen.material.set_shader_parameter("mouse_pos", uv_mouse)
