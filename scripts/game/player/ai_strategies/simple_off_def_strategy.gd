class_name SimpleOffDefStrategy
extends Strategy


var _damage_threshold = 1.0/4.0
var _last_health

func decide(fighter: Fighter, opponent: Fighter) -> Array[String]:
	if _last_health == null:
		_last_health = fighter.get_health()
	
	var dir_to_opp = fighter.position.direction_to(opponent.position)
	var current_states: Array[String] = []
	var health_loss_ratio = (_last_health - fighter.get_health()) \
		/ fighter.start_health
	if health_loss_ratio < _damage_threshold:
		if _in_punch_range(fighter, opponent):
			current_states = ["stationary", "punching"]
		elif _in_kick_range(fighter, opponent):
			current_states = ["stationary", "kicking"]
		else:
			current_states = [_charging(dir_to_opp)]
	else:
		if _in_punch_range(opponent, fighter) \
		or _in_kick_range(opponent, fighter):
			current_states = [_retreating(dir_to_opp)]
		else:
			current_states = ["stationary"]
	
	_last_health = fighter.get_health()
	return current_states
