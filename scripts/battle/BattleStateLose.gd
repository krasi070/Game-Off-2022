extends FSMState

func on_enter() -> void:
	OptionsLayer.connect("retried", self, "_retried")
	TextBox.connect("finished", self, "_textbox_finished")
	obj.hero_character.anim_active = false
	obj.enemy_character.anim_active = false
	print("You lost! %s beat you..." % EnemyStats.character_name)
	TextBox.queue_entry(Helper.to_entry("Squire", "Oh no, we lost..."))


func on_exit() -> void:
	OptionsLayer.disconnect("retried", self, "_retried")
	TextBox.disconnect("finished", self, "_textbox_finished")


func run(_delta: float) -> void:
	pass


func _textbox_finished() -> void:
	OptionsLayer.show_game_over()
	OptionsLayer.show()
	get_tree().paused = OptionsLayer.visible


func _retried() -> void:
	PlayerStats.reset_next_turn_stats()
	fsm.state_next = fsm.states.Preparation
