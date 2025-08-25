extends MeshInstance3D

signal piece_solved

@export var level_id: int = 2

func _ready() -> void:
	AudioPlayer.play_music("puzzle2")
	InputManager.disable_actions(["grab_control"])
	get_parent().set_rotation(Vector3(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)))

func _exit_tree() -> void:
	InputManager.restore_actions(["grab_control"])

const ROTATION_RANGES: Dictionary = {
	"x": {"min": 1.2, "max": 1.9},
	"y": {"min": 0.2, "max": 0.9},
	"z": {"min": -2.5, "max": -2.1}
}

const solved_position = Vector3(1.77, 9.42, -5.73)
const solved_rotation = Vector3(1.30, 0.60, -2.3)

func check_piece_solution(mesh_position: Vector3, mesh_rotation: Vector3) -> void:
	if is_solved(mesh_position, mesh_rotation):
		AudioPlayer.play_sfx("puzzle2")
		piece_solved.emit(solved_position, solved_rotation)

func is_solved(_mesh_position: Vector3, mesh_rotation: Vector3) -> bool:
	return mesh_rotation.x >= ROTATION_RANGES["x"]["min"] and mesh_rotation.x <= ROTATION_RANGES["x"]["max"] \
	and mesh_rotation.y >= ROTATION_RANGES["y"]["min"] and mesh_rotation.y <= ROTATION_RANGES["y"]["max"] \
	and mesh_rotation.z >= ROTATION_RANGES["z"]["min"] and mesh_rotation.z <= ROTATION_RANGES["z"]["max"]
