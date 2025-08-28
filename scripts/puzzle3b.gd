extends MeshInstance3D

signal piece_solved

@export var level_id: int = 3

func _ready() -> void:
	scale = Vector3(0.3, 0.3, 0.3)
	get_parent().set_rotation(Vector3(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0))
	)

const ROTATION_RANGES: Dictionary = {
	"x": {"min": -1.7, "max": -1.0},
	"y": {"min": -1.8, "max": -1.1},
	"z": {"min": 1.1, "max": 1.7},
}

const CENTER = Vector2(1.81, 10.22)
const TOLERANCE = 0.75
const solved_position = Vector3(2.15, 9.93, -7.9)
const solved_rotation = Vector3(-1.4, -1.52, 1.47)

func check_piece_solution(mesh_position: Vector3, mesh_rotation: Vector3) -> void:
	if is_solved(mesh_position, mesh_rotation):
		AudioPlayer.play_sfx("puzzle3")
		piece_solved.emit(solved_position, solved_rotation)

func is_solved(mesh_position: Vector3, mesh_rotation: Vector3) -> bool:
	var pos_2d := Vector2(mesh_position.x, mesh_position.y)

	return mesh_rotation.x >= ROTATION_RANGES["x"]["min"] and mesh_rotation.x <= ROTATION_RANGES["x"]["max"] \
	and mesh_rotation.y >= ROTATION_RANGES["y"]["min"] and mesh_rotation.y <= ROTATION_RANGES["y"]["max"] \
	and mesh_rotation.z >= ROTATION_RANGES["z"]["min"] and mesh_rotation.z <= ROTATION_RANGES["z"]["max"] \
	and pos_2d.distance_to(CENTER) < TOLERANCE
