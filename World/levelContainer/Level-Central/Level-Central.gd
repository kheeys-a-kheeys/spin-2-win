extends Node2D

#var player_reff
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#Global.player.global_position = Vector2(0,0)

@onready var respawn_point = $"respawn-point".global_position
@onready var doors = [$"doorContainer/door-east"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

# this function should be generally applicable to all levels with doors
func door_transition(from_door: String) -> void:
	for i in doors:
		if i.name == from_door:
			Global.player.global_position = i.exit_point
