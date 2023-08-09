extends Node

const LAST_ENEMY: int = 5

var curr_enemy_index: int = 0

var enemies: Array = [
	{
		"name": "Golem",
		"health": 20,
		"frames": load("res://assets/resources/sprite_frames/characters/GolemSpriteFrames.tres"),
		"background": load("res://assets/sprites/backgrounds/golem_background.png"),
		"battle_pos": Vector2(1100, 140),
		"start_story": GolemStories.start_story,
		"end_story": GolemStories.end_story,
		"phase_stories": [
			{ "threshold": 15, "story_entries": GolemStories.phase2_story },
			{ "threshold": 10, "story_entries": GolemStories.phase3_story },
		],
		"phases": [
			# Phase 1 sequences
			[
				[2, 2, 0, 2, 2],
				[2, 0, 2, 2, 2],
				[2, 0, 2, 1, 2],
				[1, 2, 2, 1, 2],
			],
			# Phase 2 sequences
			[
				[1, 2, 0, 0, 2],
				[0, 2, 1, 2, 2],
				[2, 1, 2, 0, 2],
				[2, 1, 1, 2, 1],
				[2, 0, 2, 2, 0],
			],
			# Phase 3 sequences
			[
				[1, 0, 1, 0, 2],
				[0, 2, 1, 2, 2],
				[2, 1, 2, 0, 2],
				[2, 1, 1, 0, 1],
				[2, 0, 2, 1, 0],
			]
		],
		"passives": []
	},
	{
		"name": "Abandoned Houseplant",
		"health": 20,
		"frames": load("res://assets/resources/sprite_frames/characters/FlowerSpriteFrames.tres"),
		"background": load("res://assets/sprites/backgrounds/flower_background.png"),
		"battle_pos": Vector2(1110, 230),
		"start_story": FlowerStories.start_story,
		"end_story": FlowerStories.end_story,
		"phase_stories": [
			{ "threshold": 15, "story_entries": FlowerStories.phase2_story },
		],
		"phases": [
			# Phase 1 sequences
			[
				[0, 10, 1, 0, 10, 1],
				[0, 1, 1, 3, 10, 1],
				[10, 1, 10, 0, 0, 3],
				[0, 1, 10, 0, 0, 3],
				[10, 0, 10, 1, 10, 1],
				[1, 1, 10, 10, 1, 1],
			],
			# Phase 2 sequences
			[
				[0, 0, 1, 0, 10, 1],
				[0, 1, 1, 3, 10, 1],
				[0, 1, 10, 0, 0, 3],
				[0, 1, 10, 0, 0, 3],
				[10, 0, 10, 1, 10, 1],
				[0, 0, 10, 10, 1, 10],
				[10, 10, 10, 1, 0, 1],
			]
		],
		"passives": [
			Enums.PASSIVE_EFFECT_TYPE.VINE,
		]
	},
	{
		"name": "Scratchy the Pirate",
		"health": 24,
		"frames": load("res://assets/resources/sprite_frames/characters/PirateSpriteFrames.tres"),
		"background": load("res://assets/sprites/backgrounds/pirate_background.png"),
		"battle_pos": Vector2(1150, 150),
		"start_story": PirateStories.start_story,
		"end_story": PirateStories.end_story,
		"phase_stories": [
			{ "threshold": 16, "story_entries": PirateStories.phase2_story },
			{ "threshold": 8, "story_entries": PirateStories.phase3_story },
			{ "threshold": 3, "story_entries": PirateStories.phase4_story },
		],
		"phases": [
			# Phase 1 sequences
			[
				[0, 0, 12, 1, 13, 13],
				[13, 12, 0, 12, 13, 0],
				[0, 12, 0, 0, 0, 12],
				[13, 12, 0, 1, 1, 13],
				[12, 13, 12, 12, 1, 0],
			],
			# Phase 2 sequences
			[
				[12, 8, 12, 12, 1, 1],
				[12, 1, 8, 1, 12, 12],
				[12, 12, 8, 13, 13, 1],
				[0, 12, 0, 8, 0, 12],
				[13, 12, 8, 1, 12, 12],
			],
			# Phase 3 sequences
			[
				[1, 8, 1, 0, 12, 12],
				[12, 13, 13, 0, 0, 1],
				[12, 12, 8, 12, 12, 13],
				[8, 12, 12, 13, 1, 13],
				[0, 0, 13, 1, 8, 12],
			],
			# Phase 4 sequences
			[
				[0, 12, 0, 1, 13, 1],
				[12, 13, 12, 13, 13, 12],
				[8, 1, 12, 12, 1, 1],
				[8, 12, 13, 12, 1, 1],
				[12, 12, 13, 1, 1, 8],
				[12, 12, 1, 1, 1, 8],
				[8, 13, 1, 12, 12, 0],
			],
		],
		"passives": [
			Enums.PASSIVE_EFFECT_TYPE.CURSE,
			Enums.PASSIVE_EFFECT_TYPE.RAGE,
		]
	},
	{
		"name": "Centiworm",
		"health": 30,
		"frames": load("res://assets/resources/sprite_frames/characters/CentipedeSpriteFrames.tres"),
		"background": load("res://assets/sprites/backgrounds/centipede_background.png"),
		"background_top": load("res://assets/sprites/backgrounds/centipede_background_top.png"),
		"battle_pos": Vector2(1130, 390),
		"start_story": CentipedeStories.start_story,
		"end_story": CentipedeStories.end_story,
		"phase_stories": [
			{ "threshold": 20, "story_entries": CentipedeStories.phase2_story },
		],
		"phases": [
#				ATTACK = 0, tri
#				DEFEND = 1, circ
#				BREAK_CHAIN = 6, tri
#				CLAW = 7, sq
#				FLYTRAP = 10, sq
#				PARRY = 13, sq
			# Phase 1 sequences
			[
				[10, 13, 6, 13, 10, 6, 10],
				[1, 13, 13, 13, 10, 6, 6],
				[13, 0, 1, 1, 0, 10, 13],
				[1, 10, 0, 0, 0, 10, 6],
				[1, 1, 0, 6, 1, 1, 10],
				[6, 0, 10, 0, 13, 10, 10],
				[10, 10, 10, 6, 13, 13, 0],
			],
			# Phase 2 sequences
			[
				[10, 10, 0, 6, 13, 0, 10],
				[6, 10, 10, 0, 13, 7, 6],
				[7, 0, 10, 13, 10, 0, 10],
				[0, 7, 7, 10, 10, 6, 10],
				[10, 6, 10, 7, 10, 10, 10],
				[0, 13, 10, 10, 13, 10, 10],
				[6, 6, 0, 13, 10, 6, 10],
				[7, 6, 13, 13, 6, 10, 7],
			]
		],
		"passives": [
			Enums.PASSIVE_EFFECT_TYPE.VINE
		]
	},
	{
		"name": "Weech",
		"health": 35,
		"frames": load("res://assets/resources/sprite_frames/characters/WitchSpriteFrames.tres"),
		"background": load("res://assets/sprites/backgrounds/witch_background.png"),
		"battle_pos": Vector2(1110, 150),
		"start_story": WitchStories.start_story,
		"end_story": WitchStories.end_story,
		"phase_stories": [
			{ "threshold": 21, "story_entries": WitchStories.phase2_story },
			{ "threshold": 12, "story_entries": WitchStories.phase3_story },
		],
		"phases": [
			# Phase 1 sequences
			[
				[12, 3, 0, 15, 1, 1, 12],
				[0, 3, 12, 1, 0, 1, 3],
				[1, 15, 3, 12, 0, 12, 1],
				[12, 1, 12, 12, 1, 15, 1],
				[12, 0, 0, 0, 12, 12, 1],
			],
			# Phase 2 sequences
			[
				[12, 16, 12, 16, 1, 12, 16],
				[1, 0, 0, 12, 12, 16, 1],
				[15, 16, 1, 16, 15, 1, 12],
				[12, 0, 1, 1, 16, 12, 15],
				[1, 15, 1, 16, 16, 12, 12],
			]
			,
			# Phase 3 sequences
			[
				[0, 12, 18, 18, 18, 12, 1],
				[18, 12, 0, 18, 16, 1, 12],
				[15, 15, 1, 1, 18, 12, 0],
				[12, 15, 16, 16, 18, 12, 1],
				[1, 18, 1, 18, 1, 12, 0],
				[16, 1, 16, 12, 12, 15, 18],
			]
		],
		"passives": [
			Enums.PASSIVE_EFFECT_TYPE.CUPID_ARROW,
		]
	},
	{
		"name": "Transcended Lizard",
		"health": 101,
		"frames": load("res://assets/resources/sprite_frames/characters/LizardSpriteFrames.tres"),
		"background": load("res://assets/sprites/backgrounds/lizard_background.png"),
		"battle_pos": Vector2(1110, 390),
		"flip_h": true,
		"start_story": LizardStories.start_story,
		"end_story": LizardStories.end_story,
		"phase_stories": [],
		"phases": [
			# Phase test sequences
			[
				[2, 2, 2, 2, 2, 2, 2, 2]
			],
		],
		"passives": [
			Enums.PASSIVE_EFFECT_TYPE.FOURTH_DIMENSION,
			Enums.PASSIVE_EFFECT_TYPE.FLY_WAVE,
			Enums.PASSIVE_EFFECT_TYPE.FRIENDSHIP,
		]
	},
]

func get_enemy() -> Dictionary:
	return enemies[curr_enemy_index]
