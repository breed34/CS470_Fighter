extends State


func physics_update(delta: float) -> void:
	if character.is_on_floor():
		character.anim_tree["parameters/move_trans/transition_request"] = "is_running"
	character.rotation.y = 0
	character.velocity.x = character.horiz_velocity
