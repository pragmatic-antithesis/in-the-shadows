extends MeshInstance3D

signal piece_solved

@export var level_id: int = 5

func _ready() -> void:
	AudioPlayer.play_music("puzzle5")
	get_parent().set_rotation(Vector3(
		randf_range(-1.5, 1.5),
		randf_range(-1.5, 1.5),
		randf_range(-1.5, 1.5))
	)


const ROTATION_RANGES: Dictionary = {
	"x": {"min": -0.2, "max": 0.2},
	"y": {"min": -0.2, "max": 0.2},
	"z": {"min": -0.2, "max": 0.2}
}

const CENTER = Vector2(2.2, 7.8)
const TOLERANCE = 0.75
const solved_position = Vector3(2.21, 7.81, -6.3)
const solved_rotation = Vector3(-0.14, 0.02, 0.08)

func check_piece_solution(mesh_position: Vector3, mesh_rotation: Vector3) -> void:
	if is_solved(mesh_position, mesh_rotation):
		AudioPlayer.play_sfx("puzzle5")
		piece_solved.emit(solved_position, solved_rotation)

func is_solved(mesh_position: Vector3, mesh_rotation: Vector3) -> bool:
	var pos_2d := Vector2(mesh_position.x, mesh_position.y)
	
	return mesh_rotation.x >= ROTATION_RANGES["x"]["min"] and mesh_rotation.x <= ROTATION_RANGES["x"]["max"] \
	and mesh_rotation.y >= ROTATION_RANGES["y"]["min"] and mesh_rotation.y <= ROTATION_RANGES["y"]["max"] \
	and mesh_rotation.z >= ROTATION_RANGES["z"]["min"] and mesh_rotation.z <= ROTATION_RANGES["z"]["max"] \
	and pos_2d.distance_to(CENTER) < TOLERANCE
