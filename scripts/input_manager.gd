extends Node

var original_events: Dictionary = {}

func toggle_actions(actions: Array[String], enabled: bool):
	if enabled:
		restore_actions(actions)
	else:
		disable_actions(actions)

func disable_actions(actions: Array[String]):
	for action in actions:
		if InputMap.has_action(action):
			original_events[action] = InputMap.action_get_events(action).duplicate()
			InputMap.action_erase_events(action)

func restore_actions(actions: Array[String]):
	for action in actions:
		if InputMap.has_action(action) and action in original_events:
			InputMap.action_erase_events(action)
			for event in original_events[action]:
				InputMap.action_add_event(action, event)
