extends Node

var data_by_action: Dictionary = {
	Enums.ACTION_TYPE.ATTACK: 
		preload("res://assets/resources/actions/AttackAction.tres"),
	Enums.ACTION_TYPE.DEFEND: 
		preload("res://assets/resources/actions/DefendAction.tres"),
	Enums.ACTION_TYPE.NOTHING: 
		preload("res://assets/resources/actions/NothingAction.tres"),
	Enums.ACTION_TYPE.ARROGANCE:
		preload("res://assets/resources/actions/ArroganceAction.tres"),
	Enums.ACTION_TYPE.COPY:
		preload("res://assets/resources/actions/CopyAction.tres"),
	Enums.ACTION_TYPE.ATTACK_UP:
		preload("res://assets/resources/actions/AttackUpAction.tres"),
	Enums.ACTION_TYPE.CLAW:
		preload("res://assets/resources/actions/ClawAction.tres"),
	Enums.ACTION_TYPE.DOUBLE_KNIVES:
		preload("res://assets/resources/actions/DoubleKnivesAction.tres"),
	Enums.ACTION_TYPE.SMACK:
		preload("res://assets/resources/actions/SmackAction.tres"),
	Enums.ACTION_TYPE.PARRY:
		preload("res://assets/resources/actions/ParryAction.tres"),
	Enums.ACTION_TYPE.ENCHANTED:
		preload("res://assets/resources/actions/EnchantedAction.tres"),
	Enums.ACTION_TYPE.HEAL:
		preload("res://assets/resources/actions/HealAction.tres"),
	Enums.ACTION_TYPE.FLYTRAP:
		preload("res://assets/resources/actions/FlytrapAction.tres"),
	Enums.ACTION_TYPE.BREAK_CHAIN:
		preload("res://assets/resources/actions/BreakChainAction.tres"),
	Enums.ACTION_TYPE.SPIDER:
		preload("res://assets/resources/actions/SpiderAction.tres"),
	Enums.ACTION_TYPE.LIZARD_HEAD:
		preload("res://assets/resources/actions/LizardHeadAction.tres"),
	Enums.ACTION_TYPE.MAGIC_HAT:
		preload("res://assets/resources/actions/MagicHatAction.tres"),
	Enums.ACTION_TYPE.THINKING:
		preload("res://assets/resources/actions/ThinkingAction.tres"),
	Enums.ACTION_TYPE.POISON:
		preload("res://assets/resources/actions/PoisonAction.tres"),
}

var action_func: Dictionary = {
	Enums.ACTION_TYPE.ATTACK: "exec_attack",
	Enums.ACTION_TYPE.DEFEND: "exec_defend",
	Enums.ACTION_TYPE.NOTHING: "exec_nothing",
	#Enums.ACTION_TYPE.COPY: "exec_nothing",
	Enums.ACTION_TYPE.ARROGANCE: "exec_arrogance",
	Enums.ACTION_TYPE.ATTACK_UP: "exec_attack_up",
	Enums.ACTION_TYPE.CLAW: "exec_claw",
	Enums.ACTION_TYPE.DOUBLE_KNIVES: "exec_double_knives",
	Enums.ACTION_TYPE.SMACK: "exec_smack",
	Enums.ACTION_TYPE.PARRY: "exec_parry",
	Enums.ACTION_TYPE.ENCHANTED: "exec_enchanted",
	Enums.ACTION_TYPE.HEAL: "exec_heal",
	Enums.ACTION_TYPE.FLYTRAP: "exec_flytrap",
	Enums.ACTION_TYPE.BREAK_CHAIN: "exec_break_chain",
	Enums.ACTION_TYPE.SPIDER: "exec_spider",
	Enums.ACTION_TYPE.LIZARD_HEAD: "exec_lizard_head",
	#Enums.ACTION_TYPE.MAGIC_HAT: "exec_magic_hat",
	Enums.ACTION_TYPE.THINKING: "exec_thinking",
	Enums.ACTION_TYPE.POISON: "exec_poison",
}

func pre_exec_setup(from: UnitStats, _to: UnitStats, type: int) -> void:
	if type != Enums.ACTION_TYPE.POISON:
		from.turn_stats["poison_stack"] = 0


func exec_attack(from: UnitStats, to: UnitStats) -> void:
	var dealt_damage: int = _exec_attack_helper(from, to, 1)
	from.attacked(data_by_action[Enums.ACTION_TYPE.ATTACK].action_sprite_frames)
	to.hurt(dealt_damage)


func exec_lizard_head(from: UnitStats, to: UnitStats) -> void:
	var dealt_damage: int = _exec_attack_helper(from, to, 5)
	from.attacked(data_by_action[Enums.ACTION_TYPE.LIZARD_HEAD].action_sprite_frames)
	to.hurt(dealt_damage)


