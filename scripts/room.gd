extends Node3D

@onready var room_floor: MeshInstance3D = $Floor
@onready var wall_projected: MeshInstance3D = $WallProjected
@onready var wall_unprojected: MeshInstance3D = $WallUnprojected

func _on_puzzle_interface_child_entered_tree(node: Node) -> void:
	await node.ready
	room_floor.set_surface_override_material(0, TextureDict.colors[node.level_id]["floor"])
	wall_projected.set_surface_override_material(0, TextureDict.colors[node.level_id]["wall_l"])
	wall_unprojected.set_surface_override_material(0, TextureDict.colors[node.level_id]["wall_r"])
