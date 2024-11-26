extends State


func enter_state() -> void:
	if (character as Fighter).can_attack():
		(character as Fighter).attack("kick")
		character.anim_tree["parameters/kick_shot/request"] = \
			AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
