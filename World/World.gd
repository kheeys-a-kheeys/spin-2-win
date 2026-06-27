extends Node2D

@onready var Player = $Player
@onready var viewport_rect = get_viewport().get_visible_rect() # since our camera is following the player
@onready var Enemy_scene = preload("res://World/levelContainer/entityContainer/0th-enemy/enemies.tscn") # for spawn_enemy debug command
@onready var GameOverScreen = $GUI/GameOverScreen
@onready var GameWonScreen = $GUI/GameWonScreen
#var tutorial_check_once = true
#var tutorial_level = preload("res://World/levelContainer/tutorial level/tutorial_level.tscn")
#var cave_scene = preload("res://World/levelContainer/Level-Cave-0/Level-Cave-0.tscn")
#var central_level_scene = preload("res://level_central.tscn")
#var central_level = central_level_scene.instantiate()
#var tutorial = tutorial_level.instantiate()
func _ready() -> void:
	SignalBus.door_entered.connect(_on_door_entered)
	SignalBus.health_update.connect(_on_health_update)
	SignalBus.game_beaten.connect(_on_game_beaten)

	#$levelContainer.add_child(tutorial)

func _process(delta: float) -> void:
	##level changer
	#if tutorial_check_once:
		#if tutorial.finish_all:
			#for child in $levelContainer.get_children():
				#child.queue_free()
			#$levelContainer.add_child(central_level)
			#$Player.global_position = Vector2(0,0)
			#tutorial_check_once = false
			
		
	
	
	
	
	if Input.is_action_just_released("spin-cw"):
		if GameOverScreen.visible:
			# reset player
			Player.health = 3
			SignalBus.health_update.emit(Player.health)
			
			# reset level
			var levelpath = $levelContainer.get_child(0).scene_file_path
			$levelContainer.get_child(0).queue_free()
			var packed_level = load(levelpath)
			$levelContainer.add_child(packed_level.instantiate())
			
			# vanish gameover screen
			GameOverScreen.visible = false
		elif GameWonScreen.visible:
			# vanish win screen
			GameWonScreen.visible = false
		else:
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
	
	if !GameOverScreen.visible && !GameWonScreen.visible:
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
	
	# COMMENTED OUT FOR RAYCAST EXPERIMENT
	#Player.position = Player.position + Player.speed*Player.motion*delta
	#Player.eom()
	
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

# change level when player enters a door
func _on_door_entered(to_level: String, from_door: String) -> void:
	var levelContainer = $levelContainer
	levelContainer.get_child(0).queue_free()
	var packed_level = load(to_level)
	var instnt_level = packed_level.instantiate()
	levelContainer.add_child(instnt_level)
	instnt_level.door_transition(from_door)
	#if instnt_level.name == "Level-Central":
		#if from_door == "door-east":
			#print("player moved to: ", Global.player.global_position)

# control when a gameover occurs
func _on_health_update(new_value: int) -> void:
	if new_value <= 0:
		GameOverScreen.visible = true
		Player.speed = 0
		Player.global_position = $levelContainer.get_child(0).respawn_point

# for when the player beats the boss
func _on_game_beaten(restart_at: Vector2) -> void:
	# show win screen
	GameWonScreen.visible = true
	
	# reset player
	Player.global_position = restart_at
	Player.health = 3
	SignalBus.health_update.emit(Player.health)
	
	# reset game
	var levelpath = "res://World/levelContainer/Level-Central/Level-Central.tscn"
	$levelContainer.get_child(0).queue_free()
	var packed_level = load(levelpath)
	$levelContainer.add_child(packed_level.instantiate())
