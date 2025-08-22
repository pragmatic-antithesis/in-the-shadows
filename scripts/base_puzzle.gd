class_name  BasePuzzle
extends Node3D

signal puzzle_solved

@onready var children: Array[Node]
var completion_status: Array[bool] = []

func _ready():
	children = get_children()
	completion_status.resize(children.size())
	completion_status.fill(false)

	for i in children.size():
		var child = children[i]
		if child.has_signal("piece_solved"):
			child.piece_solved.connect(_on_child_solved.bind(i))
		else:
			push_warning("Child %s does not have piece_solved signal" % child.name)

func _on_child_solved(child_index: int):
	completion_status[child_index] = true
	if completion_status.all(func(status): return status):
		puzzle_solved.emit()
