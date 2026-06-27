extends Node

signal health_update(new_value: int) # for when we want to update the health bar
signal boss_defeated(boss_id: String) # signal for when boss is slain
signal game_beaten(restart_at: Vector2) # win state!

# to_level is a scene filepath, from_door is the name of the target sprite2D node
signal door_entered(to_level: String, from_door: String)
