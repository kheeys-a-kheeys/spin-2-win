extends Node2D

@onready var Player = $Player
@onready var viewport_rect = get_viewport().get_visible_rect() # since our camera is following the player

func _process(delta: float) -> void:
	if Input.is_action_just_released("spin-cw"):
		if Player.spin != 1:
			Player.spin = 1
			var mous = get_viewport().get_mouse_position()
			var point = mous - viewport_rect.get_center()
			Player.speed = 512.0 # in pixels
			Player.target = point.normalized()
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
			var mous = get_viewport().get_mouse_position()
			var point = mous - viewport_rect.get_center()
			Player.speed = 512.0 # in pixels
			Player.target = point.normalized()
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

# light checklist
# another vector, an ACTUAL target vector, that the motion vector will attempt to align with
# 	this allows some control while moving and should be better for game-feel
# 	i need to dig deep to recall the relevant gnc concepts, matlab calls to me...
func _physics_process(delta: float) -> void:
	#if Player.speed < 64:
		#Player.spin = 0 # gives some leeway in movement
	
	Player.position = Player.position + Player.speed*Player.target*delta
	Player.eom()
