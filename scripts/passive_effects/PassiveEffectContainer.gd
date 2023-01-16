extends HBoxContainer

# warning-ignore:unused_signal
signal clicked_new_plan

export var assigned_to: String

var passives: Array = []
var holders: Array = []

var selectable: bool = false

func _ready() -> void:
	Mouse.connect("hovered_passive", self, "_hovered_passive")
	Mouse.connect("exited_passive", self, "_exited_passive")
	Mouse.connect("clicked_passive", self, "_clicked_passive")
	if assigned_to == "Player":
		PlayerStats.connect("started_new_turn", self, "_player_started_new_turn")


func add_passive(passive: Node2D) -> void:
	passive.set_meta("p_id", assigned_to + str(passives.size()))
	passives.append(passive)
	var holder: Control = Control.new()
	holder.rect_min_size = Vector2(82, 82)
	holder.mouse_filter = Control.MOUSE_FILTER_PASS
	holder.add_child(passive)
	holders.append(holder)
	add_child(holder)
	passive.set_visual_data()


func get_passive_by_type(type: int) -> Node2D:
	for passive in passives:
		if passive.data.passive_effect_type == type:
			return passive
	return null


func remove_passive(passive: Node2D) -> void:
	var index: int = passives.find(passive)
	if index < 0:
		return
	holders.pop_at(index).queue_free()
	passives.pop_at(index).queue_free()
	_update_ids()


func empty_container() -> void:
	for holder in holders:
		holder.queue_free()
	holders.clear()
	for passive in passives:
		passive.queue_free()
	passives.clear()


func reset_clickable_passives() -> void:
	for passive in passives:
		if passive.data.is_clickable:
			passive.restore()


func _update_ids() -> void:
	for i in range(passives.size()):
		passives[i].set_meta("p_id", assigned_to + str(i))


func _get_index_from_id(passive_id: String) -> int:
	return int(passive_id.replace(assigned_to, ""))


func _clicked_passive(passive_effect: Node2D) -> void:
	if passive_effect.get_meta("p_id").begins_with(assigned_to) and \
		selectable and \
		passive_effect.data.is_clickable and \
		not passive_effect.is_used:
		var index: int = _get_index_from_id(passive_effect.get_meta("p_id"))
		CursorManager.set_cursor(Enums.CURSOR_TYPE.EXAMINE)
		passive_effect.use_up()
		emit_signal(passive_effect.data.signal_to_emit_on_click)


func _hovered_passive(passive_effect: Node2D) -> void:
	if passive_effect.get_meta("p_id").begins_with(assigned_to):
		var index: int = _get_index_from_id(passive_effect.get_meta("p_id"))
		if passive_effect.data.is_clickable and \
			selectable and \
			not passive_effect.is_used:
			CursorManager.set_cursor(Enums.CURSOR_TYPE.SELECT)
		else:
			CursorManager.set_cursor(Enums.CURSOR_TYPE.EXAMINE)
		passive_effect.play_hover_anim()


func _exited_passive(passive_effect_id: String) -> void:
	if passive_effect_id.begins_with(assigned_to):
		var index: int = _get_index_from_id(passive_effect_id)
		passives[index].play_exit_anim()
	CursorManager.set_cursor(Enums.CURSOR_TYPE.DEFAULT)


func _player_started_new_turn() -> void:
	reset_clickable_passives()