func exec_claw(from: UnitStats, to: UnitStats) -> void:
	var dealt_damage: int = _exec_attack_helper(from, to, 3)
	from.attacked(data_by_action[Enums.ACTION_TYPE.CLAW].action_sprite_frames)
	to.hurt(dealt_damage)


func exec_double_knives(from: UnitStats, to: UnitStats) -> void:
	var dealt_damage: int = _exec_attack_helper(from, to, 2)
	from.attacked(data_by_action[Enums.ACTION_TYPE.DOUBLE_KNIVES].action_sprite_frames)
	to.hurt(dealt_damage)


func exec_smack(from: UnitStats, to: UnitStats) -> void:
	var dealt_damage: int = _exec_attack_helper(from, to, 2)
	from.attacked(data_by_action[Enums.ACTION_TYPE.SMACK].action_sprite_frames)
	to.hurt(dealt_damage)


func exec_parry(from: UnitStats, to: UnitStats, is_second_execution: bool = false) -> void:
	if not is_second_execution:
		if not from.temp_stats.has("defense"):
			from.temp_stats["defense"] = 0
		from.temp_stats.defense += 1
	else:
		var deal_damage: int = 0
		if to.temp_stats.has("dealing_damage_disregading_enemy_stats"):
			deal_damage = to.temp_stats.dealing_damage_disregading_enemy_stats
		if from.has_passive(Enums.PASSIVE_EFFECT_TYPE.RAGE) and from.health < floor(from.max_health / 2.0):
			deal_damage *= 2
		if to.has_passive(Enums.PASSIVE_EFFECT_TYPE.PLOT_ARMOR) and deal_damage > 1:
			deal_damage = max(deal_damage - 1, 1)
		from.attacked(data_by_action[Enums.ACTION_TYPE.PARRY].action_sprite_frames)
		to.hurt(deal_damage)


func exec_spider(from: UnitStats, to: UnitStats, is_second_execution: bool = false) -> void:
	if not is_second_execution:
		from.temp_stats["spider_damage"] = 1
	else:
		var dealt_damage: int = from.temp_stats["spider_damage"]
		if dealt_damage > 0:
			if from.turn_stats.has("damage_bonus"):
				dealt_damage += from.turn_stats.damage_bonus
			if to.turn_stats.has("damage_multiplier"):
				dealt_damage *= to.turn_stats.damage_multiplier
			if to.temp_stats.has("damage_multiplier"):
				dealt_damage *= to.temp_stats.damage_multiplier
			if to.has_passive(Enums.PASSIVE_EFFECT_TYPE.PLOT_ARMOR) and dealt_damage > 1:
				dealt_damage = max(dealt_damage - 1, 1)
			# Spiders squash each other
			if to.temp_stats.has("spider_damage"):
				dealt_damage = 0
		from.attacked(data_by_action[Enums.ACTION_TYPE.SPIDER].action_sprite_frames)
		to.hurt(dealt_damage)


func exec_enchanted(from: UnitStats, _to: UnitStats) -> void:
	if not from.temp_stats.has("damage_multiplier"):
		from.temp_stats["damage_multiplier"] = 1
	from.temp_stats.damage_multiplier *= 2
	from.was_enchanted()
	print("ENCHANTED from %s" % from.character_name)


func exec_heal(from: UnitStats, _to: UnitStats) -> void:
	var heal: int = 1
	if from.health == from.max_health:
		heal = 0
	from.health += heal
	from.healed(data_by_action[Enums.ACTION_TYPE.HEAL].action_sprite_frames, heal)
	print("ENCHANTED from %s" % from.character_name)


func exec_defend(from: UnitStats, _to: UnitStats) -> void:
	var defense: int = 1
	if not from.temp_stats.has("defense"):
		from.temp_stats["defense"] = 0
	from.temp_stats.defense += defense
	from.defended()
	print("DEFEND from %s, added %d defense" % [from.character_name, defense])


func exec_flytrap(from: UnitStats, to: UnitStats) -> void:
	var heal: int = 0
	if to.temp_stats.has("flies") and to.temp_stats["flies"]:
		heal = 1
	if from.health == from.max_health:
		heal = 0
	from.health += heal
	from.healed(data_by_action[Enums.ACTION_TYPE.FLYTRAP].action_sprite_frames, heal)
	print("FLYTRAP from %s" % from.character_name)


