extends FSMState

var player_action_executed: int
var is_player_action_executed_again: bool
var enemy_action_executed: int
var is_enemy_action_executed_again: bool

func on_enter() -> void:
	# Delay timer
	obj.update_passive_active_anims("ActionPairExecution")
	print("Execute action in 3")
	yield(get_tree().create_timer(obj.execution_delay / 3.0), "timeout")
	print("2")
	yield(get_tree().create_timer(obj.execution_delay / 3.0), "timeout")
	print("1")
	yield(get_tree().create_timer(obj.execution_delay / 3.0), "timeout")
	# Get remaining actions amounts
	var player_remaining_actions: int = obj.player_seq.actions.size()
	var enemy_remaining_actions: int = obj.enemy_seq.actions.size()
	# If equal execute both in priority order
	AudioController.play_ui_sound(AudioController.POOF_SOUND)
	if player_remaining_actions == enemy_remaining_actions:
		# BUG IS HERE
		var player_priority: int = obj.player_seq.actions[0].final_action.priority
		var enemy_priority: int = obj.enemy_seq.actions[0].final_action.priority
		if player_priority >= enemy_priority:
			_execute_player_action()
			_execute_enemy_action()
			_execute_player_action(true)
			_execute_enemy_action(true)
		else:
			_execute_enemy_action()
			_execute_player_action()
			_execute_enemy_action(true)
			_execute_player_action(true)
	elif player_remaining_actions > enemy_remaining_actions:
		_execute_player_action()
		_execute_player_action(true)
	else:
		_execute_enemy_action()
		_execute_enemy_action(true)
	fsm.state_next = fsm.states.AfterExecution


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	pass

func _execute_player_action(is_second_execution: bool = false) -> void:
	if not is_second_execution:
		var player_action: Node2D = obj.player_seq.pop_front_action()
		player_action_executed = player_action.final_action.action_type
		is_player_action_executed_again = player_action.final_action.execute_again_after
		ActionManager.pre_exec_setup(PlayerStats, EnemyStats, player_action_executed)
		var player_action_func: String = ActionManager.action_func[player_action_executed]
		ActionManager.call(player_action_func, PlayerStats, EnemyStats)
	elif is_player_action_executed_again:
		var player_action_func: String = ActionManager.action_func[player_action_executed]
		ActionManager.call(player_action_func, PlayerStats, EnemyStats, true)


func _execute_enemy_action(is_second_execution: bool = false) -> void:
	if not is_second_execution:
		var enemy_action: Node2D = obj.enemy_seq.pop_front_action()
		enemy_action_executed = enemy_action.final_action.action_type
		is_enemy_action_executed_again = enemy_action.final_action.execute_again_after
		ActionManager.pre_exec_setup(EnemyStats, PlayerStats, enemy_action_executed)
		var enemy_action_func: String = ActionManager.action_func[enemy_action_executed]
		ActionManager.call(enemy_action_func, EnemyStats, PlayerStats)
	elif is_enemy_action_executed_again:
		var enemy_action_func: String = ActionManager.action_func[enemy_action_executed]
		ActionManager.call(enemy_action_func, EnemyStats, PlayerStats, true)
