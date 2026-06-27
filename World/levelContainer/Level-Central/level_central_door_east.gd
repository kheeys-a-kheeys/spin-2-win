extends Sprite2D

var shut: bool = false # whether door is accessible or not, for encounters

# variable for when this door is called
# REMEMBER: level has to be instantiated first BEFORE we move the player!
@onready var exit_point: Vector2 = $"exit-point".global_position


func _process(delta: float) -> void:
	if $"../../CanvasLayer".tutorial_done == true:
		shut = false
	else:
		shut = true
func _on_door_entered(area: Area2D) -> void:
	if area.name == "player-shape":
		if !shut:
			var to_level = "res://World/levelContainer/Level-Cave-1/Level-Cave-1.tscn"
			var from_door = "door-south"
			SignalBus.door_entered.emit(to_level, from_door)
