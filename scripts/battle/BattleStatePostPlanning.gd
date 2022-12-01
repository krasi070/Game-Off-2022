extends FSMState

func on_enter() -> void:
	var has_post_plan_action: bool = false
	if obj.player_seq.has_action(Enums.ACTION_TYPE.COPY):
		ActionManager.exec_copy(obj.player_seq)
		has_post_plan_action = true
	if obj.enemy_seq.has_action(Enums.ACTION_TYPE.COPY):
		ActionManager.exec_copy(obj.enemy_seq)
		has_post_plan_action = true
	if has_post_plan_action:
		yield(get_tree().create_timer(1.0 / SpeedManager.speed), "timeout")
	fsm.state_next = fsm.states.ActionPairExecution


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	pass
