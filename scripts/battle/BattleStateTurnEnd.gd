extends FSMState

func on_enter() -> void:
	yield(get_tree().create_timer(obj.execution_delay), "timeout")
	if EnemyStats.is_new_phase_reached():
		fsm.state_next = fsm.states.Story
		return
	fsm.state_next = fsm.states.TurnStart


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	pass
