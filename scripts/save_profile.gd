extends Resource
class_name SaveProfile

@export var player_name: String = ""
@export var puzzles_unlocked: int = 0

func is_empty() -> bool:
	return player_name == "" and puzzles_unlocked == 0

func to_dict() -> Dictionary:
	return {
		"player_name": player_name,
		"puzzles_unlocked": puzzles_unlocked
	}

static func from_dict(data: Dictionary) -> SaveProfile:
	var profile: SaveProfile = SaveProfile.new()
	profile.player_name = data.get("player_name", "")
	profile.puzzles_unlocked = data.get("puzzles_unlocked", 0)
	return profile
