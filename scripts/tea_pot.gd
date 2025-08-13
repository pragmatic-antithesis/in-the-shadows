extends MeshInstance3D

signal piece_solved

var solved: bool = false

func _ready() -> void:
	rotation_degrees = Vector3.ZERO

func _input(_event: InputEvent) -> void:
	if is_solved():
		piece_solved.emit()
		return

func _angle_diff_deg(a: float, b: float) -> float:
	var diff = fposmod(a - b, 360.0)
	if diff > 180.0:
		diff -= 360.0
	return diff

func check_piece_solution() -> void:
	if is_solved():
		print("yes, my rotation is ", rotation)
	else:
		print("no, I'm currently at", rotation)
	print("my position is ", position)

const ROTATION_RANGES := {
	"x": {"min": -0.02, "max": 0.07},
	"y": {"min": 3.10, "max": 3.13},
	"z": {"min": -0.15, "max": 0.15}
}
const CENTER = Vector2(0.0, 8.2)
const TOLERANCE = 0.5

func is_solved() -> bool:
	var pos_2d := Vector2(position.x, position.y)
	
	return rotation.x >= ROTATION_RANGES["x"]["min"] and rotation.x <= ROTATION_RANGES["x"]["max"] \
	and rotation.y >= ROTATION_RANGES["y"]["min"] and rotation.y <= ROTATION_RANGES["y"]["max"] \
	and rotation.z >= ROTATION_RANGES["z"]["min"] and rotation.z <= ROTATION_RANGES["z"]["max"] \
	and pos_2d.distance_to(CENTER) <= TOLERANCE
