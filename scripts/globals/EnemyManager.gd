extends Node

const LAST_ENEMY: int = 2

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
		"health": 25,
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
		"name": "Weech",
		"health": 25,
		"frames": load("res://assets/resources/sprite_frames/characters/WitchSpriteFrames.tres"),
		"background": load("res://assets/sprites/backgrounds/witch_background.png"),
		"battle_pos": Vector2(1110, 150),
		"start_story": WitchStories.start_story,
		"end_story": WitchStories.end_story,
		"phase_stories": [
			{ "threshold": 15, "story_entries": FlowerStories.phase2_story },
		],
		"phases": [
			# Phase 1 sequences
			[
				[0, 2, 2, 15, 1, 1, 2],
				[0, 3, 2, 2, 0, 2, 1],
				[15, 3, 2, 2, 0, 2, 15],
				[1, 3, 2, 2, 1, 2, 1],
				[3, 0, 2, 0, 2, 2, 1],
			],
			# Phase 2 sequences
			[
				[0, 2, 2, 15, 1, 1, 2],
				[0, 3, 2, 2, 0, 2, 1],
				[15, 3, 2, 2, 0, 2, 15],
				[16, 0, 15, 1, 2, 2, 0],
				[2, 2, 16, 1, 16, 2, 0],
				[16, 2, 16, 1, 16, 2, 16],
				[15, 16, 2, 2, 16, 3, 1],
			]
		],
		"passives": [
			Enums.PASSIVE_EFFECT_TYPE.CUPID_ARROW,
		]
	},
	{
		"name": "Transcended Lizard",
		"health": 1,
		"frames": load("res://assets/resources/sprite_frames/characters/LizardSpriteFrames.tres"),
		"background": load("res://assets/sprites/backgrounds/lizard_background.png"),
		"battle_pos": Vector2(1110, 390),
		"flip_h": true,
		"start_story": LizardStories.start_story,
		"phase_stories": [],
		"phases": [[]]
	},
	{
		"name": "Scratchy the Pirate",
		"health": 20,
		"frames": load("res://assets/resources/sprite_frames/characters/PirateSpriteFrames.tres"),
		"background": load("res://assets/sprites/backgrounds/pirate_background.png"),
		"battle_pos": Vector2(1150, 150),
		"start_story": PirateStories.start_story,
		"phase_stories": [],
		"phases": [[]]
	},
	{
		"name": "Centiworm",
		"health": 100,
		"frames": load("res://assets/resources/sprite_frames/characters/CentipedeSpriteFrames.tres"),
		"background": load("res://assets/sprites/backgrounds/centipede_background.png"),
		"battle_pos": Vector2(1150, 150),
		"start_story": CentipedeStories.start_story,
		"phase_stories": [],
		"phases": [[]]
	},
]

func get_enemy() -> Dictionary:
	return enemies[curr_enemy_index]
