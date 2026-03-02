extends CanvasLayer

@onready var textbox = $TextBox
@onready var dialogue_text = $TextBox/DialogueText
@onready var button_container = $TextBox/ButtonContainer
@onready var choice1 = $TextBox/ButtonContainer/Choice1
@onready var choice2 = $TextBox/ButtonContainer/Choice2
@onready var player = get_tree().current_scene.get_node("Player")
@onready var breaking_cobble = get_tree().current_scene.get_node("BreakingCobble")
@onready var demon_voice: AudioStreamPlayer2D = $DemonVoice
@export var trigger_y_position: float = 5000.0

var dialogue_started = false
var state = 0
var waited_full_time = false


func _ready():
	textbox.visible = false
	button_container.visible = false
	
	# Make sure text wraps properly in NinePatchRect
	dialogue_text.autowrap_mode = TextServer.AUTOWRAP_WORD
	dialogue_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dialogue_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	choice1.pressed.connect(_on_choice1_pressed)
	choice2.pressed.connect(_on_choice2_pressed)

func play_voice(path: String):
	if demon_voice.playing:
		demon_voice.stop()

	demon_voice.stream = load(path)
	demon_voice.play()
func _process(delta):
	if dialogue_started:
		return
	
	if player.global_position.y >= trigger_y_position:
		dialogue_started = true
		start_intro()


# ----------------------------
# START (NO PRESS ANY KEY)
# ----------------------------
func start_intro():
	textbox.visible = true
	player.control_locked = true
	start_quiz()


# ----------------------------
# QUIZ FLOWplay_voice()
# ----------------------------
func start_quiz():
	state = 1
	dialogue_text.text = "Oh great, another soul falls into my domain."
	play_voice("res://Sounds/GReat another soul falls.mp3")
	show_next()


func start_question1():
	state = 2
	dialogue_text.text = "Red or blue?"
	play_voice("res://Sounds/Red Or Blue.mp3")
	show_choices("Red", "Blue")


func start_question2():
	state = 3
	dialogue_text.text = "What's 2 + 2?"
	play_voice("res://Sounds/WHat is 2 +2 .mp3")
	show_choices("4", "5")


func start_question3():
	state = 4
	dialogue_text.text = "Don't press the button!"
	play_voice("res://Sounds/DOnt press button.mp3")
	show_choices("Don't Press Me", "")
	
	waited_full_time = true
	await get_tree().create_timer(3).timeout
	
	if state == 4 and waited_full_time:
		dialogue_text.text = "Wow. Such a Good Boy."
		play_voice("res://Sounds/WOW such a good boy.mp3")
		state = 40
		show_next()


# ----------------------------
# BUTTON HANDLING
# ----------------------------
func _on_choice1_pressed():
	handle_choice(choice1.text)


func _on_choice2_pressed():
	handle_choice(choice2.text)


func handle_choice(answer):
	button_container.visible = false
	
	if state == 1:
		start_question1()
	
	elif state == 2:
		if answer == "Red":
			play_voice("res://Sounds/Red How Og Blue better.mp3")
			dialogue_text.text = "Red? How original. Blue is clearly superior."
		else:
			play_voice("res://Sounds/Blue So predictable red better.mp3")
			dialogue_text.text = "Blue? Ugh, so predictable. Red is just...  Red"
		
		state = 20
		show_next()
	
	elif state == 3:
		if answer == "4":
			play_voice("res://Sounds/4 in this economy.mp3")
			dialogue_text.text = "Four? In this economy? Haven't you heard of inflation?? It's five."
		else:
			play_voice("res://Sounds/5 thats one too many.mp3")
			dialogue_text.text = "Five? Thats one too many... I'm pretty sure."
		
		state = 30
		show_next()
	
	elif state == 4:
		waited_full_time = false
		
		
		play_voice("res://Sounds/Slow and steady wins the race.mp3")
		dialogue_text.text = "Slow and steady wins the race. You lowkenuenly sold buddy."
		
		state = 40
		show_next()
	
	elif state == 20:
		start_question2()
	
	elif state == 30:
		start_question3()
	
	elif state == 40:
		end_quiz()


# ----------------------------
# BUTTON DISPLAY
# ----------------------------
func show_next():
	show_choices("NEXT", "")


func show_choices(text1, text2):
	button_container.visible = true
	
	choice1.text = text1
	choice1.visible = true
	
	if text2 != "":
		choice2.text = text2
		choice2.visible = true
	else:
		choice2.visible = false


# ----------------------------
# BREAK TILE
# ----------------------------
func break_all_cobble():
	breaking_cobble.clear()


# ----------------------------
# END
# ----------------------------
func end_quiz():
	play_voice("res://Sounds/Too much work Get out.mp3")
	dialogue_text.text = "This is too much work. GET OUT."
	await get_tree().create_timer(2).timeout
	
	break_all_cobble()
	
	textbox.visible = false
	player.control_locked = false
