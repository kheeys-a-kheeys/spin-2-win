extends Node2D
var health
var trigger_box: = 500 #pixels for length, bounding box for enemy is created by x * x pixels wide, enemy is only activated if player is in the box
var in_reach: int #pixels, if in reach, boss can attack, similar to stopping distance
var left_down: Vector2
var right_up: Vector2
var count = 0
var motion: Vector2 = Vector2(0, 0)
var speed = 50
#bear in mind boss is 96 pixels radius from centre

@onready var nav_agent = $NavigationAgent2D
func _ready() -> void:
	$Area2D/AnimatedSprite2D.play("idle")
	calculate_trigger_box(trigger_box, global_position)
	in_reach = 120




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
		
	position = position + motion * speed * delta

func calculate_trigger_box(dimensions, centre_position):
	#calculate two then use to see if within 
	left_down.x = centre_position.x - dimensions / 2
	left_down.y = centre_position.y - dimensions / 2
	right_up.x = centre_position.x + dimensions / 2
	right_up.y = centre_position.y + dimensions / 2
