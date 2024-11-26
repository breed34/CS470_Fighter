extends State


func physics_update(delta: float) -> void:
	character.anim_tree["parameters/move_trans/transition_request"] = "is_falling"
	character.velocity.y += character.gravity * delta
