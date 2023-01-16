extends FSMState

func on_enter() -> void:
	obj.player_seq.selectable = true
	obj.player_passive_effect_container.selectable = true
	obj.player_seq.connect("swapped", self, "_player_seq_swapped")
	obj.player_seq.connect("swap_was_undone", self, "_player_seq_swap_was_undone")
	obj.squire_character.connect("pressed_execute", self, "_pressed_execute")
	obj.squire_character.appear_bubble()
	_connect_to_clickable_player_passive_signals()


func on_exit() -> void:
	obj.player_seq.selectable = false
	obj.player_passive_effect_container.selectable = false
	obj.squire_character.hide_bubble()
	obj.player_seq.disconnect("swapped", self, "_player_seq_swapped")
	obj.player_seq.disconnect("swap_was_undone", self, "_player_seq_swap_was_undone")
	obj.squire_character.disconnect("pressed_execute", self, "_pressed_execute")
	_disconnect_to_clickable_player_passive_signals()


func run(_delta: float) -> void:
	pass


func _connect_to_clickable_player_passive_signals() -> void:
	obj.player_passive_effect_container.connect(
		"clicked_new_plan", 
		self, 
		"_player_clicked_new_plan")


func _disconnect_to_clickable_player_passive_signals() -> void:
	obj.player_passive_effect_container.disconnect(
		"clicked_new_plan", 
		self, 
		"_player_clicked_new_plan")


func _player_seq_swapped() -> void:
	obj.update_passive_active_anims("Planning")


func _player_seq_swap_was_undone() -> void:
	obj.update_passive_active_anims("Planning")


func _pressed_execute() -> void:
	fsm.state_next = fsm.states.PostPlanning


func _player_clicked_new_plan() -> void:
	obj.set_player_seq_for_turn()
	obj.player_seq.set_doubles()
	
	if EnemyStats.has_passive(Enums.PASSIVE_EFFECT_TYPE.VINE):
		obj.player_seq.lock_random(1)
	
	if EnemyStats.has_passive(Enums.PASSIVE_EFFECT_TYPE.CUPID_ARROW):
		obj.player_seq.change_from_to(Enums.ACTION_TYPE.NOTHING, Enums.ACTION_TYPE.ENCHANTED)
	
	obj.update_passive_active_anims("Planning")
