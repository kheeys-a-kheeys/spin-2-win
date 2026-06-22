extends Node2D

# to handle primary gameplay behavior

var spin: int = 0 # -1 for ccw, 1 for cw, 0 for rest
var speed: float = 0 # multiply with direction unit vector to get velocity
var motion: Vector2 = Vector2(0, 0) # direction of motion, a unit vector
var k: float = 0.01 # spring constant analog, ours is time dependant
var omega: int = 0 # angular momentum is on a scale from -3 to 3, for now

@onready var sprite = $spinor
@onready var p_area = $"player-shape"

func _ready() -> void: #set up global
	Global.player = self

# function (eventually) connected to area_entered signal
func _on_player_opp_collision(o_box: Area2D) -> void:
	print("area collided")
	print("opponent area positioned at: ", o_box.position)
	#player_collision()

# function connected to body_entered signal
func _on_player_bod_collision(o_bod: Node2D) -> void:
	print("body collided")
	print("opponent body positioned at: ", o_bod.global_position)
	player_collision(o_bod)

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
		sprite.frame = 1

# rotate sprite based on an input time step
func spin_frame(delta) -> void:
	sprite.rotation += omega*16*delta

# now hitbox behaviors
# the vertical (relative) component will simply be reflected (basic momentum collision)
# the horizontal (relative) component could be based on how the player (and enemy) is rotating
func player_collision(o_bod: Node2D) -> void:
	var knock = 64 # knockback - should probably be an enemy property
	var r_pos = global_position - o_bod.global_position
	motion = r_pos.normalized()
	speed = knock + speed
