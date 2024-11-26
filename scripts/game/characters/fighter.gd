class_name Fighter
extends CharacterBody3D


@export var jump_height: float
@export var time_to_peak: float
@export var horiz_velocity: float
@export var anim_tree: AnimationTree
@export var state_machine: StateMachine
@export var collision_shape: CollisionShape3D
@export var player_type: Enums.PlayerType
@export var start_health: float
@export var punch_area: Area3D
@export var kick_area: Area3D

@onready var gravity = (-2.0 * jump_height) / (time_to_peak * time_to_peak)
@onready var jump_velocity = (2.0 * jump_height) / time_to_peak
@onready var _health: float = start_health

var player: Player
var _attacks: Array[Attack]
var _attack_dict: Dictionary
var _can_attack: bool = true

func _ready() -> void:
	match player_type:
		Enums.PlayerType.USER:
			player = UserPlayer.new()
		Enums.PlayerType.TABLE_AI:
			player = AIPlayer.with_strat(TableStrategy.new())
		Enums.PlayerType.SMP_OFF_DEF_AI:
			player = AIPlayer.with_strat(SimpleOffDefStrategy.new())
		_:
			print("Unexpected PlayerType: ", player_type)
			player = Player.new()

	add_child.call_deferred(player)
	_attack_dict = _attacks.reduce(func(dict, a):
		dict[a.attack_name] = a
		return dict, {})

func _physics_process(delta: float) -> void:
	if _health <= 0:
		player.is_dead = true
	if position.z != 0:
		position.z = 0
	
	player.act(self, delta)
	move_and_slide()
	
func can_attack() -> bool:
	return _can_attack

func set_attacks(attacks: Array[Attack]):
	_attacks = attacks

func attack(attack_name: String) -> void:
	_can_attack = false
	var attack = _attack_dict[attack_name]
	
	var bodies = attack.area \
		.get_overlapping_bodies()
	var enemies = bodies  \
		.filter(func (b): return b is Fighter and b != self) as Array[Fighter]

	for enemy in enemies:
		enemy.take_damage(attack.damage)

	get_tree().create_timer(attack.cooldown) \
		.timeout.connect(func (): _can_attack = true)

func take_damage(damage: float) -> void:
	_health = _health - damage if damage < _health else 0

func get_health() -> float:
	return _health


func get_opponent() -> Fighter:
	return (get_parent() as Game).get_fighters() \
		.filter(func (f): return self != f) \
		.front()
