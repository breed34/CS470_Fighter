extends State


func enter_state() -> void:
	character.anim_tree["parameters/death_trans/transition_request"] = "is_dead"
