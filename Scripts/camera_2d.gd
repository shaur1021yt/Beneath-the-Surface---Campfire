extends Camera2D

var is_in_menu := false
@export var player_path : NodePath
var player

func _ready():
	player = get_node(player_path)

func _process(delta):
	if player:
		global_position = player.global_position
