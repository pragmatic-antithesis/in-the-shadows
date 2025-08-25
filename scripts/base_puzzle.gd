class_name BasePuzzle
extends Node3D

signal puzzle_solved

@onready var meshes: Array[MeshInstance3D]
@onready var children: Array[Node]
var completion_status: Array[bool] = []

func _ready() -> void:
	children = get_children()
	completion_status.resize(children.size())
	completion_status.fill(false)
	meshes.resize(children.size())

	for i in children.size():
		meshes[i] = children[i].get_node("Mesh")
		if meshes[i].has_signal("piece_solved"):
			children[i].piece_solved.connect(_on_child_solved.bind(i))
		else:
			push_warning("Child %s does not have piece_solved signal" % meshes[i].name)

	if children.size() > 1:
		children[1].control_click = MOUSE_BUTTON_RIGHT

func _on_child_solved(child_index: int) -> void:
	completion_status[child_index] = true
	if children.size() > 1:
		if !child_index: children[1].control_click = MOUSE_BUTTON_LEFT
	if completion_status.all(func(status): return status):
		puzzle_solved.emit(meshes[0].level_id)
