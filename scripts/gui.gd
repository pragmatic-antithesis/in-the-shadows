extends Control

@onready var menu_background: Material = $MenuCanvas/AlphaTint.material;
@onready var title: RichTextLabel = $TitleCanvas/GameTitle

const MAX_OFFSET := 18.0

func _ready() -> void:
	var button: MenuButton = $MenuCanvas/Menu/MenuButton
	button.pressed.connect(_on_start_button_pressed);
	menu_background.set_shader_parameter("aspect_ratio", size.y / size.x)

func _on_start_button_pressed() -> void:
	for child in get_children():
		child.hide()
	hide()

func _on_alpha_tint_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var uv_mouse: Vector2 = get_local_mouse_position() / size
		menu_background.set_shader_parameter("u_mouse", uv_mouse)
		var dir: Vector2 = (uv_mouse - Vector2(0.5, 0.5)) * 2.0
		title.add_theme_constant_override("shadow_offset_x", int(dir.x * MAX_OFFSET))
		title.add_theme_constant_override("shadow_offset_y", int(dir.y * MAX_OFFSET))
