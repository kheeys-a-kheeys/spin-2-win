extends Node2D

@onready var Player = $Player
@onready var viewport_rect = get_viewport().get_visible_rect() # since our camera is following the player
@onready var Enemy_scene = preload("res://World/levelContainer/entityContainer/0th-enemy/enemies.tscn") # for spawn_enemy debug command

func _ready() -> void:
	SignalBus.door_entered.connect(_on_door_entered)

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
	
	#if Input.is_action_just_pressed("Spawn-enemy"): #test for spawning enemies
		#spawn_enemy(Vector2(100, 100), 50)
	
	Player.set_frame()
	Player.spin_frame(delta)


# return mouse position relative to the viewport centerfunc _physics_process(delta: float) -> void:
	#if Player.speed < 64:
		#Player.spin = 0 # gives some leeway in movement
	
	Player.position = Player.position + Player.speed*Player.motion*delta
	Player.eom()
	
	var target = mouse_target()
	if Player.spin != 0:
		Player.aligning(target)

func mouse_target() -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position()
	return mouse_pos - viewport_rect.get_center()

# debug functions
func spawn_enemy(pos, speed):
	var enemy = Enemy_scene.instantiate()
	enemy.position = pos
	enemy.speed = speed
	add_child(enemy)

func _on_door_entered(to_level: String, from_door: String) -> void:
	var levelContainer = $levelContainer
	levelContainer.get_child(0).queue_free()
	var packed_level = load(to_level)
	var instnt_level = packed_level.instantiate()
	levelContainer.add_child(instnt_level)
	instnt_level.door_transition(from_door)
