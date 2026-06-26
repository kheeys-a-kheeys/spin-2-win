extends Node2D

var player_reff
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player.global_position = Vector2(0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
