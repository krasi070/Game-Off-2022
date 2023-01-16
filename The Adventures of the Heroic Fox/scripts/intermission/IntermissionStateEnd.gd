extends FSMState

func on_enter() -> void:
	CursorManager.set_cursor(Enums.CURSOR_TYPE.DEFAULT)
	obj.remove_choices()
	obj.show_message_in_bubble("That should do, he's got a big day ahead of him tomorrow.")
	yield(get_tree().create_timer(1), "timeout")
	Transition.transition_to_scene("res://scenes/Battle.tscn")


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	pass
