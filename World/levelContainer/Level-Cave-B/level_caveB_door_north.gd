extends Sprite2D
# this is a special door that ends the game!

var shut: bool = false # whether door is accessible or not, for encounters

# variable for when this door is called
# REMEMBER: level has to be instantiated first BEFORE we move the player!
@onready var exit_point: Vector2 = $"exit-point".global_position

func _on_door_entered(area: Area2D) -> void:
	if area.name == "player-shape":
		if !shut:
			# send a signal to activate the "You Win!" screen
			pass
