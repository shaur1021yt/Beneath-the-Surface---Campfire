extends CanvasLayer

@onready var textbox = $TextBox
@onready var dialogue_text = $TextBox/DialogueText
@onready var button_container = $TextBox/ButtonContainer
@onready var choice1 = $TextBox/ButtonContainer/Choice1
@onready var choice2 = $TextBox/ButtonContainer/Choice2
@onready var player = $"../Player"

@export var trigger_y_position: float = 5000.0

var dialogue_started = false
var state = 0
var waited_full_time = false

func _ready():
	textbox.visible = false
	button_container.visible = false
	
	choice1.pressed.connect(_on_choice1_pressed)
	choice2.pressed.connect(_on_choice2_pressed)
	


func _process(delta):
	if dialogue_started:
		return
	
	if player.global_position.y >= trigger_y_position:
		dialogue_started = true
		start_intro()

# ----------------------------
# INTRO
# ----------------------------

func start_intro():
	state = 0
	textbox.visible = true
	player.control_locked = true
	dialogue_text.text = "Press any key. Or don't. I'm not your mom."

func _input(event):
	if state == 0 and event.is_pressed():
		start_quiz()

# ----------------------------
# QUIZ (NO AUTO TIMERS NOW)
# ----------------------------

func start_quiz():
	state = 1
	dialogue_text.text = "Oh great, another soul falls into my domain."
	show_continue_button()

func start_question1():
	state = 2
	dialogue_text.text = "Red or blue?"
	show_choices("Red", "Blue")

func start_question2():
	state = 3
	dialogue_text.text = "What's 2 + 2?"
	show_choices("4", "5")

func start_question3():
	state = 4
	dialogue_text.text = "Don't press the button for 3 seconds."
	show_choices("Don't Press Me", "")
	
	waited_full_time = true
	await get_tree().create_timer(3).timeout
	
	if state == 4 and waited_full_time:
		dialogue_text.text = "You actually waited? That's so pathetic."
		show_continue_button()

# ----------------------------
# BUTTON LOGIC
# ----------------------------

func _on_choice1_pressed():
	handle_choice(choice1.text)

func _on_choice2_pressed():
	handle_choice(choice2.text)

func handle_choice(answer):
	waited_full_time = false
	button_container.visible = false
	
	if state == 1:
		start_question1()
	
	elif state == 2:
		if answer == "Red":
			dialogue_text.text = "Red? How original. Blue is clearly superior."
		else:
			dialogue_text.text = "Blue? Ugh, so predictable. Red has more passion."
		
		show_continue_button()
	
	elif state == 3:
		if answer == "4":
			dialogue_text.text = "Four? In this economy? It's five."
		else:
			dialogue_text.text = "Five? You think I'm made of numbers? It's four."
		
		show_continue_button()
	
	elif state == 4:
		dialogue_text.text = "Impatient, aren't we? I respect that. Still wrong."
		show_continue_button()
	
	elif state == 5:
		end_quiz()

func show_continue_button():
	state += 1
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
# END
# ----------------------------

func end_quiz():
	dialogue_text.text = "Ugh, you're exhausting. Time for you to fall."
	await get_tree().create_timer(2).timeout
	
	textbox.visible = false
	player.control_locked = false
