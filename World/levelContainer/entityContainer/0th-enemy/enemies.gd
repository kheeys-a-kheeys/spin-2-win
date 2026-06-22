extends Node2D
var stopping_dist = 10 #stopping dist prevent jitter when trying to minor correct
var speed = 50

@onready var nav_agent = $NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CharacterBody2D/AnimatedSprite2D.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#var player_pos: Vector2 #allows all enemies to know where player is
	#
	#
	#if Global.player: 
		#player_pos = Global.player.global_position
		#
	##move to player
	#if player_pos:
		#
		#
		#if global_position.x < player_pos.x - stopping_dist \
		#or global_position.x > player_pos.x + stopping_dist \
		#or global_position.y < player_pos.y - stopping_dist \
		#or global_position.y > player_pos.y + stopping_dist:
			#position = position.move_toward(player_pos, delta * speed)
		#
		#else: 
			#print("contact")
		#
	#look_at(player_pos)		

func _physics_process(delta: float) -> void:
	var player_pos: Vector2
	var relatv_pos: Vector2
	if Global.player:
		player_pos = Global.player.global_position # find player's global position (from global)
		look_at(player_pos) 
	if player_pos:
		relatv_pos = global_position - player_pos # calc relative position
		nav_agent.target_position = player_pos # pass player position as target for nav_agent
		if relatv_pos.length() > stopping_dist: # analogous to the "is_target_reached" condition of NavAgent, more research required
			if nav_agent.is_target_reachable():
				position = position.move_toward(nav_agent.get_next_path_position(), delta * speed)
			else:
				print("player is out of bounds! or perhaps not instantiated?")
		else:
			print("too close!")
