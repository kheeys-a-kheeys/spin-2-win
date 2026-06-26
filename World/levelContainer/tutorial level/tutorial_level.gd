extends Node2D
var fire_enemy_scene = preload("res://World/levelContainer/entityContainer/fire enemy/fire_enemy.tscn")
var frost_enemy_scene = preload("res://World/levelContainer/entityContainer/frost enemy/frost_enemy.tscn")
var player_reff
var tutorial_complete = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../../Player".global_position = Vector2(50,50)
	$"../../Player".invincible = true

	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.player:
		player_reff = Global.player
	if player_reff.points > 0:
		tutorial_complete = true
