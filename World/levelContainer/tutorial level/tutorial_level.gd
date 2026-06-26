extends Node2D
var fire_enemy_scene = preload("res://World/levelContainer/entityContainer/fire enemy/fire_enemy.tscn")
var frost_enemy_scene = preload("res://World/levelContainer/entityContainer/frost enemy/frost_enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#intialize boundaries
	Global.world_boundaries_left = -129
	Global.world_boundaries_right = 427
	Global.world_boundaries_up = 3
	Global.world_boundaries_down = 694
	
	#create enemies
	var fire_demo = fire_enemy_scene.instantiate()
	$"Entity-Container".add_child(fire_demo)
	fire_demo.global_position = Vector2(750, 100)
	fire_demo.rotation = 180
	fire_demo.tutorial_mode = false
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pathway_detection_area_entered(area: Area2D) -> void:
	if area.name == "player-shape":
		Global.world_boundaries_left = 425
		Global.world_boundaries_right = 525
		Global.world_boundaries_up = 40
		Global.world_boundaries_down = 176


func _on_cave_detection_area_entered(area: Area2D) -> void:
	if area.name == "player-shape":
		Global.world_boundaries_left = 519
		Global.world_boundaries_right = 813
		Global.world_boundaries_up = 27
		Global.world_boundaries_down = 309


func _on_grass_dectection_area_entered(area: Area2D) -> void:
	if area.name == "player-shape":
		Global.world_boundaries_left = -129
		Global.world_boundaries_right = 427
		Global.world_boundaries_up = 3
		Global.world_boundaries_down = 694
