extends Node2D
var stopping_dist = 130 #stopping dist prevent jitter when trying to minor correct
var k: float = 0.01 # spring constant analog, ours is time dependant
var speed = 100
var speed_max: float = 100 # entity should accelerate to this number
var motion: Vector2 = Vector2(0, 0) # direction of velocity, unit vector
var health: int = 100
var trigger_distance = 10000 #to play around later
var fire_projectile_scene = preload("res://World/levelContainer/entityContainer/projectiles/bullet.tscn")
var can_shoot = true

# attack properties
var proj_cd: float = 2 # cooldown on projectile attack
var proj_ar: float = 0.2 # fire rate of projectiles
var proj_ct: int = 0 # number of projectiles the enemy has fired in one attack

@onready var nav_agent = $NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"enemy-fire/AnimatedSprite2D".play("idle")
	add_to_group("frost")


func _physics_process(delta: float) -> void:
	var player_pos: Vector2 # player position
	var relatv_pos: Vector2 # relative position between enemy and player
	var nxtpat_pos: Vector2 # for navmesh pathfinding
	
	if Global.player:
		player_pos = Global.player.global_position # find player's global position (from global)
		look_at(player_pos) 
	if player_pos:
		relatv_pos = global_position - player_pos # calc relative position
		nav_agent.target_position = player_pos # pass player position as target for nav_agent
		if relatv_pos.length() > stopping_dist and relatv_pos.length() < trigger_distance: # analogous to the "is_target_reached" condition of NavAgent, more research required
			if nav_agent.is_target_reachable():
				#position = position.move_toward(nav_agent.get_next_path_position(), delta * speed)
				nxtpat_pos = nav_agent.get_next_path_position()
				nxtpat_pos = nxtpat_pos - global_position # shift frame
				motion = nxtpat_pos.normalized()
				#position = position + speed*motion*delta
				look_at(nav_agent.get_next_path_position())
			else:
				print("player is out of bounds! or perhaps not instantiated?")
		else:
			damp()
			ability_shoot_projectile(delta)
	
	$"enemy-fire/ProgressBar".value = health
	if health == 100:
		pass
		# $Area2D/ProgressBar.visible = false
	else:
		$"enemy-fire/ProgressBar".visible = true
	
	# dynamics term
	position = position + speed*motion*delta
	if speed < 0:
		damp()
	else:
		if speed < speed_max:
			speed += 64 * delta
	
	if Input.is_action_just_pressed("Spawn-enemy"): # test
		ability_shoot_projectile(delta)

# speed damping function, it is was it is
func damp() -> void:
	k += 0.1*k
	k = min(1, k)
	speed = (1 - k)*speed

func ability_shoot_projectile(delta: float):
	if proj_ct < 5: # limit number of projectiles launced in one volley
		can_shoot = true
		if proj_ar < 0: # set a pause between each projectile shot
			shoot_projectile()
			proj_ct += 1
			proj_ar = 0.2
		else:
			proj_ar += -delta
	else:
		if proj_cd > 0: # set cooldown after 5 projectiles launched
			can_shoot = false
			proj_cd += -delta
		else:
			can_shoot = true
			proj_ct = 0
			proj_cd = 2
	

func shoot_projectile() -> void:
	var fire_projectile = fire_projectile_scene.instantiate()
	fire_projectile.type = "fire"
	fire_projectile.global_position = global_position
	fire_projectile.target_location = Global.player.global_position
	get_tree().current_scene.add_child(fire_projectile)

	
func _on_enemyfire_area_entered(o_box: Area2D) -> void:
	damage_machine(o_box)

# copy pasted from the player script
# func to set the enemy's damage state based on a number of conditions
# again, o_box names should probably be in a dictionary
func damage_machine(o_box: Area2D) -> void:
	var player_ref = Global.player
	var spin = player_ref.spin
	
	# deal damage on attack if enemy is opposite element to player
	# this enemy is frost, soooo
	if o_box.name == "player-shape":
		if sign(spin) == -1:
			damage_received(player_ref.damage)
		else: # just bounce off attack
			bounce()


# what to do when actually damaged
func damage_received(damage: int) -> void:
	# damage
	health += -damage # this enemy dies in one hit
	bounce()
	
	# death state
	if health <= 0:
		health = 0
		Global.player.points += 1
		#queue death animation
		queue_free()

# bouncing behavior when colliding with a given hitbox
# since enemies are controlled with a constant speed (instead of an impulse)
# it's easier to just make the enemy's speed negative,
# apply damping to negative speed,
# then apply acceleration to return it to max speed
func bounce() -> void:
	k = 0.01
	var knock = 512 # knockback - should probably be a function input
	speed = -knock
