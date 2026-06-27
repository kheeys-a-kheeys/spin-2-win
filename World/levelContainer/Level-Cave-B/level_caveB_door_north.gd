extends Sprite2D
# this is a special door that ends the game!

var shut: bool = true # whether door is accessible or not, for encounters

# variable for when this door is called
# REMEMBER: level has to be instantiated first BEFORE we move the player!
@onready var exit_point: Vector2 = $"exit-point".global_position

func _ready() -> void:
	SignalBus.boss_defeated.connect(_on_boss_defeated)

func _on_door_entered(area: Area2D) -> void:
	if area.name == "player-shape":
		if !shut:
			# send a signal to activate the "You Win!" screen
			SignalBus.game_beaten.emit(Vector2(60.0, 69.0))

func _on_boss_defeated(boss_id: String) -> void:
	if boss_id == "boss":
		frame = 0 # switch sprite frame to open
		shut = false
