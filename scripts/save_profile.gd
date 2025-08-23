extends Resource
class_name SaveProfile

@export var player_name: String = ""
@export var puzzles_unlocked: int = 0

func is_empty() -> bool:
	return player_name == "" and puzzles_unlocked == 0
