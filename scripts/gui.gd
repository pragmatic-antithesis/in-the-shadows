extends Control

@onready var menu_background: Material = $Canvas/AlphaTint.material;
@onready var title: RichTextLabel = $GameTitle
# tweak these numbers to taste
const MAX_OFFSET := 24.0

func _ready() -> void:
	var button: MenuButton = $Canvas/Menu/MenuButton
	button.pressed.connect(_on_start_button_pressed);
	menu_background.set_shader_parameter("aspect_ratio", size.y / size.x)

func _on_start_button_pressed() -> void:
	var basecolor = menu_background.get_shader_parameter("base_color")
	print(basecolor)
	menu_background.set_shader_parameter("base_color", Vector4(0.0, 0.0, 0.0, 0.0))
	hide()

func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var uv_mouse: Vector2 = get_local_mouse_position() / size
		menu_background.set_shader_parameter("u_mouse", uv_mouse)
		var dir: Vector2 = (uv_mouse - Vector2(0.5, 0.5)) * 2.0
		title.add_theme_constant_override("shadow_offset_x", dir.x * MAX_OFFSET)
		title.add_theme_constant_override("shadow_offset_y", dir.y * MAX_OFFSET)
