extends UnitStats

signal ego_changed(curr_ego, max_ego)
signal used_arrogance(added_ego)
signal incurred_first_ego_boost()
signal incurred_first_mood_down()

var is_first_ego_boost: bool = true
var is_first_mood_down: bool = true
var is_first_turn_ever: bool = true
var is_second_turn_ever: bool = true
var is_third_turn_ever: bool = true

var max_ego: int = 5
var ego: int = max_ego setget set_ego

var unlocked_actions: Array = [
	load("res://assets/resources/actions/AttackAction.tres"),
	load("res://assets/resources/actions/DefendAction.tres"),
	load("res://assets/resources/actions/NothingAction.tres"),
]

var unlocked_passives: Array = [
]

func _ready() -> void:
	character_name = "Hero"
	max_health = 25


func set_ego(new_ego: int) -> void:
	ego = clamp(new_ego, 0, max_ego)
	emit_signal("ego_changed", ego, max_ego)


func activate_ego_boost() -> bool:
	print("%s activated ego boost" % character_name)
	apply_passive(Enums.PASSIVE_EFFECT_TYPE.EGO_BOOST, 1)
	set_ego(ego + 1)
	if not next_turn_stats.has("bonus_action_slots"):
		next_turn_stats["bonus_action_slots"] = 0
	next_turn_stats.bonus_action_slots += 1
	if is_first_ego_boost:
		is_first_ego_boost = false
		emit_signal("incurred_first_ego_boost")
		return true
	return false


func activate_mood_down() -> bool:
	print("%s got mood down" % character_name)
	apply_passive(Enums.PASSIVE_EFFECT_TYPE.MOOD_DOWN, 1)
	if not turn_stats.has("damage_multiplier"):
		turn_stats.damage_multiplier = 1
	turn_stats.damage_multiplier *= 2
	if is_first_mood_down:
		is_first_mood_down = false
		emit_signal("incurred_first_mood_down")
		return true
	return false


func add_action(to_add: Resource) -> void:
	for action in unlocked_actions:
		if action.action_type == to_add.action_type:
			return
	unlocked_actions.append(to_add)


func reset_to_default() -> void:
	.reset_to_default()
	is_first_turn_ever = true
	is_second_turn_ever = true
	is_third_turn_ever = true
	is_first_ego_boost = true
	is_first_mood_down = true
	unlocked_actions = [
		unlocked_actions[0],
		unlocked_actions[1],
		unlocked_actions[2],
	]
	unlocked_passives = []


func used_arrogance(added_ego: int) -> void:
	emit_signal("used_arrogance", added_ego)
