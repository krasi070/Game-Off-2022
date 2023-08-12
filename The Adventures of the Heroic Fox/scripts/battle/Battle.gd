extends Node2D

const EXECUTION_DELAY_DEFAULT: float = 1.5
const PLAYER_SEQ_POS: Vector2 = Vector2(960, 400)
const ENEMY_SEQ_POS: Vector2 = Vector2(960, 140)

var execution_delay: float

onready var player_seq: Node2D  = $PlayerSequence
onready var enemy_seq: Node2D  = $EnemySequence

onready var background: Sprite = $Background
onready var background_top: Sprite = $Background/BackgroundTop
#onready var squire_sprite: AnimatedSprite = $Background/SquireAnimatedSprite
onready var squire_character: Node2D = $Background/Squire
onready var hero_character: Node2D = $Background/Hero
onready var enemy_character: Node2D = $Background/Enemy

onready var ui_layer: Control = $UILayer
onready var player_health_bar: TextureProgress = $UILayer/PlayerUI/HealthBar
onready var player_ego_counter: Control = $UILayer/PlayerUI/EgoCounter
onready var player_passive_effect_container: HBoxContainer = $UILayer/PlayerUI/PassiveEffectContainer
onready var enemy_health_bar: TextureProgress = $UILayer/EnemyUI/HealthBar
onready var enemy_passive_effect_container: HBoxContainer = $UILayer/EnemyUI/PassiveEffectContainer
onready var battle_message: ColorRect = $BattleMessage

onready var anim_player: AnimationPlayer = $AnimationPlayer

onready var passive_scene: PackedScene = preload("res://scenes/PassiveEffect.tscn")

onready var fsm: FSM = FSM.new(self, $States, $States/Preparation, true)

func _ready() -> void:
	execution_delay = EXECUTION_DELAY_DEFAULT / SpeedManager.speed
	SpeedManager.connect("changed_speed", self, "_speed_manager_changed_speed")
	OptionsLayer.can_pause = true
	_connect_player_signals()
	_connect_enemy_signals()
	_set_opponent_seq()
	_set_characters()
	hide_battle_ui(false)
	Mouse.move_with_mouse = background
	AudioController.play_music(AudioController.BATTLE_MUSIC)


func _physics_process(delta: float) -> void:
	fsm.run_machine(delta)


func is_ui_shown() -> bool:
	return ui_layer.modulate.a > 0


func update_action_slots_amount() -> void:
	var player_action_slots: int = _get_unit_action_slots_for_turn(PlayerStats)
	var enemy_action_slots: int = _get_unit_action_slots_for_turn(EnemyStats)
	player_seq.action_num = player_action_slots
	player_seq.action_num_for_pos = max(player_action_slots, enemy_action_slots)
	enemy_seq.action_num = enemy_action_slots
	enemy_seq.action_num_for_pos = max(player_action_slots, enemy_action_slots)


func set_player_seq_for_turn() -> void:
	player_seq.remove_actions()
	if not TutorialManager.skip_tutorial and TutorialManager.tutorial_plans_index < TutorialManager.tutorial_hero_plans.size():
		player_seq.set_actions(TutorialManager.tutorial_hero_plans[TutorialManager.tutorial_plans_index].duplicate())
	else:
		player_seq.set_actions()
		player_seq.player_advantage()
	if PlayerStats.has_passive(Enums.PASSIVE_EFFECT_TYPE.PLUS_FLY):
		player_seq.set_action(Enums.ACTION_TYPE.NOTHING, 0)
	player_seq.appear(PLAYER_SEQ_POS)


func set_enemy_seq_for_turn() -> void:
	enemy_seq.remove_actions()
	var seq: Array = []
	if not TutorialManager.skip_tutorial and TutorialManager.tutorial_plans_index < TutorialManager.tutorial_enemy_plans.size():
		seq = TutorialManager.tutorial_enemy_plans[TutorialManager.tutorial_plans_index].duplicate()
	else:
		seq = _get_random_enemy_action_seq()
	if EnemyStats.has_passive(Enums.PASSIVE_EFFECT_TYPE.PLUS_FLY):
		enemy_seq.set_action(Enums.ACTION_TYPE.NOTHING, 0)
	enemy_seq.set_actions(seq)
	enemy_seq.appear(ENEMY_SEQ_POS)


