class_name FighterState2

var x: float
var orientation: int # left = 1, right = 2
var attack_cooldown: int # in frames
var health: float

var opp_x: float
var opp_orientation: int # left = 1, right = 2
var opp_attack_cooldown: int # in frames
var opp_health: float

static func from_fighters(fighter: Fighter, opp: Fighter) -> FighterState2:
	var state = FighterState2.new()
	state.x = fighter.global_position.x
	state.orientation = 2 if fighter.global_rotation.y == 0 else 1
	state.attack_cooldown = fighter.get_attack_cooldown_left_frames()
	state.health = fighter.get_health()

	state.opp_x = opp.global_position.x
	state.opp_orientation = 2 if opp.global_rotation.y == 0 else 1
	state.opp_attack_cooldown = opp.get_attack_cooldown_left_frames()
	state.opp_health = opp.get_health()

	return state

func copy() -> FighterState2:
	var copy = FighterState2.new()
	copy.x = x
	copy.orientation = orientation
	copy.attack_cooldown = attack_cooldown
	copy.health = health

	copy.opp_x = opp_x
	copy.opp_orientation = opp_orientation
	copy.opp_attack_cooldown = opp_attack_cooldown
	copy.opp_health = opp_health

	return copy

func flip() -> FighterState2:
	var copy = FighterState2.new()
	copy.x = opp_x
	copy.orientation = opp_orientation
	copy.attack_cooldown = opp_attack_cooldown
	copy.health = opp_health

	copy.opp_x = x
	copy.opp_orientation = orientation
	copy.opp_attack_cooldown = attack_cooldown
	copy.opp_health = health

	return copy
