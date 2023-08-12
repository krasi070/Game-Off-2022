extends Node2D

signal invalid_swap
signal swapped
signal swap_was_undone

const APPEAR_Y_DIFF: float = 10.0
const APPEAR_ANIM_DEFAULT_SPEED: float = 0.3
const COMBO_THRESHOLD: int = 3

export var action_block_scene: PackedScene
export var assigned_to: String
export var action_num: int = 10
export var action_num_for_pos: int = 10
export var selectable: bool = false

var action_distance: int = 15
var texture_width: int = 72

var opponent_seq: Node2D
var actions: Array = []
var selected_actions: Array = []
var action_seq_memory: Array = []

onready var thought_bubble_sprite: AnimatedSprite = $ThoughtBubble

func _ready() -> void:
	connect("visibility_changed", self, "_visibility_changed")
	_connect_to_input_events()
	set_doubles()
	if assigned_to == "Player":
		thought_bubble_sprite.flip_h = true
		thought_bubble_sprite.position = \
			Vector2(thought_bubble_sprite.position.x * -1, thought_bubble_sprite.position.y)


func appear(pos: Vector2) -> void:
	position = pos - Vector2(0, APPEAR_Y_DIFF)
	modulate = Color.transparent
	show()
	var tween: SceneTreeTween = create_tween()
	tween.tween_property(
		self, 
		"position:y", 
		pos.y, 
		APPEAR_ANIM_DEFAULT_SPEED)
	tween.parallel().tween_property(
		self,
		"modulate:a",
		1.0,
		APPEAR_ANIM_DEFAULT_SPEED)


func disappear(pos: Vector2) -> void:
	var tween: SceneTreeTween = create_tween()
	tween.tween_property(
		self, 
		"position:y", 
		pos.y - APPEAR_Y_DIFF, 
		APPEAR_ANIM_DEFAULT_SPEED)
	tween.parallel().tween_property(
		self,
		"modulate:a",
		0.0,
		APPEAR_ANIM_DEFAULT_SPEED)
	yield(tween, "finished")
	hide()


func has_action(type: int) -> bool:
	for action in actions:
		if action.final_action.action_type == type:
			return true
	return false


func pop_front_action() -> Node2D:
	if actions.empty():
		return null
	var front: Node2D = actions[0]
	if not front.is_doubled:
		front = actions.pop_front()
		for new_index in range(actions.size()):
			actions[new_index].set_meta("id", assigned_to + str(new_index))
		front.release()
	else:
		front.release_double()
		#front.set_is_doubled(false)
	return front


func set_actions(to_set: Array = []) -> void:
	var start_x: float = _get_starting_x()
	var end_x: float = -start_x + 2
	var step: float = texture_width + action_distance
	var max_pos_diff: int = action_num_for_pos - action_num
	var action_index: int = 0
	for x in range(start_x, end_x, step):
		if action_index < max_pos_diff:
			action_index += 1
			continue
		var action_res: Resource
		if to_set.empty():
			action_res = _get_random_action()
		else:
			action_res = ActionManager.data_by_action[to_set.pop_front()]
		_init_action_at_pos(action_res, Vector2(x, 0), action_index - max_pos_diff)
		action_index += 1


func set_action(to_set: int, index: int) -> void:
	actions[index].data = ActionManager.data_by_action[to_set]
	actions[index].set_sprite_data()


func remove_actions() -> void:
	actions = []
	selected_actions = []
	action_seq_memory = []
	for child in get_children():
		if child.has_meta("id"):
			child.queue_free()


func lock_random(amount: int) -> void:
	randomize()
	var indexes: Array = range(actions.size())
	for _i in range(amount):
		indexes.shuffle()
		var rand_index: int = indexes.pop_front()
		actions[rand_index].lock()


func get_chain_count() -> int:
	var count: int = 0
	var last_chain_shape: int = -1
	for action in actions:
		if action.is_doubled and action.data.shape != last_chain_shape:
			last_chain_shape = action.data.shape
			count += 1
	return count


func unselect_actions() -> void:
	for action in actions:
		action.unselect()
	selected_actions = []


func change_from_to(from: int, to: int) -> void:
	for action in actions:
		if action.data.action_type == from:
			action.data = ActionManager.data_by_action[to]
			action.set_sprite_data()