func show_ui() -> void:
	anim_player.play("ui_layer_appear")


func hide_battle_ui(with_anim: bool = true) -> void:
	if with_anim:
		player_seq.disappear(PLAYER_SEQ_POS)
		enemy_seq.disappear(ENEMY_SEQ_POS)
		#anim_player.play_backwards("ui_layer_appear")
	else:
		player_seq.hide()
		enemy_seq.hide()
		#ui_layer.modulate = Color.transparent


func reset_passive_containers() -> void:
	player_passive_effect_container.empty_container()
	enemy_passive_effect_container.empty_container()


func set_unit_initial_passives(unit: UnitStats, container: HBoxContainer) -> void:
	for passive in unit.passives:
		_set_passive(passive, container)


func set_passive_effect_anim_activations(unit: UnitStats, seq: Node2D, container: HBoxContainer, state: String) -> void:
	# Chain Health
	var chain_health_passive: Node2D = \
		container.get_passive_by_type(Enums.PASSIVE_EFFECT_TYPE.CHAIN_HEALTH)
	if is_instance_valid(chain_health_passive):
		chain_health_passive.set_active(seq.get_chain_count() > 0 and \
			(state == "TurnStart" or state == "Planning"))
	
	# Potty Mouth
	var potty_mouth_passive: Node2D = \
		container.get_passive_by_type(Enums.PASSIVE_EFFECT_TYPE.CURSE)
	if is_instance_valid(potty_mouth_passive):
		potty_mouth_passive.set_active(state == "Story")
	
	# Plot Armor
	var plot_armor_passive: Node2D = \
		container.get_passive_by_type(Enums.PASSIVE_EFFECT_TYPE.PLOT_ARMOR)
	if is_instance_valid(plot_armor_passive):
		plot_armor_passive.set_active(state == "ActionPairExecution" or state == "AfterExecution")
	
	# Plus One Fly
	var plus_one_fly_passive: Node2D = \
		container.get_passive_by_type(Enums.PASSIVE_EFFECT_TYPE.PLUS_FLY)
	if is_instance_valid(plus_one_fly_passive):
		plus_one_fly_passive.set_active(true)
	
	# Rage
	var rage_passive: Node2D = \
		container.get_passive_by_type(Enums.PASSIVE_EFFECT_TYPE.RAGE)
	if is_instance_valid(rage_passive):
		rage_passive.set_active(unit.health <= unit.max_health / 3.0)
	
	# Fly Wave
	var fly_wave_passive: Node2D = \
		container.get_passive_by_type(Enums.PASSIVE_EFFECT_TYPE.FLY_WAVE)
	if is_instance_valid(fly_wave_passive):
		fly_wave_passive.set_active(state == "ActionPairExecution" or state == "AfterExecution")
	
	# Friendship Envy
	var friendship_envy_passive: Node2D = \
		container.get_passive_by_type(Enums.PASSIVE_EFFECT_TYPE.FRIENDSHIP)
	if is_instance_valid(friendship_envy_passive):
		friendship_envy_passive.set_active(state == "TurnStart" or state == "Planning" or state == "PostPlanning")


func update_passive_active_anims(state: String) -> void:
	set_passive_effect_anim_activations(PlayerStats, player_seq, player_passive_effect_container, state)
	set_passive_effect_anim_activations(EnemyStats, enemy_seq, enemy_passive_effect_container, state)


func set_sprites(enemy_char_data: Dictionary) -> void:
	enemy_character.set_sprite_frames(enemy_char_data.frames)
	enemy_character.position = enemy_char_data.battle_pos
	if enemy_char_data.has("flip_h"):
		enemy_character.anim_sprite.flip_h = enemy_char_data.flip_h
		enemy_character.effect_sprite.flip_h = enemy_char_data.flip_h
	if enemy_char_data.has("background"):
		background.texture = enemy_char_data.background
	if enemy_char_data.has("background_top"):
		background_top.texture = enemy_char_data.background_top
		background_top.show()
	else:
		background_top.hide()
	enemy_character.set_is_sprite_anim_playing(true)
	enemy_character.anim_active = true
	hero_character.set_is_sprite_anim_playing(true)
	hero_character.anim_active = true


