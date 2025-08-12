extends Node3D

#TeaPot 1, -179 0
#Elephanto 84 -0.5 -175.8

const move_speed: float = 0.01

func _input(event: InputEvent) -> void:
	var puzzle_piece: MeshInstance3D = get_child(0)

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if Input.is_action_pressed("grab_control"):
			Input.set_default_cursor_shape(Input.CURSOR_VSIZE)
			if event is InputEventMouseMotion:
				puzzle_piece.rotate_object_local(Vector3.RIGHT, deg_to_rad(event.relative.y))
		else:
			Input.set_default_cursor_shape(Input.CURSOR_HSIZE)
			if event is InputEventMouseMotion:
				puzzle_piece.rotate_object_local(Vector3.UP, deg_to_rad(event.relative.x))
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if Input.is_action_pressed("grab_control"):
			Input.set_default_cursor_shape(Input.CURSOR_DRAG)
			if event is InputEventMouseMotion:
				puzzle_piece.global_translate((-event.relative.x * Vector3(1, 0, 0) + -event.relative.y * Vector3(0, 1, 0)) * move_speed)
		else:
			Input.set_default_cursor_shape(Input.CURSOR_FDIAGSIZE)
			if event is InputEventMouseMotion:
				puzzle_piece.rotate_object_local(Vector3.BACK, deg_to_rad(event.relative.x))
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	if event is InputEventMouseButton and not event.pressed:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		puzzle_piece.check_piece_solution()
