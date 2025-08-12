extends Node3D

#TeaPot 1, -179 0
#Elephanto 84 -0.5 -175.8

func _input(event: InputEvent) -> void:

	var puzzle_piece: MeshInstance3D = get_child(0)
	
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if Input.is_action_pressed("grab_control"):
				Input.set_default_cursor_shape(Input.CURSOR_VSIZE)
				puzzle_piece.rotate_object_local(Vector3.RIGHT, deg_to_rad(event.relative.y))
			else:
				Input.set_default_cursor_shape(Input.CURSOR_HSIZE)
				puzzle_piece.rotate_object_local(Vector3.UP, deg_to_rad(event.relative.x))
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			if Input.is_action_pressed("grab_control"):
				Input.set_default_cursor_shape(Input.CURSOR_DRAG)
				var move_speed: float = 0.01
				puzzle_piece.global_translate((-event.relative.x * Vector3(1, 0, 0) + -event.relative.y * Vector3(0, 1, 0)) * move_speed)
			else:
				Input.set_default_cursor_shape(Input.CURSOR_FDIAGSIZE)
				puzzle_piece.rotate_object_local(Vector3.BACK, deg_to_rad(event.relative.x))
		else:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	if event is InputEventMouseButton and not event.pressed:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)


#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("grab_control"):
		#Input.set_default_cursor_shape(Input.CURSOR_DRAG)
	#elif event.is_action_released("grab_control"):
		#Input.set_default_cursor_shape(Input.CURSOR_ARROW)
#
	#if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#Input.set_default_cursor_shape(Input.CURSOR_HSIZE)
		#$TeaPot.rotate_object_local(Vector3.UP, deg_to_rad(event.relative.x))
	#
	#if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		#$TeaPot.rotate_object_local(Vector3.RIGHT, deg_to_rad(event.relative.y))
		#Input.set_default_cursor_shape(Input.CURSOR_VSIZE)
		
	#if event.is_action_pressed("grab_control"):
		#Input.set_default_cursor_shape(Input.CURSOR_DRAG)
	#elif event.is_action_released("grab_control"):
		#Input.set_default_cursor_shape(Input.CURSOR_ARROW)
