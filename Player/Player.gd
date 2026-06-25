extends Node2D

# to handle primary gameplay behavior

var spin: int = 0 # -1 for frost, 1 for fire, 0 for rest
var speed: float = 0 # multiply with direction unit vector to get velocity
var motion: Vector2 = Vector2(0, 0) # direction of motion, a unit vector
var k: float = 0.01 # spring constant analog, ours is time dependant
var omega: int = 0 # angular momentum is on a scale from -3 to 3, for now

# attributes
var health: int = 3
var damage: int = 100 # damage dealt to enemies
var invulf: int = 0 # count down i-frames after receiving damage
var invulf_max: int = 60 # max i-frame count\
var points: = 0 #players gains points from different interactiosn including killing enemies

@onready var sprite = $spinor
@onready var fire_aura = $"spinor-fire"
@onready var frost_aura = $"spinor-frost"
@onready var p_area = $"player-shape"

func _ready() -> void: #set up global
	Global.player = self
	add_to_group("player")
	print(get_groups())

func _physics_process(delta: float) -> void:
	if invulf > 0:
		invulf += -1
		if invulf % 5 == 0: # invulf / x must be an even number!
			invuln_blink()

# function (eventually) connected to area_entered signal
func _on_player_opp_collision(o_box: Area2D) -> void:
	#print("area collided")
	#print("opponent area positioned at: ", o_box.global_position)
	damage_machine(o_box)
	#player_collision(o_box)

# function connected to body_entered signal
func _on_player_bod_collision(o_bod: Node2D) -> void:
	print("body collided")
	print("opponent body positioned at: ", o_bod.global_position)
	#player_collision(o_bod)

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
	else:
		sprite.frame = 1
	
	if spin > 0:
		fire_aura.visible = 1
		frost_aura.visible = 0
	elif spin < 0:
		fire_aura.visible = 0
		frost_aura.visible = 1
	else:
		fire_aura.visible = 0
		frost_aura.visible = 0

# rotate sprite based on an input time step
func spin_frame(delta) -> void:
	sprite.rotation += omega*16*delta
	fire_aura.rotation = sprite.rotation
	frost_aura.rotation = sprite.rotation

# function to make the player blink when i-frames are active
func invuln_blink() -> void:
	sprite.visible = !sprite.visible

# now hitbox behaviors
# the vertical (relative) component will simply be reflected (basic momentum collision)
# the horizontal (relative) component could be based on how the player (and enemy) is rotating
func player_collision(o_box: Area2D) -> void:
	var knock = 64 # knockback - should probably be an enemy property
	var r_pos = global_position - o_box.global_position
	motion = r_pos.normalized()
	speed = knock + speed

# func to set the player's damage state based on a number of conditions
# o_box names should probably be in a dictionary
func damage_machine(o_box: Area2D) -> void:
	# deal damage on attack if enemy is opposite element to player
	if (o_box.name == "enemy-fire" && sign(spin) == -1) || (o_box.name == "enemy-frost" && sign(spin) == 1):
		if speed > 256: # probably not a good choice for this, it can be difficult for the player to gauge their speed
			print("damage dealt!")
			bounce(o_box, speed)
		else:
			damage_received(o_box)
	elif o_box.name == "enemy-fire" || o_box.name == "enemy-frost":
		print("attack bounced!")
		bounce(o_box, speed)
	
	# condition for boss encounter
	if o_box.name == "boss":
		var boss_reff = Global.boss
		if boss_reff.immune: # boss should be always be element aligned in this case
			if boss_reff.element_aligned == sign(spin):
				bounce(o_box, speed)
			else:
				damage_received(o_box)
				bounce(o_box, speed)
		else: # deal damage to boss
			bounce(o_box, speed)
	
	# deal damage if element of projectile and player differ
	# what happens when they are aligned is already handled by the projectile logic :p
	if o_box.name == "projectile-frost":
			if (o_box.get_parent().type == "fire" && sign(spin) == 1) || (o_box.get_parent().type == "frost" && sign(spin) == -1):
				# do nothing
				pass
			elif o_box.get_parent().type == "fire" || o_box.get_parent().type == "frost":
				damage_received(o_box)
	if o_box.name == "boss-projectile":
		damage_received(o_box)
	#if (o_box.name == "projectile-fire" && sign(spin) == 1) || (o_box.name == "projectile-frost" && sign(spin) == -1):
		## do nothing
		#pass
	#elif o_box.name == "projectile-fire" || o_box.name == "projectile-frost":
		#damage_received(o_box)

# what to do when actually damaged
func damage_received(o_box: Area2D) -> void:
	if invulf == 0: # if i-frames aren't active
		if spin == 0: 
			look_at(motion) # needs an additional offset, for some reason
			rotate(-PI/2)
		print("damage received!")
		health += -1 # for now, all enemies should deal 1 damage
		SignalBus.health_update.emit(health)
		bounce(o_box, 256)
		invulf = invulf_max
	
	# death state
	if health <= 0:
		print("player has died! figure out the respawn screen!")
		health = 0

# bouncing behavior when colliding with a given hitbox
func bounce(o_box: Area2D, knock: float) -> void:
	k = 0.01
	var r_pos = global_position - o_box.global_position
	motion = r_pos.normalized()
	#if speed < 8:
		#knock = 4 * knock
	speed = knock
