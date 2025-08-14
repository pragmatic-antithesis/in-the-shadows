extends MeshInstance3D

signal piece_solved

var solved: bool = false

func _ready() -> void:
	rotation = Vector3(0.0, -2.5, 0.0)

func _angle_diff_deg(a: float, b: float) -> float:
	var diff = fposmod(a - b, 360.0)
	if diff > 180.0:
		diff -= 360.0
	return diff

const ROTATION_RANGES := {
	"x": {"min": -0.02, "max": 0.07},
	"y": {"min": -0.09, "max": 0.05},
}
const CENTER = Vector2(-0.17, -0.95)
const TOLERANCE = 1.5
const solved_position = Vector3(2.3, 8.27, -7.15)
const solved_rotation = Vector3(0.0, 0.05, 0.0)

func check_piece_solution() -> void:
	if is_solved():
		piece_solved.emit(solved_position, solved_rotation)

func is_solved() -> bool:
	var pos_2d := Vector2(position.x, position.y)

	return rotation.x >= ROTATION_RANGES["x"]["min"] and rotation.x <= ROTATION_RANGES["x"]["max"] \
	and rotation.y >= ROTATION_RANGES["y"]["min"] and rotation.y <= ROTATION_RANGES["y"]["max"] \
	and pos_2d.distance_to(CENTER) <= TOLERANCE
