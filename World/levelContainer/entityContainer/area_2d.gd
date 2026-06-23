extends Area2D
var target_location



func _ready() -> void:
	if Global.player:
		target_location = Global.player
		print(target_location)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
