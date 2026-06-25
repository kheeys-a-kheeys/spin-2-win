extends Node2D

var type: String #frost or fire
#var fire_png = preload("res://World/levelContainer/entityContainer/Boss/charge projectile/Fire Bullet.png")
#var frost_png = preload("res://World/levelContainer/entityContainer/Boss/charge projectile/Frost Bullet1.png")
#var boss_reff
var scale_base
var scale_max

var speed: float = 0
var k: float = 0.01
var was_launched: bool = false # condition for queue_free()
var launch_targe: Vector2 # provided by boss input


@onready var barrier_sprite = $"boss-barrier/Sprite2D"
@onready var boss_reff = Global.boss

func _ready() -> void:
	if type == "fire":
		barrier_sprite.frame = 1
	else:
		barrier_sprite.frame = 0

#broken for now
func _physics_process(delta: float) -> void:
	#boss_reff = Global.boss
	#var direction = Vector2.RIGHT.rotated(boss_reff.rotation)
	
	# need to verify if the boss hasn't been despawned yet
	if boss_reff:
		# launch after 2.5 seconds
		var barrier_cd = boss_reff.barrier_cd
		if (barrier_cd > 2.5) && !was_launched:
			launch(256, boss_reff.motion)
			boss_reff.immune = false
			boss_reff.element_aligned = 0
	
	if !was_launched:
		global_position = Global.boss.global_position
		rotation = boss_reff.rotation
	else:
		if !(speed > 0): # despawn when barrier has decelerated sufficiently
			queue_free()
		else:
			global_position += speed*launch_targe*delta
			damp()

# called in the boss function for this ability
func launch(speed_in: float, dir: Vector2) -> void:
	speed = speed_in
	launch_targe = dir
	was_launched = true

# damping function for when we want to launch this thing
func damp() -> void:
	k += 0.05*k
	k = min(1, k)
	speed = (1 - k)*speed


func _on_bossbarrier_area_entered(area: Area2D) -> void: #phase through if same element, else destroy
	if area.get_parent().is_in_group("enemies"):
		print("hit enemy")
		boss_reff.immune = false
		queue_free()
	if area.get_parent().is_in_group("player"):
		var player_ref = Global.player
		if type == "frost":
			print("de")
			if player_ref.spin < 0: # make sure the bullet element matches this!
				print("the projectile phases through!")
			else:
				print("hit player")
				boss_reff.immune = false
				queue_free()
		else: #fire case
			if player_ref.spin > 0: # make sure the bullet element matches this!
				print("the projectile phases through!")
			else:
				print("hit player")
				boss_reff.immune = false
				queue_free()
