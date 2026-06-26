extends CanvasLayer

@onready var label = $"Panel/Moving Dialogue"
var fire_enemy_scene = preload("res://World/levelContainer/entityContainer/fire enemy/fire_enemy.tscn")
var play_once = true
var play_once1 = true
signal finish_dialogue

#enter dialogue here
var dialogue = [
	"Welcome brave adventurer",
	"This game is all about spining..",
	"Press the Left Mouse Button to spin Clockwise",
	"Press the Right Mouse Button to spin Counter-Clockwise",
	"You can gather more spin by repeatingly spinning in the same direction, then spin in the opposite direction and the player will move further in the direction of the mouse.",
	"Take some time to explore and get use to movement before making your way to the cave on the right..."
]

var current_line = 0
var typing = false

func _ready():
	show_line()

func show_line():
	label.text = dialogue[current_line]
	label.visible_characters = 0
	typing = true
	
	while label.visible_characters < label.text.length():
		label.visible_characters += 1
		await get_tree().create_timer(0.03).timeout
	
	typing = false



func _input(event):
	if event.is_action_pressed("ui_accept"):
		
		if typing:
			label.visible_characters = label.text.length()
			typing = false
			return
		
		current_line += 1
		
		if current_line < dialogue.size():
			show_line()
		else:
			finish_dialogue.emit()
			hide()

func introduce_enemy():
	dialogue = [
		"Well before you enter, i'm sure you notice the different effects you have while spinning",
		"All the heros have a special ability, yours is the elements, frost and fire",
		"The lands are littered with enemies, no where is safe accept your base.",
		"I have a few tips for fighting them",
		"They are two types of enemies, frost and fire, and they both shoot projectiles, so be sure to get in cover if you can't dodge them!",
		"You can also use your elemental powers to engage in combat: If your element aligns with the projectiles, the projectiles will phase right through you, otherwise, they deal heavy damage!",
		"To attack the enemy, you have to charge and hit the enemy with an opposite element to the enemy.",
		"Oh one more thing, enemies shoot in volleys!",
		"There should be an enemy in that cave, good luck!"
	]

	current_line = 0
	typing = false
	show()
	show_line()
	await finish_dialogue
	var fire_demo = fire_enemy_scene.instantiate()
	$"../Entity-Container".add_child(fire_demo)
	fire_demo.global_position = Vector2(750, 100)
	fire_demo.rotation = 180


func finish_tutorial():
	dialogue = [
		"Great job!",
		"Good luck adventurer.",
		"Press Space to teleport to main world"
	]


	current_line = 0
	typing = false
	show()
	show_line()
	await finish_dialogue
	$"..".finish_all = true
	print("all done here")
	

func _process(delta: float) -> void:
	var player_reff = Global.player
	if player_reff.global_position.x > 380:
		if play_once:
			introduce_enemy()
			play_once = false
	if player_reff.points > 0:
		if play_once1:
			finish_tutorial()
			play_once1 = false
