extends FSMState

func on_enter() -> void:
	obj.hide_battle_ui()
	obj.player_seq.selectable = false
	_set_sprites()
	_set_stats()
	#obj.set_unit_initial_passives(PlayerStats, obj.player_passive_effect_container)
	#obj.set_unit_initial_passives(EnemyStats, obj.enemy_passive_effect_container)
	fsm.state_next = fsm.states.Story


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	pass


func _set_stats() -> void:
	PlayerStats.health = PlayerStats.max_health
	PlayerStats.ego = PlayerStats.max_ego
	for passive in PlayerStats.unlocked_passives:
		PlayerStats.apply_passive(passive)
	EnemyStats.character_name = EnemyManager.get_enemy().name
	EnemyStats.phase_stories = EnemyManager.get_enemy().phase_stories
	EnemyStats.max_health = EnemyManager.get_enemy().health
	EnemyStats.health = EnemyStats.max_health
	EnemyStats.played_start_story = false
	for passive in EnemyManager.get_enemy().passives:
		EnemyStats.apply_passive(passive)


func _set_sprites() -> void:
	obj.enemy_character.set_sprite_frames(EnemyManager.get_enemy().frames)
	obj.enemy_character.position = EnemyManager.get_enemy().battle_pos
	if EnemyManager.get_enemy().has("flip_h"):
		obj.enemy_character.anim_sprite.flip_h = EnemyManager.get_enemy().flip_h
		obj.enemy_character.effect_sprite.flip_h = EnemyManager.get_enemy().flip_h
	obj.background.texture = EnemyManager.get_enemy().background
	obj.enemy_character.set_is_sprite_anim_playing(true)
	obj.enemy_character.anim_active = true
	obj.hero_character.set_is_sprite_anim_playing(true)
	obj.hero_character.anim_active = true