func exec_nothing(from: UnitStats, to: UnitStats) -> void:
	var fly_wave_dmg: int = 1
	from.temp_stats["flies"] = true
	if from.has_passive(Enums.PASSIVE_EFFECT_TYPE.FLY_WAVE) and \
		to.temp_stats.has("flies") and to.temp_stats["flies"]:
		from.hurt(fly_wave_dmg)
		print("- %s took %d fly wave damage" % [from.character_name, fly_wave_dmg])
	else:
		from.did_nothing(data_by_action[Enums.ACTION_TYPE.NOTHING].action_sprite_frames)
	print("NOTHING from %s" % from.character_name)


func exec_thinking(from: UnitStats, _to: UnitStats) -> void:
	from.did_nothing(data_by_action[Enums.ACTION_TYPE.THINKING].action_sprite_frames)
	print("THINKING from %s" % from.character_name)


func exec_break_chain(from: UnitStats, _to: UnitStats) -> void:
	from.broke_chain()
	print("BREAK CHAIN from %s" % from.character_name)


func exec_arrogance(from: PlayerStats, _to: UnitStats) -> void:
	if not from.temp_stats.has("damage_multiplier"):
		from.temp_stats["damage_multiplier"] = 1
	from.temp_stats.damage_multiplier *= 2
	var add_ego: int = 1
	if from.ego == from.max_ego or (from.turn_stats.has("used_arrogance") and from.turn_stats.used_arrogance):
		add_ego = 0
	if add_ego > 0:
		from.turn_stats["used_arrogance"] = true
	from.ego += add_ego
	from.used_arrogance(add_ego)
	print("ARROGANCE from %s" % from.character_name)


func exec_copy(from_seq: Node2D) -> void:
	for i in range(from_seq.actions.size()):
		if from_seq.actions[i].final_action.action_type == Enums.ACTION_TYPE.COPY:
			if i == 0:
				from_seq.actions[i].change_to(data_by_action[Enums.ACTION_TYPE.NOTHING])
			else:
				from_seq.actions[i].change_to(data_by_action[from_seq.actions[i - 1].final_action.action_type])


func exec_magic_hat(from_seq: Node2D) -> void:
	randomize()
	var possible_actions: Array = [
		Enums.ACTION_TYPE.SPIDER, 
		Enums.ACTION_TYPE.SMACK, 
		Enums.ACTION_TYPE.DEFEND,
		Enums.ACTION_TYPE.THINKING,
	]

	for i in range(from_seq.actions.size()):
		if from_seq.actions[i].final_action.action_type == Enums.ACTION_TYPE.MAGIC_HAT:
			possible_actions.shuffle()
			from_seq.actions[i].change_to(data_by_action[possible_actions.front()])


func exec_attack_up(from: UnitStats, _to: UnitStats) -> void:
	if not from.turn_stats.has("damage_bonus"):
		from.turn_stats["damage_bonus"] = 0
	from.turn_stats["damage_bonus"] += 1
	from.used_attack_up()
	print("ATTACK UP from %s" % from.character_name)


func exec_poison(from: UnitStats, to: UnitStats) -> void:
	if not from.turn_stats.has("poison_stack"):
		from.turn_stats["poison_stack"] = 0
	var dealt_damage: int = _exec_attack_helper(from, to, from.turn_stats["poison_stack"])
	from.attacked(data_by_action[Enums.ACTION_TYPE.POISON].action_sprite_frames)
	to.hurt(dealt_damage)
	print("POISON (%d) from %s" % [from.turn_stats["poison_stack"], from.character_name])
	from.turn_stats["poison_stack"] = min(from.turn_stats["poison_stack"] + 1, 5)


func _exec_attack_helper(from: UnitStats, to: UnitStats, damage: int) -> int:
	if from.turn_stats.has("damage_bonus"):
		damage += from.turn_stats.damage_bonus
	from.temp_stats["dealing_damage_disregading_enemy_stats"] = damage
	if from.has_passive(Enums.PASSIVE_EFFECT_TYPE.RAGE) and from.health <= floor(from.max_health / 3.0):
		damage *= 2
	if to.turn_stats.has("damage_multiplier"):
		damage *= to.turn_stats.damage_multiplier
	if to.temp_stats.has("damage_multiplier"):
		damage *= to.temp_stats.damage_multiplier
	from.temp_stats["dealing_damage"] = damage
	print("ATTACK from %s for %d damage" % [from.character_name, damage])
	if to.has_passive(Enums.PASSIVE_EFFECT_TYPE.PLOT_ARMOR) and damage > 1:
		damage = max(damage - 1, 1)
	if to.temp_stats.has("defense"):
		damage = 0
	if to.temp_stats.has("spider_damage"):
		damage = 0
		to.temp_stats.spider_damage = 0
	print("- %s took %d damage" % [to.character_name, damage])
	return damage
