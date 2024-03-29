extends Node

enum ACTION_TYPE {
	ATTACK = 0,
	DEFEND = 1,
	NOTHING = 2,
	COPY = 3,
	ARROGANCE = 4,
	ATTACK_UP = 5,
	BREAK_CHAIN = 6,
	CLAW = 7,
	DOUBLE_KNIVES = 8,
	ENCHANTED = 9,
	FLYTRAP = 10,
	HEAL = 11,
	THINKING = 12,
	PARRY = 13,
	POISON = 14,
	SMACK = 15,
	SPIDER = 16,
	LIZARD_HEAD = 17,
	MAGIC_HAT = 18,
}

enum CHOICE_TYPE {
	ACTION,
	PASSIVE_EFFECT,
}

enum PASSIVE_EFFECT_TYPE {
	EGO_BOOST,
	MOOD_DOWN,
	VINE,
	CHAIN_HEALTH,
	CURSE,
	CUPID_ARROW,
	FLY_WAVE,
	FOURTH_DIMENSION,
	FRIENDSHIP,
	FUTURE_SIGHT,
	NEW_PLAN,
	PLOT_ARMOR,
	PLUS_FLY,
	RAGE,
}

enum SHAPE {
	CIRCLE,
	TRIANGLE,
	SQUARE
}

enum ALIGNMENT {
	LEFT,
	RIGHT
}

enum CURSOR_TYPE {
	DEFAULT,
	EXAMINE,
	SELECT,
}

enum TUTORIAL {
	HERO_ACTIONS = 0,
	ENEMY_ACTIONS = 1,
	EGO = 2,
	PASSIVES = 3,
	END_TURN = 4,
	ENEMY_PASSIVES = 5,
}
