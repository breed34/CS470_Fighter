extends State


func enter_state() -> void:
	if (character as Fighter).can_attack():
		(character as Fighter).attack("punch")
		character.anim_tree["parameters/punch_shot/request"] = \
			AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
