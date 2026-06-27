extends CanvasLayer
var boss_max_health
var boss_health
@onready var boss = $"../entityContainer/Boss"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/CenterContainer/VBoxContainer/ProgressBar.value = 100
	boss_max_health = $"../entityContainer/Boss".health_max



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(boss):
		boss_health = $"../entityContainer/Boss".health
		#print((boss_health / boss_max_health) * 100)
		$MarginContainer/CenterContainer/VBoxContainer/ProgressBar.value = (float(boss_health) / boss_max_health) * 100
	else:
		$MarginContainer/CenterContainer/VBoxContainer/ProgressBar.value = 0
