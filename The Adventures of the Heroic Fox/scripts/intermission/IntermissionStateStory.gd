extends FSMState

func on_enter() -> void:
	obj.show_message_in_bubble("I hope I don't wake him up...")
	TextBox.connect("finished", self, "_textbox_finished")
	TextBox.queue_entries(SquireStories.intermission_beginnings[EnemyManager.curr_enemy_index])


func on_exit() -> void:
	TextBox.disconnect("finished", self, "_textbox_finished")


func run(_delta: float) -> void:
	pass


func _textbox_finished() -> void:
	fsm.state_next = fsm.states.Choice
