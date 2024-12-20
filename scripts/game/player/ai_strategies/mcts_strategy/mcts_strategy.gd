class_name MCTSStrategy
extends Strategy

var _thread: Thread
var _exit_thread: bool = false

func _ready() -> void:
	_thread = Thread.new()

func _exit_tree():
	_exit_thread = true
	_thread.wait_to_finish()

func decide(fighter: Fighter, opponent: Fighter) -> Array[String]:
	var res_root: MCTSNode = null
	var next_action: String = "stationary"
	if _thread.is_started():
		_exit_thread = true
		res_root = _thread.wait_to_finish()
		res_root.print_dist()
		next_action = res_root.max_visited_child().action

	_exit_thread = false
	_thread.start(decide_async.bind(
		MCTSNode.inst(
			"fighter",
			"",
			FighterState.from_fighter(fighter),
			FighterState.from_fighter(opponent),
			null)
			.with_applied(next_action)
			.with_applied("stationary")))

	if res_root != null:
		return [next_action]
	else:
		return ["stationary"]

func decide_async(root: MCTSNode):
	var depth = 0
	var curr_node = root
	while true:
		if not curr_node.has_untried_actions():
			curr_node = curr_node.select_child()
			continue;
		else:
			var child = curr_node.pick_untried_child()
			var val = child.eval()
			curr_node.children.push_back(child)
			curr_node = child
			var curr_depth = 0
			while curr_node != null:
				curr_node.tot_reward += val
				curr_node.num_visits += 1
				curr_node = curr_node.parent
				curr_depth += 1

			if curr_depth > depth:
				depth = curr_depth
			curr_node = root

		if _exit_thread:
			print("Depth: {d}".format({"d": depth}))
			return root.copy()
