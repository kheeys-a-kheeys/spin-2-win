extends Node2D

# to handle primary gameplay behavior

var spin: int = 0 # -1 for ccw, 1 for cw, 0 for rest
var speed: float = 0 # multiply with direction unit vector to get velocity
var target: Vector2 = Vector2(0, 0) # direction of motion
var k: float = 0.01 # spring constant analog, ours is time dependant
var omega: int = 0 # angular momentum is on a scale from -3 to 3, for now

@onready var sprite = $spinor

# speed damping function, we can make this more robust later
func eom() -> void:
	k += 0.1*k
	k = min(1, k)
	speed = (1 - k)*speed

# set the correct sprite for our spin direction, won't work with more advanced spritework
func set_frame() -> void:
	if spin == 1:
		sprite.frame = 1
	elif spin == -1:
		sprite.frame = 0

func spin_frame(delta) -> void:
	sprite.rotation += omega*16*delta