func player_advantage() -> void:
	randomize()
	var defend_count: int = 0
	var attack_count: int = 0
	var taken_index: int = -1
	for action in actions:
		var rand_num: int = randi() % 100
		if action.data.action_type == Enums.ACTION_TYPE.NOTHING and \
			rand_num >= 75:
			action.data = ActionManager.data_by_action[Enums.ACTION_TYPE.ATTACK]
			action.set_sprite_data()
		if _is_action_attack(action.data.action_type):
			attack_count += 1
		if _is_action_defend(action.data.action_type):
			defend_count += 1
	if attack_count <= 0:
		taken_index = randi() % actions.size()
		actions[taken_index].data = ActionManager.data_by_action[Enums.ACTION_TYPE.ATTACK]
		actions[taken_index].set_sprite_data()
	if defend_count <= 0 and actions.size() > 1:
		var index_candidates: Array = range(actions.size())
		index_candidates.erase(taken_index)
		var rand_index: int = index_candidates[randi() % index_candidates.size()]
		actions[rand_index].data = ActionManager.data_by_action[Enums.ACTION_TYPE.DEFEND]
		actions[rand_index].set_sprite_data()


func did_swap() -> bool:
	return action_seq_memory.size() > 0


func _connect_to_input_events() -> void:
	Mouse.connect("clicked_action", self, "_clicked_action")
	Mouse.connect("hovered_action", self, "_hovered_action")
	Mouse.connect("exited_action", self, "_exited_action")
	Keyboard.connect("pressed_undo", self, "_pressed_undo")


func _init_action_at_pos(action_res: Resource, pos: Vector2, index: int) -> void:
	var action_block_instance = action_block_scene.instance()
	action_block_instance.data = action_res
	action_block_instance.position = pos
	action_block_instance.name = "%sActionBlock%d" % [assigned_to, index]
	action_block_instance.set_meta("id", assigned_to + str(index))
	add_child(action_block_instance)
	action_block_instance.set_sprite_data()
	actions.append(action_block_instance)


func set_doubles(check_break_chain: bool = true) -> void:
	if actions.size() < COMBO_THRESHOLD:
		return
	_set_is_doubled_to_false()
	var streak: bool = false
	for i in range(COMBO_THRESHOLD - 1, actions.size()):
		if not streak:
			if _are_shapes_eq_in_section(i - (COMBO_THRESHOLD - 1), i):
				_set_is_doubled_for_section(i - (COMBO_THRESHOLD - 1), i, true)
				streak = true
			else:
				_set_is_doubled_for_section(i - (COMBO_THRESHOLD - 1), i, false)
		elif streak and _are_shapes_eq_in_section(i - 1, i):
			actions[i].set_is_doubled(true)
		else:
			actions[i].set_is_doubled(false)
			streak = false
	if check_break_chain:
		_doubles_after_break_chain_is_applied()


func _doubles_after_break_chain_is_applied() -> void:
	var size_diff: int = actions.size() - opponent_seq.actions.size()
	for i in range(actions.size()):
		if i - size_diff < 0:
			continue
		var is_break_chain: bool = \
			opponent_seq.actions[i - size_diff].final_action.action_type == Enums.ACTION_TYPE.BREAK_CHAIN
		if is_break_chain:
			opponent_seq.actions[i - size_diff].set_effect_anim(actions[i].is_doubled)
			if actions[i].is_doubled:
				_break_chain_on_index(i)


func _break_chain_on_index(index: int) -> void:
	var prev_index: int = index - 1
	var shape_chain: int = actions[index].data.shape
	while prev_index >= 0 and actions[prev_index].data.shape == shape_chain:
		actions[prev_index].set_is_doubled(false)
		prev_index -= 1
	var next_index: int = index + 1
	while next_index < actions.size() and actions[next_index].data.shape == shape_chain:
		actions[next_index].set_is_doubled(false)
		next_index += 1
	actions[index].set_is_doubled(false)


func _swap_actions() -> void:
	if PlayerStats.ego <= 0:
		_invalid_swap()
		return
	# Prep before swap
	_add_curr_seq_to_memory()
	selectable = false
	PlayerStats.ego -= 1
	AudioController.play_player_sfx(AudioController.WHIMPER_SOUND)
	var duration: float = selected_actions[0].play_before_swap_anim()
	selected_actions[1].play_before_swap_anim()
	yield(get_tree().create_timer(duration), "timeout")
	# Swap and update
	var temp_data: Resource = selected_actions[0].data
	selected_actions[0].data = selected_actions[1].data
	selected_actions[0].update_after_swap()
	duration = selected_actions[0].play_after_swap_anim()
	selected_actions[1].data = temp_data
	selected_actions[1].update_after_swap()
	selected_actions[1].play_after_swap_anim()
	set_doubles()
	opponent_seq.set_doubles()
	yield(get_tree().create_timer(duration), "timeout")
	# Return control and forget selected actions
	emit_signal("swapped")
	selected_actions = []
	selectable = true


