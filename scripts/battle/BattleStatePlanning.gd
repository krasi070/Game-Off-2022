extends FSMState

func on_enter() -> void:
	obj.player_seq.selectable = true
	obj.squire_character.connect("pressed_execute", self, "_pressed_execute")
	obj.squire_character.appear_bubble()
	#Keyboard.connect("pressed_execute", self, "_pressed_execute")


func on_exit() -> void:
	obj.player_seq.selectable = false
	if not obj.player_seq.did_swap():
		PlayerStats.activate_ego_boost()
	if PlayerStats.ego == 0:
		PlayerStats.activate_mood_down()
	obj.squire_character.hide_bubble()
	obj.squire_character.disconnect("pressed_execute", self, "_pressed_execute")


func run(_delta: float) -> void:
	pass


func _pressed_execute() -> void:
	fsm.state_next = fsm.states.PostPlanning
