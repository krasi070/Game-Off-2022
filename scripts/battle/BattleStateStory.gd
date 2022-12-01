extends FSMState

func _ready() -> void:
	TextBox.connect("finished", self, "_textbox_finished")


func on_enter() -> void:
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


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	pass


func _textbox_finished() -> void:
	if fsm.state_curr == fsm.states.Story:
		fsm.state_next = fsm.states.TurnStart
