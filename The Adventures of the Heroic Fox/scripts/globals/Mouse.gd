extends Node2D

signal hovered_bubble
signal exited_bubble
signal clicked_bubble

signal left_clicked

signal hovered_action(action)
signal exited_action(action_id)
signal clicked_action(action)

signal hovered_passive(passive_effect)
signal exited_passive(passive_effect_id)
signal clicked_passive(passive_effect)

const CENTER: Vector2 = Vector2(960, 540)
const MOVE_WITH_MOUSE_MULTIPLIER: Vector2 = Vector2(-0.005, -0.005)

var move_with_mouse: Node2D = null setget set_move_with_mouse
var obj_original_pos: Vector2 = Vector2.ZERO
var hovering_over_action: Node2D = null
var hovering_over_passive: Node2D = null
var is_hovering_over_bubble: bool = false

var is_active: bool = true

func _physics_process(_delta: float) -> void:
	if not is_active:
		return
	_check_for_passive_hover()
	_check_for_action_hover()
	_check_for_bubble_hover()
	_handle_move_with_mouse()


func _input(event: InputEvent) -> void:
	if is_active and event.is_action_released("left_click"):
		emit_signal("left_clicked")
		if is_instance_valid(hovering_over_action):
			emit_signal("clicked_action", hovering_over_action)
		elif is_instance_valid(hovering_over_passive):
			emit_signal("clicked_passive", hovering_over_passive)
		elif is_hovering_over_bubble:
			emit_signal("clicked_bubble")


func set_move_with_mouse(obj: Node2D) -> void:
	move_with_mouse = obj
	if is_instance_valid(move_with_mouse):
		obj_original_pos = move_with_mouse.position


func _check_for_bubble_hover() -> void:
	var space = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()
	var col_arr: Array = space.intersect_point(
		mouse_pos, 1, [], 0x000001000, false, true)
	if not is_hovering_over_bubble and col_arr and col_arr[0].collider.get_parent().visible:
		is_hovering_over_bubble = true
		emit_signal("hovered_bubble")
	elif is_hovering_over_bubble and (col_arr.empty() or not col_arr[0].collider.get_parent().visible):
		is_hovering_over_bubble = false
		emit_signal("exited_bubble")


func _check_for_action_hover() -> void:
	var space = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()
	var col_arr: Array = space.intersect_point(
		mouse_pos, 1, [], 0x00000010, false, true)
	if col_arr:
		_handle_action_collision(col_arr)
	elif is_instance_valid(hovering_over_action):
		_disconnect_from_action_exit()
		emit_signal("exited_action", hovering_over_action.get_meta("id"))
		hovering_over_action = null


func _handle_action_collision(col_arr: Array) -> void:
	for collision in col_arr:
		var collided_with: Node2D = collision.collider.get_parent()
		if is_instance_valid(hovering_over_action) and \
			not collided_with.is_equal(hovering_over_action):
			_disconnect_from_action_exit()
			emit_signal("exited_action", hovering_over_action.get_meta("id"))
		if not is_instance_valid(hovering_over_action) or \
			not collided_with.is_equal(hovering_over_action):
			hovering_over_action = collided_with
			_connect_to_action_exit()
			emit_signal("hovered_action", collided_with)


func _check_for_passive_hover() -> void:
	var space = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()
	var col_arr: Array = space.intersect_point(
		mouse_pos, 1, [], 0x00000100, false, true)
	if col_arr:
		_handle_passive_collision(col_arr)
	elif is_instance_valid(hovering_over_passive):
		_disconnect_from_passive_exit()
		emit_signal("exited_passive", hovering_over_passive.get_meta("p_id"))
		hovering_over_passive = null


func _handle_passive_collision(col_arr: Array) -> void:
	for collision in col_arr:
		var collided_with: Node2D = collision.collider.get_parent()
		if is_instance_valid(hovering_over_passive) and \
			not collided_with.is_equal(hovering_over_passive):
			_disconnect_from_passive_exit()
			emit_signal("exited_passive", hovering_over_passive.get_meta("p_id"))
		if not is_instance_valid(hovering_over_passive) or \
			not collided_with.is_equal(hovering_over_passive):
			hovering_over_passive = collided_with
			_connect_to_passive_exit()
			emit_signal("hovered_passive", collided_with)


func _handle_move_with_mouse() -> void:
	if is_instance_valid(move_with_mouse):
		var mouse_pos_centered = get_global_mouse_position() - CENTER
		move_with_mouse.position = \
			obj_original_pos + mouse_pos_centered * MOVE_WITH_MOUSE_MULTIPLIER


func _connect_to_action_exit() -> void:
	if not hovering_over_action.is_connected("tree_exiting", self, "_hovering_over_action_tree_exiting"):
		hovering_over_action.connect("tree_exiting", self, "_hovering_over_action_tree_exiting")


func _disconnect_from_action_exit() -> void:
	if hovering_over_action.is_connected("tree_exiting", self, "_hovering_over_action_tree_exiting"):
		hovering_over_action.disconnect("tree_exiting", self, "_hovering_over_action_tree_exiting")


func _connect_to_passive_exit() -> void:
	if not hovering_over_passive.is_connected("tree_exiting", self, "_hovering_over_passive_tree_exiting"):
		hovering_over_passive.connect("tree_exiting", self, "_hovering_over_passive_tree_exiting")


func _disconnect_from_passive_exit() -> void:
	if hovering_over_passive.is_connected("tree_exiting", self, "_hovering_over_passive_tree_exiting"):
		hovering_over_passive.disconnect("tree_exiting", self, "_hovering_over_passive_tree_exiting")


func _hovering_over_action_tree_exiting() -> void:
	emit_signal("exited_action", "")


func _hovering_over_passive_tree_exiting() -> void:
	emit_signal("exited_passive", "")
