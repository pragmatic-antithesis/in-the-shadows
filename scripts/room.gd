extends Node3D

@onready var wall_projected: MeshInstance3D = $WallProjected
@onready var wall_unprojected: MeshInstance3D = $WallUnprojected
var wall_p_mat_default: StandardMaterial3D
var wall_u_mat_default: StandardMaterial3D

func _ready() -> void:
	wall_p_mat_default = wall_projected.get_surface_override_material(0)
	wall_u_mat_default = wall_projected.get_surface_override_material(0)

func _on_puzzle_interface_child_entered_tree(node: Node) -> void:
	await node.ready
