extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var player = $"../Player"
@onready var breaking_cobble = $"../BreakingCobble"   # Change if node name is different
@onready var dialogue_ui: CanvasLayer = $"../DialogueUI"

@export var trigger_y_position: float = 5000.0

var triggered := false

func _ready():
	anim.play("idle")

func _process(delta):
	if triggered:
		return
	
	if player.global_position.y >= trigger_y_position:
		triggered = true
		start_dialogue()

func start_dialogue():
	player.control_locked = true
	
	# Tell your UI to start
	dialogue_ui.start_intro()

func break_cobble_under_player():
	var tile_pos = breaking_cobble.local_to_map(
		breaking_cobble.to_local(player.global_position)
	)
	
	breaking_cobble.set_cell(0, tile_pos, -1)
