extends MeshInstance3D

signal piece_solved

@export var level_id: int = 2

func _ready() -> void:
	rotation = Vector3(0.0, -2.5, 0.0)
	AudioPlayer.play_music("puzzle2")

func _angle_diff_deg(a: float, b: float) -> float:
	var diff = fposmod(a - b, 360.0)
	if diff > 180.0:
		diff -= 360.0
	return diff

const ROTATION_RANGES: Dictionary = {
	"x": {"min": 1.3, "max": 1.5},
	"y": {"min": -2.5, "max": -1.5},
	"z": {"min": -2.3, "max": -1.7}
}
const CENTER = Vector2(-0.17, -0.95)
const TOLERANCE = 1.5
const solved_position = Vector3(1.9, 9.1, -7.15)
const solved_rotation = Vector3(1.5, -1.95, -1.75)

func check_piece_solution() -> void:
	print("rotation: ", rotation)
	if is_solved():
		AudioPlayer.play_sfx("puzzle2")
		piece_solved.emit(solved_position, solved_rotation)

func is_solved() -> bool:
	var pos_2d := Vector2(position.x, position.y)

	return rotation.x >= ROTATION_RANGES["x"]["min"] and rotation.x <= ROTATION_RANGES["x"]["max"] \
	and rotation.y >= ROTATION_RANGES["y"]["min"] and rotation.y <= ROTATION_RANGES["y"]["max"] \
	and rotation.z >= ROTATION_RANGES["z"]["min"] and rotation.z <= ROTATION_RANGES["z"]["max"] \
	and pos_2d.distance_to(CENTER) <= TOLERANCE
