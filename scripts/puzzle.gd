extends Area3D

#TeaPot 1, -179 0
#Elephanto 84 -0.5 -175.8

const move_speed: float = 0.01
const SPOT_CENTER = Vector2(2.6, 8.2)
const SPOT_RADIUS = 5.0
@onready var mesh_outline: MeshInstance3D = $Collision/Mesh/Outline
var outline: StandardMaterial3D

func _ready() -> void:
	mesh_outline.hide()
	outline = mesh_outline.get_surface_override_material(0)

func _input(event: InputEvent) -> void:
	var puzzle_piece: MeshInstance3D = $Collision/Mesh
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if Input.is_action_pressed("vertical_rotate"):
			Input.set_default_cursor_shape(Input.CURSOR_VSIZE)
			if event is InputEventMouseMotion:
				puzzle_piece.rotate_object_local(Vector3.RIGHT, deg_to_rad(event.relative.y))
		elif Input.is_action_pressed("grab_control"):
			Input.set_default_cursor_shape(Input.CURSOR_DRAG)
			if event is InputEventMouseMotion:
				var raw_move = (-event.relative.x * Vector3(1, 0, 0) + -event.relative.y * Vector3(0, 1, 0)) * move_speed
				var filtered_move = _get_clamped_move(puzzle_piece, raw_move)
				puzzle_piece.global_translate(filtered_move)
		else:
			Input.set_default_cursor_shape(Input.CURSOR_HSIZE)
			if event is InputEventMouseMotion:
				puzzle_piece.rotate_object_local(Vector3.UP, deg_to_rad(event.relative.x))
	
	if event is InputEventMouseButton and not event.pressed:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		puzzle_piece.check_piece_solution()


func _get_clamped_move(piece: Node3D, move: Vector3) -> Vector3:
	var current_pos_2d = Vector2(piece.global_position.x, piece.global_position.y)
	var target_pos_2d = current_pos_2d + Vector2(move.x, move.y)

	var dist_to_center = target_pos_2d.distance_to(SPOT_CENTER)

	if dist_to_center > SPOT_RADIUS:
		var direction = (target_pos_2d - SPOT_CENTER).normalized()
		target_pos_2d = SPOT_CENTER + direction * SPOT_RADIUS

		var clamped_move_2d = target_pos_2d - current_pos_2d
		return Vector3(clamped_move_2d.x, clamped_move_2d.y, move.z)
	return move

#func _on_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	#if event is InputEventMouse:
		#mesh_outline.show()
		
#		var outline: StandardMaterial3D = mesh_outline.get_surface_override_material(0)
#		outline.emission_energy_multiplier = 3.0
		

func _on_mouse_entered() -> void:
	var tween: Tween = create_tween()
	mesh_outline.show()
	tween.tween_property(outline, "emission_energy_multiplier", 0.42, 0.3)

func _on_mouse_exited() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(outline, "emission_energy_multiplier", 0.0, 0.2)
	tween.tween_callback(Callable(mesh_outline, "hide"))
