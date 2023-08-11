extends FSMState

const DEFAULT_PASSIVE_DAMAGE: int = 5

var has_post_plan_ability: bool 

func on_enter() -> void:
	has_post_plan_ability = false
	obj.player_seq.unselect_actions()
	_prepare_tutorial_if_needed()
	_handle_post_plan_actions()
	_handle_post_plan_passives()
	if has_post_plan_ability:
		yield(get_tree().create_timer(1.0 / SpeedManager.speed), "timeout")
	if TutorialManager.is_there_a_tutorial_to_show():
		fsm.state_next = fsm.states.Tutorial
	else:
		fsm.state_next = fsm.states.ActionPairExecution


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	pass


func _prepare_tutorial_if_needed() -> void:
	if not obj.player_seq.did_swap():
		TutorialManager.show_ego_boost_tutorial = PlayerStats.activate_ego_boost()
	if PlayerStats.ego == 0:
		TutorialManager.show_mood_down_tutorial = PlayerStats.activate_mood_down()


func _handle_post_plan_actions() -> void:
	if obj.player_seq.has_action(Enums.ACTION_TYPE.MAGIC_HAT):
		ActionManager.exec_magic_hat(obj.player_seq)
		has_post_plan_ability = true
	if obj.enemy_seq.has_action(Enums.ACTION_TYPE.MAGIC_HAT):
		ActionManager.exec_magic_hat(obj.enemy_seq)
		has_post_plan_ability = true
	if obj.player_seq.has_action(Enums.ACTION_TYPE.COPY):
		ActionManager.exec_copy(obj.player_seq)
		has_post_plan_ability = true
	if obj.enemy_seq.has_action(Enums.ACTION_TYPE.COPY):
		ActionManager.exec_copy(obj.enemy_seq)
		has_post_plan_ability = true
	obj.update_passive_active_anims("PostPlanning")


func _handle_post_plan_passives() -> void:
	if PlayerStats.has_passive(Enums.PASSIVE_EFFECT_TYPE.CHAIN_HEALTH):
		_chain_heal(PlayerStats, obj.player_seq, obj.hero_character)
		has_post_plan_ability = true
	if EnemyStats.has_passive(Enums.PASSIVE_EFFECT_TYPE.CHAIN_HEALTH):
		_chain_heal(EnemyStats, obj.enemy_seq, obj.enemy_character)
		has_post_plan_ability = true
	if EnemyStats.has_passive(Enums.PASSIVE_EFFECT_TYPE.FRIENDSHIP) and \
		PlayerStats.has_passive(Enums.PASSIVE_EFFECT_TYPE.EGO_BOOST):
		_take_damage(EnemyStats, obj.enemy_character, DEFAULT_PASSIVE_DAMAGE)
		has_post_plan_ability = true


func _chain_heal(unit: UnitStats, seq: Node2D, character: Node2D) -> void:
	var chain_sum: int = seq.get_chain_count()
	var health_before: int = unit.health
	unit.health += chain_sum
	var added: int = unit.health - health_before
	character.play_healed_anim(unit.passives_dict[Enums.PASSIVE_EFFECT_TYPE.CHAIN_HEALTH].sprite_frames, added)


func _take_damage(unit: UnitStats, character: Node2D, damage: int) -> void:
	unit.health -= damage
	character.play_hurt_anim(damage)
