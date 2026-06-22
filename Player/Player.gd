extends Node2D

# to handle primary gameplay behavior

var spin: int = 0 # -1 for ccw, 1 for cw, 0 for rest
var speed: float = 0 # multiply with direction unit vector to get velocity
var motion: Vector2 = Vector2(0, 0) # direction of motion, a unit vector
var k: float = 0.01 # spring constant analog, ours is time dependant
var omega: int = 0 # angular momentum is on a scale from -3 to 3, for now

@onready var sprite = $spinor

# speed damping function, we can make this more robust later
func eom() -> void:
	k += 0.1*k
	k = min(1, k)
	speed = (1 - k)*speed

# apply rotation matrix to motion to try and align with an input target
func aligning(target: Vector2) -> void:
	# find angle between motion and target (or not - acos is expensive)
	# rotate motion in direction of the previously determined angle
	
	# the following operation is the determinant of the matrix [motion; target]
	# which helps determine if target is to motion's left or right
	# also called "the wedge product of two one-forms followed by the Hodge dual operation"
	# just whatever
	var detmota = motion.x*target.y - motion.y*target.x 

	# now we rotate
	var mx = motion.x
	var my = motion.y
	var inc = 5 * sign(detmota) * PI / 180
	motion.x = mx*cos(inc) - my*sin(inc)
	motion.y = mx*sin(inc) + my*cos(inc)

# set the correct sprite for our spin direction, won't work with more advanced spritework
func set_frame() -> void:
	if spin == 1:
		sprite.frame = 1
	elif spin == -1:
		sprite.frame = 0

func spin_frame(delta) -> void:
	sprite.rotation += omega*16*delta
