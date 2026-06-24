extends Node2D
#offset for fire: (4,6)
#offset for frost: (0,2)
var type:String #frost or fire
var fire_png = preload("res://World/levelContainer/entityContainer/Boss/charge projectile/Fire Bullet.png")
var frost_png = preload("res://World/levelContainer/entityContainer/Boss/charge projectile/Frost Bullet1.png")
var boss_reff
var scale_base
var scale_max

func _ready() -> void:
	if type == "fire":
		$Area2D/Sprite2D.texture = fire_png
		$Area2D/Sprite2D.position = Vector2(4,6) #manual offsets
	else:
		$Area2D/Sprite2D.texture = frost_png
		$Area2D/Sprite2D.position = Vector2(0,2)


# Called every frame. 'delta' is the elapsed time since the previous frame.

#broken for now
func _physics_process(delta: float) -> void:
	boss_reff = Global.boss
	var direction = Vector2.RIGHT.rotated(boss_reff.rotation)
	global_position = Global.boss.global_position + direction * 200
	rotation = boss_reff.rotation
