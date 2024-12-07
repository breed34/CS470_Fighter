class_name SimpleOffDefStrategy
extends Strategy


const CORRECT_PROB = 0.9

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
		current_states = _pick_strat_with_prob(
			_offensive_strategy, 
			_defensive_strategy, 
			CORRECT_PROB).call(fighter, opponent)
	else:
		current_states = _pick_strat_with_prob(
			_defensive_strategy, 
			_offensive_strategy, 
			CORRECT_PROB).call(fighter, opponent)
	
	_last_health = fighter.get_health()
	return current_states

func _pick_strat_with_prob(pref: Callable, scnd: Callable, p: float) -> Callable:
	var r = randf()
	return pref if r < p else scnd

func _offensive_strategy(fighter: Fighter, opponent: Fighter) -> Array[String]:
	var states: Array[String]
	var dir_to_opp = fighter.position.direction_to(opponent.position)
	if _in_punch_range(fighter, opponent):
		states = ["stationary", "punching"]
	elif _in_kick_range(fighter, opponent):
		states = ["stationary", "kicking"]
	else:
		states = [_charging(dir_to_opp)]

	return states

func _defensive_strategy(fighter: Fighter, opponent: Fighter) -> Array[String]:
	var states: Array[String]
	var dir_to_opp = fighter.position.direction_to(opponent.position)
	if _in_punch_range(opponent, fighter) \
	or _in_kick_range(opponent, fighter):
		states = [_retreating(dir_to_opp)]
	else:
		states = ["stationary"]

	return states
