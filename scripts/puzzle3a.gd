extends MeshInstance3D

signal piece_solved

@export var level_id: int = 3

func _ready() -> void:
	scale = Vector3(0.3, 0.3, 0.3)
	AudioPlayer.play_music("puzzle3")

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
const TOLERANCE = 100.5
const solved_position = Vector3(1.77, 9.42, -5.73)
const solved_rotation = Vector3(1.30, 0.60, -2.3)

const ANGLE_TOLERANCE: float = 0.05 #3 deg
func modularize(coord: float) -> float:
	if coord > PI - ANGLE_TOLERANCE:
		print("I GOT CALLED AND AM BIGGER THAN PI", coord)
		return -PI
	if coord < -PI + ANGLE_TOLERANCE:
		print("I GOT CALLED AND AM SMALLER THAN PI ", coord)
		return -PI
	return coord

func check_piece_solution(mesh_position: Vector3, mesh_rotation: Vector3) -> void:
	var normalized_rotation = Vector3(
		modularize(mesh_rotation.x),
		modularize(mesh_rotation.y),
		modularize(mesh_rotation.z))
	print("received position: ", mesh_position, " and rotation ", normalized_rotation)
	if is_solved(mesh_position, normalized_rotation):
		AudioPlayer.play_sfx("puzzle2")
		piece_solved.emit(solved_position, solved_rotation)

func is_solved(mesh_position: Vector3, mesh_rotation: Vector3) -> bool:
	var pos_2d := Vector2(mesh_position.x, mesh_position.y)

	return mesh_rotation.x >= ROTATION_RANGES["x"]["min"] and mesh_rotation.x <= ROTATION_RANGES["x"]["max"] \
	and mesh_rotation.y >= ROTATION_RANGES["y"]["min"] and mesh_rotation.y <= ROTATION_RANGES["y"]["max"] \
	and mesh_rotation.z >= ROTATION_RANGES["z"]["min"] and mesh_rotation.z <= ROTATION_RANGES["z"]["max"] \
	and pos_2d.distance_to(CENTER) < TOLERANCE
