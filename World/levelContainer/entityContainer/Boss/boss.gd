extends Node2D
var health
var health_max: int = 1600
var trigger_box: = 500 #pixels for length, bounding box for enemy is created by x * x pixels wide, enemy is only activated if player is in the box
var in_reach: int #pixels, if in reach, boss can attack, similar to stopping distance
var left_down: Vector2
var right_up: Vector2
var count = 0
var motion: Vector2 = Vector2(0, 0)
var speed = 50
var boss_shield_projectile = preload("res://World/levelContainer/entityContainer/Boss/boss_shield_projectile.tscn")
var boss_charge = preload("res://World/levelContainer/entityContainer/Boss/charge projectile/boss_barrier.tscn")
var element_aligned: int = 0 # elemental alignment when performing charge attack, standard fire-frost convention
var immune: bool
#bear in mind boss is 96 pixels radius from centre

# variables to handle what "choices" the boss makes
var ab_perf_count: int = 0 # number of times any ability has been performed
var ability_cd: float = 0 # count up until it reaches the threshold
var ability_cd_max: float = 4.0 # in seconds
var barrier_cd: float = 4.0 # cooldown for barrier ability
var barrier_cd_max: float = 4.0
var prfrmng_ablty: bool = false # to control movement while performing an ability
var rng = RandomNumberGenerator.new()

@onready var nav_agent = $NavigationAgent2D
func _ready() -> void:
	Global.boss = self
	$boss/AnimatedSprite2D.play("idle")
	calculate_trigger_box(trigger_box, global_position)
	health = health_max
	in_reach = 150
	immune = false
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var player_pos = Global.player.global_position
	var relative_pos: Vector2
	var nxtpat_pos: Vector2
	
	if player_pos:
		#navigation
		if player_pos.x > left_down.x and player_pos.x < right_up.x and player_pos.y > left_down.y and player_pos.y < right_up.y:
			speed = 50
			look_at(player_pos)
			relative_pos = global_position - player_pos
			nav_agent.target_position = player_pos
			if relative_pos.length() > in_reach:
				if nav_agent.is_target_reachable():
					nxtpat_pos = nav_agent.get_next_path_position()
					nxtpat_pos = nxtpat_pos - global_position # shift frame
					motion = nxtpat_pos.normalized()
			else:
				speed = 0
		else:
			speed = 0
	
	if Input.is_action_just_pressed("Spawn-enemy"):
		charge_attack("fire")
	
	# decide whether to perform an ability
	#if ability_cd > ability_cd_max:
		#prfrmng_ablty = true
		#ability_machine(delta)
		#ability_cd = 0
	#else:
		#prfrmng_ablty = false
		#ability_cd += delta
	
	prfrmng_ablty = ability_machine(delta)
	
	# move if not performing an ability
	if !prfrmng_ablty:
		position = position + motion * speed * delta

# next three functions are for performing abilities
func ability_machine(delta: float) -> bool:
	## perform barrier attack first, then again every 3 shield attacks
	#if ab_perf_count % 3 == 0:
		#var element_choice = rng.randi_range(0, 1)
		#immune = false
		#if element_choice:
			#element_charging = 1
			#charge_attack("fire")
		#else:
			#element_charging = -1
			#charge_attack("frost")
		#ab_perf_count += 1
	#else:
		#shield_attack(8)
		#print("now do the shield attack")
		#ab_perf_count += 1
	
	# determine if abilities are off cooldown
	var ability_off_cd = (ability_cd >= ability_cd_max)
	var barrier_off_cd = (barrier_cd >= barrier_cd_max)
	
	# charge attack term
	if barrier_off_cd:
		var element_choice = rng.randi_range(0, 1)
		immune = true
		if element_choice:
			element_aligned = 1
			charge_attack("fire")
		else:
			element_aligned = -1
			charge_attack("frost")
		barrier_cd = 0
	else:
		barrier_cd += delta
	
	# shield attack term
	if ability_off_cd:
		shield_attack(8)
		ability_cd = 0
	else:
		ability_cd += delta
	
	ability_off_cd = (ability_cd >= ability_cd_max)
	barrier_off_cd = (barrier_cd >= barrier_cd_max)
	return ability_off_cd || barrier_off_cd

func shield_attack(pro_num): #controls how many orbs spawn
	for i in range(pro_num): 
		var boss_shield = boss_shield_projectile.instantiate()
		boss_shield.theta = (TAU / pro_num) * i 
		#print((TAU / pro_num) * i )
		get_parent().add_child(boss_shield)

func charge_attack(type):
	var charge_ball = boss_charge.instantiate()
	charge_ball.type = type
	get_parent().add_child(charge_ball)


func calculate_trigger_box(dimensions, centre_position):
	#calculate two then use to see if within 
	left_down.x = centre_position.x - dimensions / 2
	left_down.y = centre_position.y - dimensions / 2
	right_up.x = centre_position.x + dimensions / 2
	right_up.y = centre_position.y + dimensions / 2

# next 3 functions copied from frost_enemy script
# bounce function is excluded; immune to knockback
func _on_boss_area_entered(o_box: Area2D) -> void:
	damage_machine(o_box)

func damage_machine(o_box: Area2D) -> void:
	var player_ref = Global.player
	var spin = player_ref.spin
	
	# deal damage on attack if enemy is opposite element to player
	# only applies when the barrier is launched
	if o_box.name == "player-shape":
		if !immune:
			if sign(spin) != element_aligned:
				damage_received(player_ref.damage)

func damage_received(damage: int) -> void:
	# damage
	health += -damage
	print("boss health is: ", health)
	
	# death state
	if health <= 0:
		health = 0
		Global.player.points += 1
		#queue death animation
		queue_free()
