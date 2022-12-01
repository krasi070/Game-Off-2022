extends FSMState

func on_enter() -> void:
	PlayerStats.reset_temp_stats()
	EnemyStats.reset_temp_stats()
	if PlayerStats.health <= 0:
		fsm.state_next = fsm.states.Lose
	elif EnemyStats.health <= 0:
		fsm.state_next = fsm.states.Win
	elif obj.player_seq.actions.size() > 0 or \
		obj.enemy_seq.actions.size() > 0:
		fsm.state_next = fsm.states.ActionPairExecution
	else:
		fsm.state_next = fsm.states.TurnEnd


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	pass
