extends  Node

@export var colors: Dictionary = {
	0: {
		"floor": load("res://shaders/floor_default.tres"),
		"wall_l": load("res://shaders/wl_default.tres"),
		"wall_r": load("res://shaders/wr_default.tres"),
	},
	1: {
		"floor": load("res://shaders/floor_1.tres"),
		"wall_l": load("res://shaders/wall_l_1.tres"),
		"wall_r": load("res://shaders/wall_r_1.tres"),
	},
	2: {
		"floor": load("res://shaders/floor_2.tres"),
		"wall_l": load("res://shaders/wall_l_2.tres"),
		"wall_r": load("res://shaders/wall_r_2.tres"),
	},
	3: {
		"floor": load("res://shaders/floor_3.tres"),
		"wall_l": load("res://shaders/wall_l_3.tres"),
		"wall_r": load("res://shaders/wall_r_3.tres"),
	},
	4: {
		"floor": load("res://shaders/floor_4.tres"),
		"wall_l": load("res://shaders/wall_l_4.tres"),
		"wall_r": load("res://shaders/wall_r_4.tres"),
	},
	5: {
		"floor": load("res://shaders/floor_5.tres"),
		"wall_l": load("res://shaders/wall_l_5.tres"),
		"wall_r": load("res://shaders/wall_r_5.tres"),
	},
}
