extends Node2D
var cx
var cy
var theta
var radius
var orbit_speed
var explode: bool
var explode_speed: float
var acceleration: int
var max_explode_speed: int
var despawn_time: int # in seconds
var play_once: bool = false

# boss shield explodes after one seconds
func _ready() -> void:
	
	explode = false
	radius = 100
	orbit_speed = 2
	explode_speed = 10
	acceleration = 20
	max_explode_speed = 200
	despawn_time = 5.0
	play_once = true
	$Timer.wait_time = 1.0
	$Timer.one_shot = true
	$Timer.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#basic rotation
	
	if Global.boss:
		var boss = Global.boss
		cx = boss.global_position.x
		cy = boss.global_position.y
	
	
	global_position.x = cx + cos(theta) * radius
	global_position.y = cy + sin(theta) * radius
	theta += orbit_speed * delta
	
	if explode:
		if explode_speed < max_explode_speed:
			explode_speed += acceleration * delta
		radius += explode_speed * delta
		if play_once:
			$Timer.wait_time = despawn_time
			$Timer.start()
			play_once = false

func _on_timer_timeout() -> void:
	if explode:
		queue_free()
	else:
		explode = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemies"):
		print("hit enemy")
		queue_free()
	if area.get_parent().is_in_group("player"):
		print("hit player")
		queue_free()
