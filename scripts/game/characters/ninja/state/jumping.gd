extends State


func physics_update(delta: float) -> void:
	character.velocity.y = character.jump_velocity
