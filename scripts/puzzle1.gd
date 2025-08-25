extends MeshInstance3D

signal piece_solved

@export var level_id: int = 1

func _ready() -> void:
	AudioPlayer.play_music("puzzle1")
	InputManager.disable_actions(["vertical_rotate", "grab_control"])
	get_parent().rotate_y(randf_range(-1.5, 1.5))

func _exit_tree() -> void:
	InputManager.restore_actions(["vertical_rotate", "grab_control"])

const ROTATION_RANGES := {"y": {"min": -3.15, "max": -3.11}}
const solved_position = Vector3(2.17, 9.27, -8.07)
const solved_rotation = Vector3(0.0, PI, 0.0)

const ANGLE_TOLERANCE: float = 0.05 #3 deg
func modularize(coord: float) -> float:
	if coord > PI - ANGLE_TOLERANCE:
		return -PI
	if coord < -PI + ANGLE_TOLERANCE:
		return -PI
	return coord

func check_piece_solution(mesh_position: Vector3, mesh_rotation: Vector3) -> void:
	var normalized_rotation: = Vector3(
		modularize(mesh_rotation.x),
		modularize(mesh_rotation.y),
		modularize(mesh_rotation.z))

	if is_solved(mesh_position, normalized_rotation):
		AudioPlayer.play_sfx("puzzle1")
		piece_solved.emit(solved_position, solved_rotation)

func is_solved(_mesh_position: Vector3, mesh_rotation: Vector3) -> bool:
	return mesh_rotation.y >= ROTATION_RANGES["y"]["min"] and mesh_rotation.y <= ROTATION_RANGES["y"]["max"]
