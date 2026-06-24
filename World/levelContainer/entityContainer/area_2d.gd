extends Area2D
var target_location: Vector2
var speed #how fast projectile travels
var distance #how far projectile travels
var decay: bool #whether speed fades or no
var direction

func _ready() -> void:
	speed = 500
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	direction = (target_location - global_position).normalized()
	global_position += direction * speed * delta
	
	


func _on_body_entered(body: Node2D) -> void:
	print("Hit!")
	print(body.name)
