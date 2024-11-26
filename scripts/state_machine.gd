class_name StateMachine
extends Node

@export var start_state_name: String
@export var states: Array[State]

@onready var _states_dict: Dictionary = states.reduce(
	func (dict, s):
		dict[s.state_name] = s
		return dict,
	{})

var _current_states: Array[State]

func _ready() -> void:
	set_current_states([start_state_name])

func _physics_process(delta: float) -> void:
	for state in _current_states:
		state.physics_update(delta)

func set_current_states(state_names: Array[String]) -> void:
	var new_states: Array[State]
	new_states.assign(state_names.map(func (n): return _states_dict[n]))
	_current_states = new_states
	for state in _current_states:
		state.enter_state()
