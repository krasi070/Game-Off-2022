extends FSMState

func on_enter() -> void:
	obj.show_choices(SquireStories.choices[EnemyManager.curr_enemy_index])
	_connect_to_mouse_events()


func on_exit() -> void:
	_disconnect_from_mouse_events()


func run(_delta: float) -> void:
	pass


func _connect_to_mouse_events() -> void:
	Mouse.connect("clicked_action", self, "_clicked_action")
	Mouse.connect("hovered_action", self, "_hovered_action")
	Mouse.connect("exited_action", self, "_exited_action")
	Mouse.connect("clicked_passive", self, "_clicked_passive")
	Mouse.connect("hovered_passive", self, "_hovered_passive")
	Mouse.connect("exited_passive", self, "_exited_passive")


func _disconnect_from_mouse_events() -> void:
	Mouse.disconnect("clicked_action", self, "_clicked_action")
	Mouse.disconnect("hovered_action", self, "_hovered_action")
	Mouse.disconnect("exited_action", self, "_exited_action")
	Mouse.disconnect("clicked_passive", self, "_clicked_passive")
	Mouse.disconnect("hovered_passive", self, "_hovered_passive")
	Mouse.disconnect("exited_passive", self, "_exited_passive")


func _clicked_action(action: Node2D) -> void:
	PlayerStats.add_action(action.data)
	fsm.state_next = fsm.states.End


func _hovered_action(action: Node2D) -> void:
	action.play_hover_anim()


func _exited_action(action_id: String) -> void:
	obj.choices[int(action_id)].play_exit_anim()


func _clicked_passive(passive_effect: Node2D) -> void:
	PlayerStats.apply_passive(passive_effect.data)
	fsm.state_next = fsm.states.End


func _hovered_passive(passive_effect: Node2D) -> void:
	passive_effect.play_hover_anim()


func _exited_passive(passive_id: String) -> void:
	obj.choices[int(passive_id)].play_exit_anim()
