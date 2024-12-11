class_name MCTSStrategy2
extends Strategy

var _thread: Thread
var _exit_thread: bool = false

func _ready() -> void:
	_thread = Thread.new()

func _exit_tree():
	_exit_thread = true
	_thread.wait_to_finish()

func decide(fighter: Fighter, opponent: Fighter) -> Array[String]:
	var res_root: MCTSNode2 = null
	var next_action: String = "stationary"
	if _thread.is_started():
		_exit_thread = true
		res_root = _thread.wait_to_finish()
		next_action = res_root.best_action()
		res_root.print_dist()

	_exit_thread = false
	_thread.start(
		decide_async.bind(
			MCTSNode2.root_inst(
				ActionSimulator.simulate_action(
					next_action,
					FighterState2.from_fighters(fighter, opponent)))))

	if res_root != null:
		return [next_action]
	else:
		return ["stationary"]

func decide_async(root: MCTSNode2):
	var depth = 0
	var curr_node = root
	while true:
		if curr_node.untried_actions.is_empty():
			curr_node = curr_node.select()
			continue;
		else:
			var action = curr_node.untried_actions.pop_front()
			var child = curr_node.expand(action)
			curr_node.children.push_back(child)

			var r = child.r
			curr_node = child
			var curr_depth = 0
			while curr_node != null:
				curr_node.r += r
				curr_node.n += 1
				curr_node = curr_node.parent
				curr_depth += 1

			if curr_depth > depth:
				depth = curr_depth
			curr_node = root

		if _exit_thread:
			print("Depth: {d}".format({"d": depth}))
			return root
