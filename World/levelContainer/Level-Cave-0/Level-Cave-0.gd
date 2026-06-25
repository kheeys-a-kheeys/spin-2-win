extends Node2D

@onready var doors = [$"door-north", $"door-south"]
func _ready() -> void:
	Global.world_boundaries_left = 3
	Global.world_boundaries_right = 500
	Global.world_boundaries_up = 3
	Global.world_boundaries_down = 501
# this function should be generally applicable to all levels with doors
func door_transition(from_door: String) -> void:
	for i in doors:
		if i.name == from_door:
			Global.player.global_position = i.exit_point
