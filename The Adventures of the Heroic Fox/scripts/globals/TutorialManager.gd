extends Node

var skip_tutorial: bool = false
var show_action_tutorial: bool = false
var show_undo_and_speed_tutorial: bool = false
var show_chain_tutorial: bool = false
var show_ego_boost_tutorial: bool = false
var show_mood_down_tutorial: bool = false
var show_enemy_passives_tutorial: bool = false

var tutorial_plans_index: int = 0

var tutorial_hero_plans: Array = [
	[0, 2, 1, 2, 1],
	[1, 0, 0, 2, 2],
	[0, 0, 0, 2, 1],
	[1, 1, 2, 1, 1],
]

var tutorial_enemy_plans: Array = [
	[1, 2, 2, 0, 2],
	[0, 2, 2, 1, 1],
	[2, 1, 1, 1, 0],
	[0, 0, 0, 2, 1],
]

func is_there_a_tutorial_to_show() -> bool:
	return not skip_tutorial and \
		(show_action_tutorial or \
		show_undo_and_speed_tutorial or \
		show_chain_tutorial or \
		show_ego_boost_tutorial or \
		show_mood_down_tutorial or \
		show_enemy_passives_tutorial)


# Returns battle state after tutorial
func prepare_for_tutorial_end() -> String:
	if show_action_tutorial:
		show_action_tutorial = false
		return "Planning"
	if show_undo_and_speed_tutorial:
		show_undo_and_speed_tutorial = false
		return "Planning"
	if show_chain_tutorial:
		show_chain_tutorial = false
		return "Planning"
	if show_ego_boost_tutorial:
		show_ego_boost_tutorial = false
		return "ActionPairExecution"
	if show_mood_down_tutorial:
		show_mood_down_tutorial = false
		return "ActionPairExecution"
	if show_enemy_passives_tutorial:
		show_enemy_passives_tutorial = false
		return "Planning"
	return ""


func reset() -> void:
	show_action_tutorial = false
	show_undo_and_speed_tutorial = false
	show_chain_tutorial = false
	show_ego_boost_tutorial = false
	show_mood_down_tutorial = false
	show_enemy_passives_tutorial = false
	tutorial_plans_index = 0
