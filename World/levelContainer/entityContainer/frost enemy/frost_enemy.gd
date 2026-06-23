extends Node2D
var stopping_dist = 130 #stopping dist prevent jitter when trying to minor correct
var speed = 100
var speed_max: float = 100 # entity should accelerate to this number
var motion: Vector2 = Vector2(0, 0) # direction of velocity, unit vector
var health = 100
var trigger_distance = 10000 #to play around later
var frost_projectile_scene = preload("res://World/levelContainer/entityContainer/bullet.tscn")
var can_shoot = true

@onready var nav_agent = $NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D/AnimatedSprite2D.play("idle")
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
				position = position + speed*motion*delta
				look_at(nav_agent.get_next_path_position())
			else:
				print("player is out of bounds! or perhaps not instantiated?")
		else:
			shoot_projectile()
			
	$Area2D/ProgressBar.value = health
	if health == 100:
		pass
		# $Area2D/ProgressBar.visible = false
	else:
		$Area2D/ProgressBar.visible = true
			
			
	if Input.is_action_just_pressed("Spawn-enemy"): # test
		shoot_projectile()
		
			
func shoot_projectile():
	if can_shoot:
		var frost_projectile = frost_projectile_scene.instantiate()
		frost_projectile.global_position = global_position
		frost_projectile.target_location = Global.player.global_position
		get_tree().current_scene.add_child(frost_projectile)
		can_shoot = false
		await get_tree().create_timer(0.2).timeout #easy one second pause
		can_shoot = true
	
