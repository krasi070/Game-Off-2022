extends HBoxContainer

export var assigned_to: String

var passives: Array = []
var holders: Array = []

func _ready() -> void:
	Mouse.connect("hovered_passive", self, "_hovered_passive")
	Mouse.connect("exited_passive", self, "_exited_passive")


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


func remove_passive(passive: Node2D) -> void:
	var index: int = passives.find(passive)
	if index < 0:
		return
	holders.pop_at(index).queue_free()
	passives.pop_at(index).queue_free()
	_update_ids()


func _update_ids() -> void:
	for i in range(passives.size()):
		passives[i].set_meta("p_id", assigned_to + str(i))


func _get_index_from_id(passive_id: String) -> int:
	return int(passive_id.replace(assigned_to, ""))


func _hovered_passive(passive_effect: Node2D) -> void:
	if passive_effect.get_meta("p_id").begins_with(assigned_to):
		var index: int = _get_index_from_id(passive_effect.get_meta("p_id"))
		CursorManager.set_cursor(Enums.CURSOR_TYPE.EXAMINE)
		passive_effect.play_hover_anim()


func _exited_passive(passive_effect_id: String) -> void:
	if passive_effect_id.begins_with(assigned_to):
		var index: int = _get_index_from_id(passive_effect_id)
		CursorManager.set_cursor(Enums.CURSOR_TYPE.DEFAULT)
		passives[index].play_exit_anim()
