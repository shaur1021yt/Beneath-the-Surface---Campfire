extends Camera2D

@export var player: Node2D   # Drag Player here in Inspector
@export var button: Node2D   # Drag Button here in Inspector

var following_player := false

func _ready():
	# Start by looking at the button
	if button:
		global_position = button.global_position

func _process(delta):
	# Smooth follow AFTER switch
	if following_player and player:
		global_position = player.global_position

func switch_to_player():
	if player == null:
		print("Player not assigned in Camera!")
		return
	
	following_player = false
	
	# Optional dramatic wait
	await get_tree().create_timer(1.0).timeout
	
	# Smooth pan to player
	var tween = create_tween()
	tween.tween_property(self, "global_position", player.global_position, 2.0) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	
	# Now start smooth follow
	following_player = true
