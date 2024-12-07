class_name MCTSNode


static func inst(
	curr_turn: String,
	action: String,
	fighter_state: FighterState,
	opponent_state: FighterState,
	parent: MCTSNode) -> MCTSNode:

	var n = MCTSNode.new()
	n.curr_turn = curr_turn
	n.action = action
	n.fighter_state = fighter_state
	n.opponent_state = opponent_state
	n.parent = parent

	return n

func copy() -> MCTSNode:
	var n = MCTSNode.new()
	n.action = action
	n.fighter_state = fighter_state.copy()
	n.opponent_state = opponent_state.copy()
	n.curr_turn = curr_turn
	n.parent = parent
	n.children = children
	n.num_visits = num_visits
	n.tot_reward = tot_reward
	return n

const SIMULATION_FRAMES = 20.0
const PUNCH_DAMAGE = 10.0
const KICK_DAMAGE = 20.0

var action: String
var fighter_state: FighterState
var opponent_state: FighterState
var curr_turn: String
var parent: MCTSNode
var children: Array[MCTSNode]
var num_visits: int = 0
var tot_reward: float = 0

var _untried_actions: Dictionary = {
	"run_left": _run_left,
	"run_right": _run_right,
	"kick": _kick,
	"punch": _punch,
	"nothing": _nothing
}

func has_untried_actions() -> bool:
	return not _untried_actions.is_empty()

func pick_untried_child() -> MCTSNode:
	var k = _untried_actions.keys().pick_random()
	var a = _untried_actions[k]
	_untried_actions.erase(k)
	return a.call()

func select_child() -> MCTSNode:
	return _select_child_fighter() \
		if curr_turn == "fighter" \
		else _select_child_opponent()

func eval():
	var f_h = fighter_state.health
	var o_h = opponent_state.health
	var k = 1.0
	var diff = 15.0
	#return  f_h - o_h - k * (absf(f_h - o_h) / diff)
	return -o_h

func max_visited_child() -> MCTSNode:
	var curr_max = 0
	var max_child = null
	for child in children:
		if child.num_visits > curr_max:
			curr_max = child.num_visits
			max_child = child
	
	return max_child

func _select_child_fighter() -> MCTSNode:
	var curr_max = -INF
	var max_child = null
	for child in children:
		const c = 0.25
		var R = child.tot_reward
		var n = child.num_visits
		var N = num_visits

		var res = R / n + c * sqrt(log(N) / n)
		if res > curr_max:
			curr_max = res
			max_child = child
	
	return max_child

func _select_child_opponent() -> MCTSNode:
	var curr_min = INF
	var min_child = null
	for child in children:
		const c = 0.25
		var R = child.tot_reward
		var n = child.num_visits
		var N = num_visits

		var res = R / n - c * sqrt(log(N) / n)
		if res < curr_min:
			curr_min = res
			min_child = child
	
	return min_child

func _run_left() -> MCTSNode:
	var n = MCTSNode.inst(
		"opponent" if curr_turn == "fighter" else "fighter",
		"moving_left",
		fighter_state,
		opponent_state,
		self)

	var state_to_update = n.fighter_state \
		if curr_turn == "fighter" \
		else n.opponent_state

	var other = n.opponent_state \
		if curr_turn == "fighter" \
		else n.fighter_state

	var proposed_x = state_to_update.position.x \
		- SIMULATION_FRAMES \
		* state_to_update.horiz_velocity

	state_to_update.rotation_y = PI
	state_to_update.position.x = _resolve_x(
		proposed_x,
		other.position.x,
		state_to_update.rotation_y)

	return n

func _run_right() -> MCTSNode:
	var n = MCTSNode.inst(
		"opponent" if curr_turn == "fighter" else "fighter",
		"moving_right",
		fighter_state,
		opponent_state,
		self)

	var state_to_update = n.fighter_state \
		if curr_turn == "fighter" \
		else n.opponent_state

	var other = n.opponent_state \
		if curr_turn == "fighter" \
		else n.fighter_state

	var proposed_x = state_to_update.position.x \
		+ SIMULATION_FRAMES \
		* state_to_update.horiz_velocity

	state_to_update.rotation_y = 0
	state_to_update.position.x = _resolve_x(
		proposed_x,
		other.position.x,
		state_to_update.rotation_y)

	return n

func _punch() -> MCTSNode:
	var n = MCTSNode.inst(
		"opponent" if curr_turn == "fighter" else "fighter",
		"punching",
		fighter_state,
		opponent_state,
		self)

	var state_to_update = n.opponent_state \
		if curr_turn == "fighter" \
		else n.fighter_state

	var other = n.fighter_state \
		if curr_turn == "fighter" \
		else n.opponent_state

	if _in_punch_range(other, state_to_update):
		state_to_update.health -= PUNCH_DAMAGE

	return n

func _kick() -> MCTSNode:
	var n = MCTSNode.inst(
		"opponent" if curr_turn == "fighter" else "fighter",
		"kicking",
		fighter_state,
		opponent_state,
		self)

	var state_to_update = n.opponent_state \
		if curr_turn == "fighter" \
		else n.fighter_state

	var other = n.fighter_state \
		if curr_turn == "fighter" \
		else n.opponent_state

	if _in_kick_range(other, state_to_update):
		state_to_update.health -= KICK_DAMAGE

	return n


func _nothing() -> MCTSNode:
	return MCTSNode.inst(
		"opponent" if curr_turn == "fighter" else "fighter",
		"stationary",
		fighter_state,
		opponent_state,
		self)

func _in_punch_range(f_state: FighterState, o_state: FighterState) -> bool:
	if not _facing_opp(f_state, o_state):
		return false

	return abs(o_state.position.x - f_state.position.x) < 1.0

func _in_kick_range(f_state: FighterState, o_state: FighterState) -> bool:
	if not _facing_opp(f_state, o_state):
		return false

	return abs(o_state.position.x - f_state.position.x) < 1.5

func _facing_opp(f_state: FighterState, o_state: FighterState) -> bool:
	var dir_to_opp = "left" \
		if o_state.position.x < f_state.position.x \
		else "right"

	var facing = "left" if f_state.rotation_y == PI else "right"
	return facing == dir_to_opp

func _resolve_x(prop_x: float, opponent_x: float, rotation_y: float):
	var x = prop_x
	const P_W = 16.0  # platform width
	const F_R = 0.379  # fighter radius
	const MAX_L = -P_W / 2.0 + F_R
	const MAX_R = P_W / 2.0 - F_R
	var move_dir = "left" if rotation_y == PI else "right"
	var opp_l = opponent_x - F_R
	var opp_r = opponent_x + F_R

	if x < MAX_L:
		x = MAX_L
	elif x > MAX_R:
		x = MAX_R
	elif opp_l < x < opp_r and move_dir == "left":
		x = opp_r + F_R
	elif opp_l < x < opp_r and move_dir == "right":
		x = opp_l - F_R

	return x
