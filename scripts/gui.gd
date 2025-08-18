extends Control

@onready var menu_background: Material = $Canvas/AlphaTint.material;
@onready var title: RichTextLabel = $GameTitle
# tweak these numbers to taste
const MAX_OFFSET := 12.0
const MAX_DARKEN := 0.6

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
		# make it relative to center
		var dir = (uv_mouse - Vector2(0.5, 0.5)) * 2.0  # (-1..1)

		# affect drop shadow
		title.add_theme_constant_override("shadow_offset_x", dir.x * MAX_OFFSET)
		title.add_theme_constant_override("shadow_offset_y", dir.y * MAX_OFFSET)

		# fade text (fake darkening when “light” is far)
		var s = clamp(dir.length(), 0.0, 1.0)
		var m = 1.0 - s * MAX_DARKEN
		title.modulate = Color(m, m, m, 1.0)
