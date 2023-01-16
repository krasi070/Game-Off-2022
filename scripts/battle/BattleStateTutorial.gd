extends FSMState

func on_enter() -> void:
	TextBox.connect("finished", self, "_textbox_finished")
	_play_tutorial()


func on_exit() -> void:
	TextBox.disconnect("finished", self, "_textbox_finished")


func run(_delta: float) -> void:
	pass


func _play_tutorial() -> void:
	if TutorialManager.show_action_tutorial:
		TextBox.queue_entries(SquireStories.action_tutorial)
	elif TutorialManager.show_undo_and_speed_tutorial:
		TextBox.queue_entries(SquireStories.undo_and_speed_tutorial)
	elif TutorialManager.show_chain_tutorial:
		TextBox.queue_entries(SquireStories.chain_tutorial)
	elif TutorialManager.show_ego_boost_tutorial:
		TextBox.queue_entries(SquireStories.ego_boost_tutorial)
	elif TutorialManager.show_mood_down_tutorial:
		TextBox.queue_entries(SquireStories.mood_down_tutorial)
	elif TutorialManager.show_enemy_passives_tutorial:
		TextBox.queue_entries(SquireStories.enemy_passives_tutorial)


func _textbox_finished() -> void:
	var next: String = TutorialManager.prepare_for_tutorial_end()
	yield(get_tree().create_timer(0.1), "timeout")
	fsm.state_next = fsm.states[next]
