class_name UserPlayer
extends Player


func act(fighter: Fighter, physics_delta: float) -> void:
	if not is_dead:
		var current_states: Array[String] = []
		if Input.is_action_just_pressed("up") and fighter.is_on_floor():
			current_states.append("jumping")
		elif not fighter.is_on_floor():
			current_states.append("falling")

		if Input.is_action_pressed("right"):
			current_states.append("moving_right")
		elif Input.is_action_pressed("left"):
			current_states.append("moving_left")
		else:
			current_states.append("stationary")

		if Input.is_action_just_pressed("punch") \
		and fighter.can_attack():
			current_states.append("punching")

		if Input.is_action_just_pressed("kick") \
		and fighter.can_attack():
			current_states.append("kicking")

		fighter.state_machine.set_current_states(current_states)
	else:
		fighter.state_machine.set_current_states(["dead"])
