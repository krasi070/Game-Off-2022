extends FSMState

func on_enter() -> void:
	#get_tree().paused = true
	#obj.textbox.mouse_filter = Control.MOUSE_FILTER_STOP
	if obj.entry_queue.empty():
		fsm.state_next = fsm.states.Reading
	else:
		obj.show()
		obj.body.visible_characters = 0
		var entry: Dictionary = obj.entry_queue.pop_front()
		obj.set_name(entry.name)
		obj.set_portrait_by_name()
		obj.body.text = entry.body
		obj.tween = create_tween()
		obj.tween.connect("finished", self, "_tween_finished")
		obj.tween.tween_property(
			obj.body, 
			"visible_characters",
			len(obj.body.text),
			len(obj.body.text) * obj.CHAR_READ_RATE)


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if not obj.is_active:
		return
	if fsm.state_curr == fsm.states.Reading and \
		event.is_action_pressed("left_click") and\
		obj.tween.is_running():
			obj.tween.stop()
			obj.body.visible_characters = len(obj.body.text)
			fsm.state_next = fsm.states.Finished


func _tween_finished() -> void:
	if fsm.state_curr == fsm.states.Reading:
		fsm.state_next = fsm.states.Finished
