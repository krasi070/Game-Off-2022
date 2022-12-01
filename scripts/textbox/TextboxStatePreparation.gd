extends FSMState

func on_enter() -> void:
	obj.reset()


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	if not obj.entry_queue.empty():
		fsm.state_next = fsm.states.Reading
