class_name UnitStats
extends Node

signal health_changed(curr_health, max_health)
signal health_hit_zero()
signal attacked(attack_frames)
signal did_nothing()
signal broke_chain()
signal hurt(damage)
signal defended()
signal healed(heal_frames, healed_for)
signal was_enchanted()
signal used_attack_up()
signal temp_stats_changed(temp_stats)
signal next_turn_stats_changed(turn_stats)
signal passive_added(added_passive)
signal passive_removed(removed_passive)

var character_name: String

# Numeric stats
var max_health: int = 25
var health: int = 15 setget set_health

var temp_stats: Dictionary = {} setget set_temp_stats
var turn_stats: Dictionary = {}
var next_turn_stats: Dictionary = {} setget set_next_turn_stats

var action_slots: int = 5
var passives: Array = []
var passive_timers: Dictionary = {}

var passives_dict: Dictionary = {
	Enums.PASSIVE_EFFECT_TYPE.EGO_BOOST: load("res://assets/resources/passive_effects/EgoBoostPassiveEffect.tres"),
	Enums.PASSIVE_EFFECT_TYPE.MOOD_DOWN: load("res://assets/resources/passive_effects/MoodDownPassiveEffect.tres"),
	Enums.PASSIVE_EFFECT_TYPE.VINE: load("res://assets/resources/passive_effects/VineLockPassiveEffect.tres"),
	Enums.PASSIVE_EFFECT_TYPE.CUPID_ARROW: load("res://assets/resources/passive_effects/CupidArrow.tres"),
}

func set_health(new_health: int) -> void:
	health = clamp(new_health, 0, max_health)
	emit_signal("health_changed", health, max_health)
	if health <= 0:
		emit_signal("health_hit_zero")


func has_passive(type: int) -> bool:
	for passive in passives:
		if passive.passive_effect_type == type:
			return true
	return false


func attacked(attack_frames: SpriteFrames) -> void:
	emit_signal("attacked", attack_frames)


func used_attack_up() -> void:
	emit_signal("used_attack_up")


func did_nothing() -> void:
	emit_signal("did_nothing")


func broke_chain() -> void:
	emit_signal("broke_chain")


func hurt(damage: int) -> void:
	set_health(health - damage)
	if damage > 0:
		emit_signal("hurt", damage)


func defended() -> void:
	emit_signal("defended")


func healed(heal_frames: SpriteFrames, healed_for: int) -> void:
	emit_signal("healed", heal_frames, healed_for)


func was_enchanted() -> void:
	emit_signal("was_enchanted")


func set_temp_stats(_temp_stats: Dictionary) -> void:
	temp_stats = _temp_stats
	emit_signal("temp_stats_changed", temp_stats)


func set_next_turn_stats(_next_turn_stats: Dictionary) -> void:
	next_turn_stats = _next_turn_stats
	emit_signal("next_turn_stats_changed", turn_stats)


func reset_temp_stats() -> void:
	temp_stats = {}


func reset_next_turn_stats() -> void:
	next_turn_stats = {}


func set_turn_stats() -> void:
	turn_stats = next_turn_stats


func apply_passive(passive_type: int, timer: int = -1) -> void:
	if timer > 0:
		passive_timers[passive_type] = timer
	if passives.has(passives_dict[passive_type]):
		return
	passives.append(passives_dict[passive_type])
	emit_signal("passive_added", passives[passives.size() - 1])


func update_passive_timers() -> void:
	var keys: Array = passive_timers.keys()
	for passive in keys:
		passive_timers[passive] -= 1
		if passive_timers[passive] <= 0:
			passives.erase(passives_dict[passive])
			passive_timers.erase(passive)
			emit_signal("passive_removed", passives_dict[passive])
