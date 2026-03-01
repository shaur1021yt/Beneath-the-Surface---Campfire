extends Control
class_name StartMenu

signal play_pressed

func _on_button_pressed() -> void:
	play_pressed.emit()
