extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RigidBody2D/AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_pos = Vector2(0,0) #allows all enemies to know where player is
	
	
	if Global.player: 
		player_pos = Global.player.position
		
