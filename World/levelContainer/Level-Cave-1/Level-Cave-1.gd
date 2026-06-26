extends Node2D

@onready var doors = [$"doorContainer/door-north", $"doorContainer/door-south"]

# this function should be generally applicable to all levels with doors
func door_transition(from_door: String) -> void:
	for i in doors:
		if i.name == from_door:
			Global.player.global_position = i.exit_point
