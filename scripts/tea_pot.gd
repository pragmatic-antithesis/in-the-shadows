extends MeshInstance3D

signal piece_solved

const TOLERANCE: float = 0.05
var solved: bool = false

const SOLUTION := Vector3(0.0, 3.12, 0.0)

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

func is_solved() -> bool:
	var dx: float = _angle_diff_deg(rotation.x, SOLUTION.x)
	var dy: float = _angle_diff_deg(rotation.y, SOLUTION.y)
	var dz: float = _angle_diff_deg(rotation.z, SOLUTION.z)

	return abs(dx) <= TOLERANCE \
		and abs(dy) <= TOLERANCE \
		and abs(dz) <= TOLERANCE
