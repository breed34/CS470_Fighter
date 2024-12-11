class_name MCTSNode2


const C = 15

var turn: int
var n: int
var r: float
var action: String
var parent: MCTSNode2
var children: Array[MCTSNode2]
var state: FighterState2

var untried_actions = [
	"stationary",
	"moving_left",
	"moving_right",
	"punching",
	"kicking"
];

static func root_inst(state: FighterState2) -> MCTSNode2:
	var new = MCTSNode2.new()
	new.turn = 1
	new.n = 0
	new.r = 0.0
	new.action = "stationary"
	new.parent = null
	new.children = [] as Array[MCTSNode2]
	new.state = state

	return new

func select() -> MCTSNode2:
	var selection = null
	if turn == 1:
		var best = -INF
		for child in children:
			var val = child.r / child.n + C * sqrt(log(n) / child.n)
			if val > best:
				selection = child
				best = val
	else:
		var best = INF
		for child in children:
			var val = child.r / child.n - C * sqrt(log(n) / child.n)
			if val < best:
				selection = child
				best = val

	return selection

func evaluate() -> float:
	var health = 0
	var opp_health = 0
	if turn == 1:
		health = state.health
		opp_health = state.opp_health
	else:
		health = state.opp_health
		opp_health = state.health

	return health - opp_health

func expand(action: String) -> MCTSNode2:
	var new_state = ActionSimulator.simulate_action(action, state)
	var child = MCTSNode2.new()
	child.turn = 1 if turn == 2 else 2
	child.n = 1
	child.action = action
	child.parent = self
	child.children = [] as Array[MCTSNode2]
	child.state = new_state.flip()
	child.r = child.evaluate()

	return child

func best_action() -> String:
	var best_action = "stationary"
	var best_n = 0
	for child in children:
		if child.n > best_n:
			best_action = child.action
			best_n = child.n

	return best_action

func print_dist():
	print("Distribution:")
	for child in children:
		print("{a}: n = {n} r = {r}".format({
			"a": child.action,
			"n": child.n,
			"r": child.r / child.n}))
