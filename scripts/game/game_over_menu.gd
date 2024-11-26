extends Control


@export var play_again_button: Button
@export var quit_button: Button

func _ready() -> void:
	play_again_button.pressed.connect(func ():
		SceneManager.set_current_scene("game")
		SceneManager.hide_overlay()
		get_tree().paused = false)
	quit_button.pressed.connect(func ():
		SceneManager.set_current_scene("main_menu")
		SceneManager.hide_overlay())
