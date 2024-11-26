class_name Game
extends Node3D


@export var fighter1: Fighter
@export var fighter2: Fighter
@export var game_over_delay: float

@onready var game_over = false

func _process(delta: float) -> void:
	if fighter1.get_health() == 0 or fighter2.get_health() == 0:
		if not game_over:
			game_over = true
			get_tree().create_timer(game_over_delay).timeout.connect(func ():
				get_tree().paused = true
				SceneManager.show_overlay("game_over_menu"))

func get_fighters() -> Array[Fighter]:
	return [fighter1, fighter2]
