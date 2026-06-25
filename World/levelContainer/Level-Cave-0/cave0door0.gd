extends Sprite2D

var shut: bool = false # whether door is accessible or not, for encounters

# variable for when this door is called
# REMEMBER: level has to be instantiated first BEFORE we move the player!
@onready var exit_point: Vector2 = global_position + Vector2(36, 32)

func _on_door_entered(area: Area2D) -> void:
	if area.name == "player-shape":
		SignalBus.door_entered.emit()
