extends CanvasLayer

func _process(_delta: float) -> void:
	if Input.is_action_just_released("spin-cw"): # delete self if restarting
		queue_free()
