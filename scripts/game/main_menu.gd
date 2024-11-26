class_name MainMenu
extends Control


@export var play_button: Button

func _ready() -> void:
	play_button.pressed.connect(func ():
		SceneManager.set_current_scene("game")
		get_tree().paused = false)
