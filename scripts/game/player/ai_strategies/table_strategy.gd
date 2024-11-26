class_name TableStrategy
extends Strategy


func decide(fighter: Fighter, opponent: Fighter) -> Array[String]:
	var current_states: Array[String] = []
	var dir_to_opp = fighter.position.direction_to(opponent.position)
	
	randomize()
	var sample = randf()
	if _in_punch_range(fighter, opponent) && fighter.can_attack():
		current_states = [_sample_in_punch_range(sample, dir_to_opp)]
	elif _in_kick_range(fighter, opponent) && fighter.can_attack():
		current_states = [_sample_in_kick_range(sample, dir_to_opp)]
	elif _is_charging(fighter, opponent):
		current_states = [_sample_is_charging(sample, dir_to_opp)]
	elif _is_retreating(fighter, opponent):
		current_states = [_sample_is_retreating(sample, dir_to_opp)]
	elif _is_stationary(opponent):
		current_states = [_sample_is_stationary(sample, dir_to_opp)]
	
	return current_states

func _sample_in_punch_range(sample: float, dir_to_opp: Vector3) -> String:
	if sample > 0.4:
		return "punching"
	elif sample > 0.2:
		return "kicking"
	elif sample > 0.1:
		return _retreating(dir_to_opp)
	else:
		return "stationary"
		

func _sample_in_kick_range(sample: float, dir_to_opp: Vector3) -> String:
	if sample > 0.4:
		return "kicking"
	elif sample > 0.2:
		return _charging(dir_to_opp)
	elif sample > 0.1:
		return _retreating(dir_to_opp)
	else:
		return "stationary"

func _sample_is_charging(sample: float, dir_to_opp: Vector3) -> String:
	if sample > 0.4:
		return "stationary"
	elif sample > 0.2:
		return _charging(dir_to_opp)
	else:
		return _retreating(dir_to_opp)

func _sample_is_retreating(sample: float, dir_to_opp: Vector3) -> String:
	if sample > 0.2:
		return _charging(dir_to_opp)
	else:
		return "stationary"

func _sample_is_stationary(sample: float, dir_to_opp: Vector3) -> String:
	if sample > 0.4:
		return _charging(dir_to_opp)
	elif sample > 0.2:
		return _retreating(dir_to_opp)
	else:
		return "stationary"
