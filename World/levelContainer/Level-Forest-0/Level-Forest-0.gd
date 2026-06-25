extends Node2D

@onready var doors = [$"door-north"]

func _ready() -> void:
	#intialize boundaries
	Global.world_boundaries_left = 0
	Global.world_boundaries_right = 130
	Global.world_boundaries_up = -10
	Global.world_boundaries_down = 948

# this function should be generally applicable to all levels with doors
func door_transition(from_door: String) -> void:
	for i in doors:
		if i.name == from_door:
			Global.player.global_position = i.exit_point
