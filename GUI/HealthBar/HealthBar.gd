extends CanvasLayer

# good thing we don't need to scale this haha... ha... haa...

@onready var heart0 = $"health-bar/heart0"
@onready var heart1 = $"health-bar/heart1"
@onready var heart2 = $"health-bar/heart2"

func _ready() -> void:
	if Global.player:
		var player_ref = Global.player
		set_health(player_ref.health)
		SignalBus.health_update.connect(_on_health_update)

func _on_health_update(new_value) -> void:
	#var player_ref = Global.player
	set_health(new_value)
	print("signal received!", new_value)

func set_health(hp_target: int) -> void:
	var health_bar = [heart0, heart1, heart2]
	# first we clear the health bar, then we we update to the appropriate amount
	# very lazy
	for i in health_bar.size():
		var heart_sprite = health_bar[i].get_child(0)
		heart_sprite.frame = 1
	for i in hp_target:
		var heart_sprite = health_bar[i].get_child(0)
		heart_sprite.frame = 0
