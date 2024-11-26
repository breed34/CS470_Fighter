class_name Strategy
extends Node


func decide(fighter: Fighter, opponent: Fighter) -> Array[String]:
	return []

func _in_punch_range(fighter: Fighter, opponent: Fighter) -> bool:
	return opponent in fighter.punch_area \
		.get_overlapping_bodies()

func _in_kick_range(fighter: Fighter, opponent: Fighter) -> bool:
	return opponent in fighter.kick_area \
		.get_overlapping_bodies()

func _is_charging(fighter: Fighter, opponent: Fighter) -> bool:
	return opponent.velocity.x \
		* opponent.position.direction_to(fighter.position).x > 0

func _is_retreating(fighter: Fighter, opponent: Fighter) -> bool:
	return opponent.velocity.x \
		* opponent.position.direction_to(fighter.position).x < 0

func _is_stationary(opponent: Fighter):
	return opponent.velocity.x == 0

func _charging(dir_to_opp: Vector3) -> String:
	return "moving_left" if dir_to_opp.x < 0 else "moving_right"

func _retreating(dir_to_opp: Vector3) -> String:
	return "moving_left" if dir_to_opp.x > 0 else "moving_right"
