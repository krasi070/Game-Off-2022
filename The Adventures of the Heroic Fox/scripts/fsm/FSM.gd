# This class is largely taken from Jon Topielski's code for
# Into the Deep Web: https://github.com/jontopielski/into-the-deep-web-jam

class_name FSM
extends Node

var debug = false
var states = {}
var state_curr = null
var state_next = null
var state_prev = null
var obj = null

func _init(_obj, states_parent_node, initial_state, _debug = false) -> void:
	self.obj = _obj
	self.debug = _debug
	_set_states_parent_node(states_parent_node)
	state_next = initial_state


func _set_states_parent_node(parent_node: Node) -> void:
	_debug_log("found %d states" % parent_node.get_child_count())
	if parent_node.get_child_count() == 0:
		return
	var state_nodes = parent_node.get_children()
	for state_node in state_nodes:
		_debug_log("adding state %s" % state_node.name)
		states[state_node.name] = state_node
		state_node.fsm = self
		state_node.obj = self.obj


func run_machine(delta: float) -> void:
	if state_next != state_curr:
		if state_curr != null:
			_debug_log("changing from %s to %s" % [state_curr.name, state_next.name])
			state_curr.on_exit()
		else:
			_debug_log("starting with state %s" % state_next.name)
		state_prev = state_curr
		state_curr = state_next
		state_curr.on_enter()
	state_curr.run(delta)


func _debug_log(msg: String) -> void:
	if debug:
		print("%s: %s" % [obj.name, msg])
