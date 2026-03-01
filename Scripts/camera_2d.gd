extends Camera2D

@export var button: Node2D
@export var player: Node2D

var following_player = false

func _process(delta):
	if following_player:
		global_position = player.global_position
	else:
		global_position = button.global_position

func switch_to_player():
	following_player = true
