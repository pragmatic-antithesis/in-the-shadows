class_name BasePuzzle
extends Node3D

signal puzzle_solved

@onready var meshes: Array[MeshInstance3D]
var completion_status: Array[bool] = []
var selection_mutex: Mutex = Mutex.new()
var currently_selected_index = -1

func _ready() -> void:
	var children: Array[Node] = get_children()
	completion_status.resize(children.size())
	completion_status.fill(false)
	meshes.resize(children.size())

	for i in children.size():
		meshes[i] = children[i].get_node("Collision/Mesh")
		if meshes[i].has_signal("piece_solved"):
			children[i].piece_solved.connect(_on_child_solved.bind(i))
			children[i].piece_selected.connect(_on_child_selected.bind(i))
		else:
			push_warning("Child %s does not have piece_solved signal" % meshes[i].name)

func _on_child_solved(child_index: int) -> void:
	completion_status[child_index] = true
	if completion_status.all(func(status): return status):
		puzzle_solved.emit(meshes[0].level_id)

func _on_child_selected(child_selected: bool, child_index: int) -> void:
	selection_mutex.lock()

	if child_selected:
		# Store currently selected index atomically
		currently_selected_index = child_index
		# Disable other pieces
		for i in meshes.size():
			meshes[i].get_parent().get_parent().locked = i == child_index

		print("Child ", child_index, " selected")
		await get_tree().create_timer(2.0).timeout
	else:
		currently_selected_index = -1
		# Re-enable all pieces
		for i in meshes.size():
			meshes[i].get_parent().get_parent().locked = false
		print("Child ", child_index, " deselected")
	
	selection_mutex.unlock()
