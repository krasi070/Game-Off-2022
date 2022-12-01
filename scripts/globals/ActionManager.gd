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
}

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
		if to.temp_stats.has("dealing_damage"):
			deal_damage = to.temp_stats.dealing_damage
		from.attacked(data_by_action[Enums.ACTION_TYPE.PARRY].action_sprite_frames)
		to.hurt(deal_damage)


func exec_spider(from: UnitStats, to: UnitStats, is_second_execution: bool = false) -> void:
	if not is_second_execution:
		var damage: int = 1
		if from.turn_stats.has("damage_bonus"):
			damage += from.turn_stats.damage_bonus
		if to.turn_stats.has("damage_multiplier"):
			damage *= to.turn_stats.damage_multiplier
		if to.temp_stats.has("damage_multiplier"):
			damage *= to.temp_stats.damage_multiplier
		from.temp_stats["spider_damage"] = damage
	else:
		var dealt_damage: int = from.temp_stats["spider_damage"]
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


func exec_nothing(from: UnitStats, _to: UnitStats) -> void:
	from.temp_stats["flies"] = true
	from.did_nothing()
	print("NOTHING from %s" % from.character_name)


func exec_break_chain(from: UnitStats, _to: UnitStats) -> void:
	from.broke_chain()
	print("BREAK CHAIN from %s" % from.character_name)


func exec_arrogance(from: PlayerStats, _to: UnitStats) -> void:
	if not from.temp_stats.has("damage_multiplier"):
		from.temp_stats["damage_multiplier"] = 1
	from.temp_stats.damage_multiplier *= 2
	var add_ego: int = 1
	if from.ego == from.max_ego:
		add_ego = 0
	from.ego += add_ego
	from.used_arrogance(add_ego)
	print("ARROGANCE from %s" % from.character_name)


func exec_copy(from_seq: Node2D) -> void:
	for i in range(from_seq.actions.size()):
		print("here at ", i)
		if from_seq.actions[i].final_action == Enums.ACTION_TYPE.COPY:
			if i == 0:
				from_seq.actions[i].change_to(data_by_action[Enums.ACTION_TYPE.NOTHING])
			else:
				from_seq.actions[i].change_to(data_by_action[from_seq.actions[i - 1].final_action])


func exec_attack_up(from: UnitStats, _to: UnitStats) -> void:
	if not from.turn_stats.has("damage_bonus"):
		from.turn_stats["damage_bonus"] = 0
	from.turn_stats["damage_bonus"] += 1
	from.used_attack_up()
	print("ATTACK UP from %s" % from.character_name)


func _exec_attack_helper(from: UnitStats, to: UnitStats, damage: int) -> int:
	if from.turn_stats.has("damage_bonus"):
		damage += from.turn_stats.damage_bonus
	if to.turn_stats.has("damage_multiplier"):
		damage *= to.turn_stats.damage_multiplier
	if to.temp_stats.has("damage_multiplier"):
		damage *= to.temp_stats.damage_multiplier
	from.temp_stats["dealing_damage"] = damage
	print("ATTACK from %s for %d damage" % [from.character_name, damage])
	if to.temp_stats.has("defense"):
		damage = 0
	if to.temp_stats.has("spider_damage"):
		damage = 0
		to.temp_stats.spider_damage = 0
	print("- %s took %d damage" % [to.character_name, damage])
	return damage
