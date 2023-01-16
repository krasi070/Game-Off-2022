extends FSMState

func on_enter() -> void:
	PlayerStats.update_passive_timers()
	PlayerStats.set_turn_stats()
	PlayerStats.reset_next_turn_stats()
	
	EnemyStats.update_passive_timers()
	EnemyStats.set_turn_stats()
	EnemyStats.reset_next_turn_stats()
	EnemyStats.action_seq_pool = EnemyManager.get_enemy().phases[EnemyStats.phase].duplicate()
	
	obj.update_action_slots_amount()
	obj.set_player_seq_for_turn()
	obj.set_enemy_seq_for_turn()
	obj.player_seq.set_doubles()
	obj.enemy_seq.set_doubles()
	TutorialManager.tutorial_plans_index += 1
	
	if EnemyStats.has_passive(Enums.PASSIVE_EFFECT_TYPE.VINE):
		obj.player_seq.lock_random(1)
	
	if EnemyStats.has_passive(Enums.PASSIVE_EFFECT_TYPE.CUPID_ARROW):
		obj.player_seq.change_from_to(Enums.ACTION_TYPE.NOTHING, Enums.ACTION_TYPE.ENCHANTED)
	
	#if not obj.is_ui_shown():
	#	obj.show_ui()
	
	PlayerStats.prepare_to_start_turn()
	
	obj.update_passive_active_anims("TurnStart")
	
	_prepare_tutorial()
	if TutorialManager.is_there_a_tutorial_to_show():
		fsm.state_next = fsm.states.Tutorial
		return
	
	fsm.state_next = fsm.states.Planning


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	pass


func _prepare_tutorial() -> void:
	if PlayerStats.is_first_turn_ever:
		PlayerStats.is_first_turn_ever = false
		TutorialManager.show_action_tutorial = true
	elif PlayerStats.is_second_turn_ever:
		PlayerStats.is_second_turn_ever = false
		TutorialManager.show_undo_and_speed_tutorial = true
	elif PlayerStats.is_third_turn_ever:
		PlayerStats.is_third_turn_ever = false
		TutorialManager.show_chain_tutorial = true
