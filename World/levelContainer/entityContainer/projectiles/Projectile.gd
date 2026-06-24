extends Node2D
var target_location: Vector2
var speed #how fast projectile travels
var distance #how far projectile travels
var decay: bool #whether speed fades or no
var decay_rate
var direction
var used
var frost_skin = preload("res://World/levelContainer/entityContainer/frost enemy/Frost Bullet.png")
var fire_skin = preload("res://World/levelContainer/entityContainer/projectiles/Fire Bullet.png")
var type: String #fire or frost

func _ready() -> void:
	speed = 500
	direction = (target_location - global_position).normalized()
	distance = 1000
	used = 0
	decay_rate = 100
	decay = true
	
	if type == "fire":
		$"projectile-frost/Sprite2D".texture = fire_skin
	else:
		$"projectile-frost/Sprite2D".texture = frost_skin



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	
	global_position += direction * speed * delta
	used += (direction * speed * delta).length()
	if used > distance or speed < 10:
		queue_free()
	
	if decay:
		speed -= decay_rate * delta
	
	

func _on_area_2d_area_entered(area: Area2D) -> void: #collision detection
	if area.get_parent().is_in_group("enemies"):
		print("hit enemy")
		queue_free()
	if area.get_parent().is_in_group("player"):
		var player_ref = Global.player
		if type == "frost":
			print("de")
			if player_ref.spin < 0: # make sure the bullet element matches this!
				print("the projectile phases through!")
			else:
				print("hit player")
				queue_free()
		else: #fire case
			if player_ref.spin > 0: # make sure the bullet element matches this!
				print("the projectile phases through!")
			else:
				print("hit player")
				queue_free()
