extends FSMState

func on_enter() -> void:
	TextBox.connect("finished", self, "_textbox_finished")
	obj.update_passive_active_anims("Story")
	_play_character_story()
	


func on_exit() -> void:
	TextBox.disconnect("finished", self, "_textbox_finished")


func run(_delta: float) -> void:
	pass


func _play_character_story() -> void:
	obj.hide_battle_ui()
	if not EnemyStats.played_start_story:
		# Beginning of battle
		EnemyStats.phase = 0
		EnemyStats.played_start_story = true
		TextBox.queue_entries(EnemyManager.get_enemy().start_story)
	else:
		# Enemy phase changed
		EnemyStats.update_phase()
		TextBox.queue_entries(EnemyStats.get_phase_story())
		if TextBox.entry_queue.size() == 0:
			# Enemy phase hasn't changed
			fsm.state_next = fsm.states.TurnStart


func _execute_curse_passive() -> void:
	PlayerStats.ego -= 1
	obj.enemy_character.play_attack_anim(EnemyStats.passives_dict[Enums.PASSIVE_EFFECT_TYPE.CURSE].sprite_frames)
	if PlayerStats.ego > 0:
		yield(get_tree().create_timer(0.5 / SpeedManager.speed), "timeout")
		AudioController.play_player_sfx(AudioController.WHIMPER_SOUND)


func _handle_post_story_passives() -> bool:
	if EnemyStats.has_passive(Enums.PASSIVE_EFFECT_TYPE.CURSE):
		_execute_curse_passive()
		return true
	return false


func _textbox_finished() -> void:
	if _handle_post_story_passives():
		yield(get_tree().create_timer(1.5 / SpeedManager.speed), "timeout")
	fsm.state_next = fsm.states.TurnStart
