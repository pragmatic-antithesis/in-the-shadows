extends MeshInstance3D

signal piece_solved

@export var level_id: int = 4

func _ready() -> void:
	scale = Vector3(0.17, 0.17, 0.17)
	AudioPlayer.play_music("puzzle4")
	
	#await get_tree().create_timer(2.0).timeout
	#piece_solved.emit(solved_position, solved_rotation)

func _angle_diff_deg(a: float, b: float) -> float:
	var diff = fposmod(a - b, 360.0)
	if diff > 180.0:
		diff -= 360.0
	return diff

const ROTATION_RANGES: Dictionary = {
	"x": {"min": 1.1, "max": 1.3},
	"y": {"min": 1.6, "max": 1.8},
	"z": {"min": 1.7, "max": 1.8}
}
const CENTER = Vector2(-0.17, -0.95)
const TOLERANCE = 1.5
const solved_position = Vector3(2.2, 9.7, -7.15)
const solved_rotation = Vector3(1.2, 1.7, 1.75)

func check_piece_solution() -> void:
	print("rotation: ", rotation)
	if is_solved():
		AudioPlayer.play_sfx("puzzle4")
		piece_solved.emit(solved_position, solved_rotation)

func is_solved() -> bool:
	var pos_2d := Vector2(position.x, position.y)

	return rotation.x >= ROTATION_RANGES["x"]["min"] and rotation.x <= ROTATION_RANGES["x"]["max"] \
	and rotation.y >= ROTATION_RANGES["y"]["min"] and rotation.y <= ROTATION_RANGES["y"]["max"] \
	and rotation.z >= ROTATION_RANGES["z"]["min"] and rotation.z <= ROTATION_RANGES["z"]["max"] \
	and pos_2d.distance_to(CENTER) <= TOLERANCE
