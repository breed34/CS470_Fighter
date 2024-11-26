class_name AIPlayer
extends Player


var _action_cooldown = 0.8
var _can_act = true
var _current_states: Array[String] = ["stationary"]
var _strategy: Strategy

static func with_strat(strat: Strategy) -> AIPlayer:
	var p = AIPlayer.new()
	p._strategy = strat
	p.add_child(strat)
	return p

func act(fighter: Fighter, physics_delta: float) -> void:
	if not is_dead:
		if _can_act:
			var opponent = fighter.get_opponent()
			_current_states = _strategy.decide(fighter, opponent)
			_can_act = false
			get_tree().create_timer(_action_cooldown).timeout.connect(
				func (): _can_act = true)

		fighter.state_machine.set_current_states(_current_states)
	else:
		fighter.state_machine.set_current_states(["dead"])
