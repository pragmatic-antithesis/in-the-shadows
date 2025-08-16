extends Control


func _ready() -> void:
	var button: MenuButton = $Menu/MenuButton
	button.pressed.connect(_on_start_button_pressed);
	$ColorRect.material.set_shader_parameter("aspect_ratio", size.y / size.x)

func _on_start_button_pressed() -> void:
	var basecolor = $ColorRect.material.get_shader_parameter("base_color")
	print(basecolor)
	$ColorRect.material.set_shader_parameter("base_color", Vector4(0.0, 0.0, 0.0, 0.0))

func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var uv_mouse: Vector2 = get_local_mouse_position() / size
		$ColorRect.material.set_shader_parameter("u_mouse", uv_mouse)
