class_name FighterState


static func from_fighter(fighter: Fighter) -> FighterState:
	var s = FighterState.new()
	s.position = fighter.global_position
	s.rotation_y = fighter.rotation.y
	s.can_attack = fighter.can_attack()
	s.health = fighter.get_health()
	s.horiz_velocity = fighter.horiz_velocity
	return s

func copy() -> FighterState:
	var s = FighterState.new()
	s.position = Vector3(position)
	s.rotation_y = rotation_y
	s.can_attack = can_attack
	s.health = health
	s.horiz_velocity = horiz_velocity
	return s

var position: Vector3
var rotation_y: float
var can_attack: bool
var health: float
var horiz_velocity: float
