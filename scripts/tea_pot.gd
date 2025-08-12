extends MeshInstance3D

signal piece_solved

const TOLERANCE: float = 0.2
var solved: bool = false

const SOLUTION := Vector3(1.0, -179.0, 0)

func _ready() -> void:
	rotation_degrees = Vector3.ZERO
#	position = Vector3.ZERO

func _input(_event: InputEvent) -> void:
	if is_solved():
		piece_solved.emit()
		return

func angle_diff_deg(a: float, b: float) -> float:
	var diff = fposmod(a - b, 360.0)
	if diff > 180.0:
		diff -= 360.0
	return diff

func is_solved() -> bool:
	var dx = angle_diff_deg(rotation_degrees.x, SOLUTION.x)
	var dy = angle_diff_deg(rotation_degrees.y, SOLUTION.y)
	var dz = angle_diff_deg(rotation_degrees.z, SOLUTION.z)

	return abs(dx) <= TOLERANCE \
		and abs(dy) <= TOLERANCE \
		and abs(dz) <= TOLERANCE
