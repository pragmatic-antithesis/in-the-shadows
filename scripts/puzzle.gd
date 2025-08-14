extends Area3D

const move_speed: float = 0.01
const SPOT_CENTER = Vector2(2.6, 8.2)
const SPOT_RADIUS = 5.0
var outline: StandardMaterial3D
var selected: bool = false
var solved: bool = false
@onready var mesh_outline: MeshInstance3D = $Collision/Mesh/Outline

func _ready() -> void:
	mesh_outline.hide()
	outline = mesh_outline.get_surface_override_material(0)

func _on_input_event(_camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if solved: return
	if not selected and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		selected = true
		outline.emission_energy_multiplier = 1.42
		
func _input(event: InputEvent) -> void:
	if solved or not selected: return
	outline.emission_energy_multiplier = 1.42
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
		_on_mouse_exited()


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

func _on_mouse_entered() -> void:
	if solved: return
	var tween: Tween = create_tween()
	mesh_outline.show()
	tween.tween_property(outline, "emission_energy_multiplier", 0.42, 0.3)

func _on_mouse_exited() -> void:
	if solved or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	selected = false
	var tween: Tween = create_tween()
	tween.tween_property(outline, "emission_energy_multiplier", 0.0, 0.2)
	tween.tween_callback(Callable(mesh_outline, "hide"))

func _on_mesh_piece_solved(_extra_arg_0: Vector3, _extra_arg_1: Vector3) -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if solved: return
	solved = true
	var tween: Tween = create_tween()
	mesh_outline.show()
	const blink_duration: float = 0.2
	const scale_up: float = 1.015
	const scale_down: float = 1.001
	tween.parallel().tween_property(outline, "emission_energy_multiplier", 3.42, blink_duration * 1.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(mesh_outline, "scale", Vector3(scale_up, scale_up, scale_up), blink_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(mesh_outline, "scale", Vector3(scale_down, scale_down, scale_down), blink_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(mesh_outline, "hide"))
