extends Control

@onready var menu_background: Material = $ColorRect.material;

func _ready() -> void:
	var button: MenuButton = $Menu/MenuButton
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
