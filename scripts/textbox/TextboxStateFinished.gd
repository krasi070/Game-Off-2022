extends FSMState

var can_proceed = false

onready var timer: Timer = $Timer

func on_enter() -> void:
	Keyboard.connect("pressed_skip", self, "_pressed_skip")
	timer.connect("timeout", self, "_timer_timeout")
	can_proceed = false
	timer.wait_time = obj.CHAR_READ_RATE
	timer.start()


func on_exit() -> void:
	Keyboard.disconnect("pressed_skip", self, "_pressed_skip")
	timer.disconnect("timeout", self, "_timer_timeout")
	obj.ticker.hide()


func run(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if not obj.is_active:
		return
	if fsm.state_curr == fsm.states.Finished and \
		event.is_action_pressed("left_click") and \
		can_proceed:
			AudioController.play_ui_sound(AudioController.TEXTBOX_CLICK_SOUND)
			if obj.entry_queue.empty():
				fsm.state_next = fsm.states.Preparation
				#obj.textbox.mouse_filter = Control.MOUSE_FILTER_PASS
				#get_tree().paused = false
				obj.set_name("")
				obj.set_portrait(null)
				# Add slight delay
				yield(get_tree().create_timer(0.05), "timeout")
				obj.emit_signal("finished")
			else:
				fsm.state_next = fsm.states.Reading


func _timer_timeout() -> void:
	obj.ticker.show()
	can_proceed = true
	timer.stop()


func _pressed_skip() -> void:
	obj.entry_queue.clear()
	fsm.state_next = fsm.states.Preparation
	obj.set_name("")
	obj.set_portrait(null)
	# Add slight delay
	yield(get_tree().create_timer(0.05), "timeout")
	obj.emit_signal("finished")