func _invalid_swap() -> void:
	selectable = false
	emit_signal("invalid_swap")
	selected_actions[0].click()
	selected_actions[1].click()
	yield(get_tree().create_timer(selected_actions[0].SELECT_ANIM_DURATION), "timeout")
	selected_actions = []
	selectable = true


func _add_curr_seq_to_memory() -> void:
	action_seq_memory.append([])
	var index: int = action_seq_memory.size() - 1
	for action in actions:
		action_seq_memory[index].append(action.data)


func _set_is_doubled_to_false() -> void:
	for action in actions:
		action.is_doubled = false


func _set_is_doubled_for_section(start: int, end: int, is_doubled: bool) -> void:
	for i in range(start, end + 1):
		if not actions[i].is_doubled:
			actions[i].set_is_doubled(is_doubled)


func _get_random_action() -> Resource:
	randomize()
	var rand_index: int = randi() % PlayerStats.unlocked_actions.size()
	return PlayerStats.unlocked_actions[rand_index]


func _get_starting_x() -> float:
	var sum_width: float = (texture_width + action_distance) * (action_num_for_pos - 1)
	return -sum_width / 2


func _get_index_from_id(action_id: String) -> int:
	return int(action_id.replace(assigned_to, ""))


func _are_shapes_eq_in_section(start: int, end: int) -> bool:
	var shape: int = actions[start].data.shape
	for i in range(start, end + 1):
		if actions[i].data.shape != shape:
			return false
	return true


func _set_action_layers(layer: int) -> void:
	for action in actions:
		action.set_area_layer(layer)


func _is_action_attack(action_type: int) -> bool:
	match action_type:
		Enums.ACTION_TYPE.ATTACK, \
		Enums.ACTION_TYPE.CLAW, \
		Enums.ACTION_TYPE.SMACK, \
		Enums.ACTION_TYPE.DOUBLE_KNIVES, \
		Enums.ACTION_TYPE.SPIDER, \
		Enums.ACTION_TYPE.LIZARD_HEAD, \
		Enums.ACTION_TYPE.POISON:
			return true
		_:
			return false 


func _is_action_defend(action_type: int) -> bool:
	match action_type:
		Enums.ACTION_TYPE.DEFEND, \
		Enums.ACTION_TYPE.PARRY:
			return true
		_:
			return false 


func _visibility_changed() -> void:
	if visible == true:
		_set_action_layers(0x00000010)
	else:
		_set_action_layers(0x10000000)


func _pressed_undo() -> void:
	if not selectable or action_seq_memory.size() == 0:
		return
	unselect_actions()
	var prev_seq: Array = action_seq_memory.pop_back()
	for i in range(actions.size()):
		actions[i].data = prev_seq[i]
		actions[i].set_sprite_data()
	set_doubles()
	PlayerStats.ego += 1
	emit_signal("swap_was_undone")


func _hovered_action(action: Node2D) -> void:
	if action.get_meta("id").begins_with(assigned_to):
		var index: int = _get_index_from_id(action.get_meta("id"))
		if index >= actions.size():
			return
		if selectable and action.selectable:
			CursorManager.set_cursor(Enums.CURSOR_TYPE.SELECT)
		else:
			CursorManager.set_cursor(Enums.CURSOR_TYPE.EXAMINE)
		action.play_hover_anim()


func _exited_action(action_id: String) -> void:
	if action_id.begins_with(assigned_to):
		var index: int = _get_index_from_id(action_id)
		if index >= actions.size():
			return
		actions[index].play_exit_anim()
	CursorManager.set_cursor(Enums.CURSOR_TYPE.DEFAULT)


func _clicked_action(action: Node2D) -> void:
	if selectable and action.selectable and action.get_meta("id").begins_with(assigned_to):
		action.click()
		AudioController.play_ui_sound(AudioController.CLICK_SOUND)
		if action.selected:
			selected_actions.append(action)
		else:
			selected_actions.remove(0)
		if selected_actions.size() == 2:
			_swap_actions()
