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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explode = false
	radius = 100
	orbit_speed = 2
	explode_speed = 10
	acceleration = 20
	max_explode_speed = 200
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#basic rotation
	if Input.is_action_just_pressed("debug"):
		explode = true
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
			print(explode_speed)
		radius += explode_speed * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemies"):
		print("hit enemy")
		queue_free()
	if area.get_parent().is_in_group("player"):
		print("hit player")
		queue_free()
