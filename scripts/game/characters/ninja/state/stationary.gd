extends State


func enter_state() -> void:
	character.anim_tree["parameters/death_trans/transition_request"] = "is_alive"

func physics_update(delta: float) -> void:
	if character.is_on_floor():
		character.anim_tree["parameters/move_trans/transition_request"] = "is_idle"
	character.velocity.x = 0