func _set_opponent_seq() -> void:
	player_seq.opponent_seq = enemy_seq
	enemy_seq.opponent_seq = player_seq


func _get_random_enemy_action_seq() -> Array:
	if EnemyStats.action_seq_pool.empty():
		return []
	randomize()
	EnemyStats.action_seq_pool.shuffle()
	return EnemyStats.action_seq_pool[0].duplicate()


#func _get_player_based_on_enemy_seq() -> Array:
#	randomize()
#	var player_action_seq: Array = []
#	for action in enemy_seq.actions:
#		match action.data.action_type:
#			Enums.ACTION_TYPE.ATTACK, \
#			Enums.ACTION_TYPE.DOUBLE_KNIVES, \
#			Enums.ACTION_TYPE.SMACK, \
#			Enums.ACTION_TYPE.CLAW, \
#			Enums.ACTION_TYPE.LIZARD_HEAD:
#				var defensive: Array = []
#	player_action_seq.shuffle()
#	return player_action_seq


func _get_unit_action_slots_for_turn(unit: UnitStats) -> int:
	var unit_action_slots: int = unit.action_slots
	if unit.has_passive(Enums.PASSIVE_EFFECT_TYPE.PLUS_FLY):
		unit_action_slots += 1
	if unit.turn_stats.has("bonus_action_slots"):
		unit_action_slots += unit.turn_stats.bonus_action_slots
	return unit_action_slots


func _connect_player_signals() -> void:
	PlayerStats.connect("health_changed", self, "_player_health_changed")
	PlayerStats.connect("ego_changed", self, "_player_ego_changed")
	PlayerStats.connect("passive_added", self, "_player_passive_added")
	PlayerStats.connect("passive_removed", self, "_player_passive_removed")
	player_seq.connect("invalid_swap", self, "_player_seq_invalid_swap")


func _connect_enemy_signals() -> void:
	EnemyStats.connect("health_changed", self, "_enemy_health_changed")
	EnemyStats.connect("passive_added", self, "_enemy_passive_added")
	EnemyStats.connect("passive_removed", self, "_enemy_passive_removed")


func _set_characters() -> void:
	hero_character.unit = PlayerStats
	enemy_character.unit = EnemyStats


func _set_passive(passive: Resource, container: HBoxContainer) -> void:
	var p_instance: Node2D = passive_scene.instance()
	p_instance.data = passive
	container.add_passive(p_instance)
	p_instance.set_active(p_instance.data.is_active_by_default)


func _player_health_changed(curr_health: int, max_health: int) -> void:
	player_health_bar.max_value = max_health
	player_health_bar.value = curr_health


func _player_ego_changed(curr_ego: int, max_ego: int) -> void:
	player_ego_counter.max_value = max_ego
	player_ego_counter.value = curr_ego


func _player_seq_invalid_swap() -> void:
	battle_message.play_empty_ego_message_anim()


func _player_passive_added(added_passive: Resource) -> void:
	_set_passive(added_passive, player_passive_effect_container)


func _enemy_passive_added(added_passive: Resource) -> void:
	_set_passive(added_passive, enemy_passive_effect_container)


func _player_passive_removed(removed_passive: Resource) -> void:
	var instance_to_remove: Node2D = null
	for passive in player_passive_effect_container.passives:
		if passive.data.passive_effect_type == removed_passive.passive_effect_type:
			instance_to_remove = passive
			break
	if is_instance_valid(instance_to_remove):
		player_passive_effect_container.remove_passive(instance_to_remove)


func _enemy_passive_removed(removed_passive: Resource) -> void:
	var instance_to_remove: Node2D = null
	for passive in enemy_passive_effect_container.passives:
		if passive.data.passive_effect_type == removed_passive.passive_effect_type:
			instance_to_remove = passive
			break
	if is_instance_valid(instance_to_remove):
		enemy_passive_effect_container.remove_passive(instance_to_remove)


func _enemy_health_changed(curr_health: int, max_health: int) -> void:
	enemy_health_bar.max_value = max_health
	enemy_health_bar.value = curr_health


func _speed_manager_changed_speed() -> void:
	execution_delay = EXECUTION_DELAY_DEFAULT / SpeedManager.speed
