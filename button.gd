extends Button

func _on_pressed():
	$"../Camera2D".switch_to_player()
