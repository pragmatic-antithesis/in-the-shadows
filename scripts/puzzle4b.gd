extends MeshInstance3D

signal piece_solved

@export var level_id: int = 4
const display_scale: Vector3 = Vector3(0.17, 0.17, 0.17)

func _ready() -> void:
	scale = display_scale
	get_parent().get_node("Collision").scale = display_scale
	get_parent().set_rotation(Vector3(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0))
	)

const ROTATION_RANGES: Dictionary = {
	"x": {"min": -0.5, "max": 0.5},
	"y": {"min": 2.87, "max": 3.13},
	"z": {"min": -3.15, "max": -3.11},
}

const CENTER = Vector2(0.5, 9.5)
const TOLERANCE = 0.75
const solved_position = Vector3(0.65, 9.6, -7.8)
const solved_rotation = Vector3(0.03, 3.0, -PI)

const ANGLE_TOLERANCE: float = 0.05 #3 deg

func modularize(coord: float) -> float:
	if coord > PI - ANGLE_TOLERANCE:
		return -PI
	if coord < -PI + ANGLE_TOLERANCE:
		return -PI
	return coord

func check_piece_solution(mesh_position: Vector3, mesh_rotation: Vector3) -> void:
	var normalized_rotation = Vector3(
		modularize(mesh_rotation.x),
		modularize(mesh_rotation.y),
		modularize(mesh_rotation.z))

	if is_solved(mesh_position, normalized_rotation):
		AudioPlayer.play_sfx("puzzle4")
		piece_solved.emit(solved_position, solved_rotation)

func is_solved(mesh_position: Vector3, mesh_rotation: Vector3) -> bool:
	var pos_2d := Vector2(mesh_position.x, mesh_position.y)

	return mesh_rotation.x >= ROTATION_RANGES["x"]["min"] and mesh_rotation.x <= ROTATION_RANGES["x"]["max"] \
	and mesh_rotation.y >= ROTATION_RANGES["y"]["min"] and mesh_rotation.y <= ROTATION_RANGES["y"]["max"] \
	and mesh_rotation.z >= ROTATION_RANGES["z"]["min"] and mesh_rotation.z <= ROTATION_RANGES["z"]["max"] \
	and pos_2d.distance_to(CENTER) < TOLERANCE
