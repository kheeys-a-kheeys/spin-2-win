extends CanvasLayer

@onready var label = $"Panel/Moving Dialogue"

#enter dialogue here
var dialogue = [
	"Welcome.",
	"Spin to win!",
	"Good luck."
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
			hide()
