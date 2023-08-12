extends FSMState

func on_enter() -> void:
	TextBox.connect("finished", self, "_textbox_finished")
	obj.hero_character.anim_active = false
	obj.enemy_character.anim_active = false
	TextBox.queue_entries(EnemyManager.get_enemy().end_story)
	EnemyManager.curr_enemy_index += 1
	if EnemyManager.curr_enemy_index == 1:
		TutorialManager.show_enemy_passives_tutorial = true
	print("You won! %s is victorious!" % PlayerStats.character_name)


func on_exit() -> void:
	TextBox.disconnect("finished", self, "_textbox_finished")


func run(_delta: float) -> void:
	pass


func _textbox_finished() -> void:
	if EnemyManager.curr_enemy_index > EnemyManager.LAST_ENEMY:
		fsm.state_next = fsm.states.Ending
#		EnemyManager.curr_enemy_index = 0
#		TutorialManager.reset()
#		EnemyStats.reset_to_default()
#		PlayerStats.reset_to_default()
#		Transition.transition_to_scene("res://scenes/ui/MainMenu.tscn", false)
	else:
		PlayerStats.reset_next_turn_stats()
		Transition.transition_to_scene("res://scenes/IntermissionScreen.tscn", false)
