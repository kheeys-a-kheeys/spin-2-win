extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CharacterBody2D/AnimatedSprite2D.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_pos: Vector2 #allows all enemies to know where player is
	var stopping_dist = 10 #stopping dist prevent jitter when trying to minor correct
	var speed = 50
	
	if Global.player: 
		player_pos = Global.player.global_position
		
	#move to player
	if player_pos:
		
		
		if global_position.x < player_pos.x - stopping_dist \
		or global_position.x > player_pos.x + stopping_dist \
		or global_position.y < player_pos.y - stopping_dist \
		or global_position.y > player_pos.y + stopping_dist:
			position = position.move_toward(player_pos, delta * speed)
		
	look_at(player_pos)		
		
		
