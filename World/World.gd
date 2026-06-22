extends Node2D

@onready var Player = $Player
@onready var viewport_rect = get_viewport().get_visible_rect() # since our camera is following the player

func _process(delta: float) -> void:
	if Input.is_action_just_released("spin-cw"):
		if Player.spin != 1:
			Player.spin = 1
			var point = mouse_target()
			Player.speed = 512.0 * max(1, abs(Player.omega)) # in pixels
			Player.motion = point.normalized()
			Player.k = 0.01
			if Player.omega == 0:
				Player.omega = 1
			else:
				Player.omega = maxi(1, -Player.omega - 1)
		else:
			Player.omega = mini(3, Player.omega + 1)
		print("spin magnitude is: ", Player.omega)
	
	if Input.is_action_just_released("spin-ccw"):
		if Player.spin != -1:
			Player.spin = -1
			var point = mouse_target()
			Player.speed = 512.0 * max(1, abs(Player.omega)) # in pixels
			Player.motion = point.normalized()
			Player.k = 0.01
			if Player.omega == 0:
				Player.omega = -1
			else:
				Player.omega = mini(-1, -Player.omega + 1)
		else:
			Player.omega = maxi(-3, Player.omega - 1)
		print("spin magnitude is: ", Player.omega)
	
	Player.set_frame()
	Player.spin_frame(delta)

func _physics_process(delta: float) -> void:
	#if Player.speed < 64:
		#Player.spin = 0 # gives some leeway in movement
	
	Player.position = Player.position + Player.speed*Player.motion*delta
	Player.eom()
	
	var target = mouse_target()
	Player.aligning(target)

# return mouse position relative to the viewport center
func mouse_target() -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position()
	return mouse_pos - viewport_rect.get_center()
