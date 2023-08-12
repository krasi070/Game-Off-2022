extends FSMState

signal finished_prep

func on_enter() -> void:
	_connect_signals()
	_prep()
	yield(self, "finished_prep")
	TextBox.queue_entries(EnemyManager.princess.story)


func on_exit() -> void:
	_disconnect_signals()


func run(_delta: float) -> void:
	pass


func _connect_signals() -> void:
	TextBox.connect("finished", self, "_textbox_finished")


func _disconnect_signals() -> void:
	TextBox.disconnect("finished", self, "_textbox_finished")


func _prep() -> void:
	obj.hide_battle_ui()
	obj.enemy_character.play_leave_anim()
	yield(obj.enemy_character.anim_player, "animation_finished")
	obj.set_sprites(EnemyManager.princess)
	obj.enemy_character.play_appear_anim()
	yield(obj.enemy_character.anim_player, "animation_finished")
	emit_signal("finished_prep")


func _textbox_finished() -> void:
	EnemyManager.curr_enemy_index = 0
	TutorialManager.reset()
	EnemyStats.reset_to_default()
	PlayerStats.reset_to_default()
	#Transition.transition_to_scene("res://scenes/ui/MainMenu.tscn", false)
	Transition.transition_to_scene("res://scenes/CreditsScreen.tscn", false)
