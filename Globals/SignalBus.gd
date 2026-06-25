extends Node

signal health_update(new_value: int) # for when we want to update the health bar

# to_level is a scene filepath, from_door is the name of the target sprite2D node
signal door_entered(to_level: String, from_door: String)
