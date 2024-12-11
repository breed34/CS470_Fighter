class_name ActionSimulator

const FRAMES_TO_SIM = 20.0
const TRAVELED_PER_FRAME = 0.17
const PUNCH_DAMAGE = 10.0
const KICK_DAMAGE = 20.0
const PUNCH_COOLDOWN_FRAMES = 18
const KICK_COOLDOWN_FRAMES = 24

static func simulate_action(action: String, state: FighterState2):
	var new = state.copy()
	match action:
		"moving_left":
			new.opp_orientation = 1
			new.x -= TRAVELED_PER_FRAME * FRAMES_TO_SIM
			new.x = _resolve(new.x, new.opp_x, new.orientation)
		"moving_right":
			new.opp_orientation = 2
			new.x += TRAVELED_PER_FRAME * FRAMES_TO_SIM
			new.x = _resolve(new.x, new.opp_x, new.orientation)
		"punching":
			if new.attack_cooldown == 0:
				new.attack_cooldown = PUNCH_COOLDOWN_FRAMES

				if _facing_opp(new.x, new.opp_x, new.orientation) \
				and abs(new.x - new.opp_x) < 2.4:
					new.opp_health -= PUNCH_DAMAGE
		"kicking":
			if new.attack_cooldown == 0:
				new.attack_cooldown = KICK_COOLDOWN_FRAMES

				if _facing_opp(new.x, new.opp_x, new.orientation) \
				and abs(new.x - new.opp_x) < 3.4:
					new.opp_health -= KICK_DAMAGE
		_:
			pass
	
	if new.attack_cooldown > FRAMES_TO_SIM:
		new.attack_cooldown -= FRAMES_TO_SIM
	elif new.attack_cooldown > 0:
		new.attack_cooldown = 0

	if new.opp_attack_cooldown > FRAMES_TO_SIM:
		new.opp_attack_cooldown -= FRAMES_TO_SIM
	elif new.opp_attack_cooldown > 0:
		new.opp_attack_cooldown = 0

	return new

static func _facing_opp(x: float, opp_x: float, orientation: int)-> bool:
	if x > opp_x and orientation == 1:
		return true
	elif x < opp_x and orientation == 2:
		return true

	return false

static func _resolve(x: float, opp_x: float, orientation: int) -> float:
	var new_x = x
	if abs(new_x - opp_x) < 1.52: # colliding with opp
		if orientation == 1: # moving left
			new_x = opp_x + 1.52
		elif orientation == 2: # moving right
			new_x = opp_x - 1.52

	if new_x < -7.24: # past left wall
		new_x = -7.24
	elif new_x > 7.24: # past right wall
		new_x = 7.24

	return new_x
