extends Node

var choices: Array = [
	null,
	load("res://assets/resources/choices/FirstChoice.tres"),
	load("res://assets/resources/choices/SecondChoice.tres"),
	load("res://assets/resources/choices/ThirdChoice.tres"),
	load("res://assets/resources/choices/FourthChoice.tres"),
	load("res://assets/resources/choices/FifthChoice.tres"),
]

var action_tutorial: Array = [
	Helper.to_entry("Squire", "(Let's see, how did battles work again?)"),
	Helper.to_entry("Squire", "(Ah yes, both combatants plan out their actions in a sequence)"),
	Helper.to_entry("Squire", "(Once they are ready, their plans are executed from left to right action by action)"),
	Helper.to_entry("Squire", "(Vertically aligned actions are considered to be in the same time interval and get executed simultaneously)"),
	Helper.to_entry("Squire", "(Because of this, action positioning matters a lot)"),
	Helper.to_entry("Squire", "(If an enemy is using an attack action, it's usually best to defend in that inteval if possible)"),
	Helper.to_entry("Squire", "(The top plan of actions is the Golem's)", Enums.TUTORIAL.ENEMY_ACTIONS),
	Helper.to_entry("Squire", "(The bottom plan of actions is the hero's)", Enums.TUTORIAL.HERO_ACTIONS),
	Helper.to_entry("Squire", "(Often, the hero will need some help with his plan, but he'll only take my advice if his ego isn't too hurt)"),
	Helper.to_entry("Squire", "(Now... What actions should I tell the hero to swap?)"),
#	Helper.to_entry("Squire", "(Sometimes the hero's plan can be a bit... let's say lacking)"),
#	Helper.to_entry("Squire", "(This isn't the hero's fault, of course)"),
#	Helper.to_entry("Squire", "(Any sir in his paws would have so much on their plate as a hero that their mind would explode)"),
#	Helper.to_entry("Squire", "(The mere fact that the hero can function to the degree he does with all his responsibilities should be applauded)"),
#	Helper.to_entry("Squire", "(Back to the point, I sometimes try and help the hero, take a little load off of him by nudging him in the right direction)"),
#	Helper.to_entry("Squire", "(To not hurt his ego too much, I just recommend swapping the positions of a few actions or so)"),
#	Helper.to_entry("Squire", "(I take care not to overdo it or my dear hero will get upset)"),
#	Helper.to_entry("Squire", "(But I fret not, even when his mood is down he can still fight... albeit with some side effects)"),
#	Helper.to_entry("Squire", "(That's enough! I should focus and help the hero!)"),
]

var undo_and_speed_tutorial: Array = [
	Helper.to_entry("Squire", "(Alas, I sometimes too make mistakes)"),
	Helper.to_entry("Squire", "(We can't all be heroes after all)"),
	Helper.to_entry("Squire", "(When that happens, I can undo the swaps I did that turn, along with the ego hit I dealt the hero, with the (U) button)"),
	Helper.to_entry("Squire", "(I also now remember that if a battle was dragging on for too long, I could increase the battle speed from the (P)ause menu)"),
	Helper.to_entry("Squire", "(Hope I don't forget these things again, I don't want to be a liability to the hero)"),
	Helper.to_entry("Squire", "(Hmm... Now that I look at the hero's plan for this turn, it looks pretty good)"),
	Helper.to_entry("Squire", "(I should encourage his plan by leaving it as is!)"),
]

var chain_tutorial: Array = [
	Helper.to_entry("Squire", "(How could I forget!)"),
	Helper.to_entry("Squire", "(Each action has a corresponding shape attached to it)"),
	Helper.to_entry("Squire", "(If a plan has 3 or more consecutive actions with the same shape, a chain will be formed)"),
	Helper.to_entry("Squire", "(Actions in the chain get executed twice, which can be a huge advantage)"),
	Helper.to_entry("Squire", "(If the opponent doesn't have a doubled action in the same interval as the hero then they don't have anything to counter with)"),
	Helper.to_entry("Squire", "(But the same is also true the other way around)"),
	Helper.to_entry("Squire", "(I need to make sure the hero makes use of chains and doubled actions as much as possible!)"),
	Helper.to_entry("Squire", "(Hopefully, seeing it all executed now will remind me in full how it worked)"),
]

var ego_boost_tutorial: Array = [
	Helper.to_entry("Squire", "(When I leave the hero's plan intact, he gets a big ego boost)"),
	Helper.to_entry("Squire", "(The details of buffs and debuffs like the ego boost can be seen here)", Enums.TUTORIAL.PASSIVES),
	Helper.to_entry("Squire", "(I shouldn't make him wait)", Enums.TUTORIAL.PASSIVES),
	Helper.to_entry("Squire", "Brilliant plan, sir! Go ahead and make them regret the day they met you!"),
]

var mood_down_tutorial: Array = [
	Helper.to_entry("Squire", "(Oh no, the hero has no ego left!)"),
	Helper.to_entry("Squire", "(Thankfully, our brave hero can still fight on, but his delicate and emotional heart will take double the damage this turn)", Enums.TUTORIAL.PASSIVES),
	Helper.to_entry("Squire", "Don't worry, sir! Everyone still loves you!"),
]

var enemy_passives_tutorial: Array = [
	Helper.to_entry("Squire", "(This flower seems to have a special ability)", Enums.TUTORIAL.ENEMY_PASSIVES),
	Helper.to_entry("Squire", "(I should have a look at it)", Enums.TUTORIAL.ENEMY_PASSIVES),
]

var intermission_beginnings: Dictionary = {
	0: [
		Helper.to_entry("Squire", "If you see this text, something went wrong..."),
	],
	1: [
		Helper.to_entry("Squire", "The hero doesn't really like learning new things but it's essential that he gets stronger for future battles!"),
		Helper.to_entry("Squire", "I found that if I whisper new ideas in his ear while he is sleeping, he dreams them and thinks that he came up with them."),
		Helper.to_entry("Squire", "He's quite happy when that happens."),
		Helper.to_entry("Squire", "I know some good action ideas from a book of tactics I once read. Maybe I should teach him something from there."),
		Helper.to_entry("Squire", "What should I teach the hero?"),
		Helper.to_entry("Squire", "The ability to copy actions..."),
		Helper.to_entry("Squire", "or the ability to be more confident?"),
		Helper.to_entry("Squire", "(Should I really teach him that second one...)"),
	],
	2: [
		Helper.to_entry("Squire", "From here on onwards, the opponents the hero will face will most likely have some sort of passive ablities like that flower."),
		Helper.to_entry("Squire", "I'm sure the hero would benefit as well from learning such an ability."),
		Helper.to_entry("Squire", "Maybe something that involves healing..."),
		Helper.to_entry("Squire", "or something that will make the hero reconsider his initial plan?"),
	],
	3: [
		Helper.to_entry("Squire", "That pirate had some good tricks up his sleeve."),
		Helper.to_entry("Squire", "Maybe I should teach the hero about parrying..."),
		Helper.to_entry("Squire", "or would healing be more beneficial?"),
	],
	4: [
		Helper.to_entry("Squire", "Should I teach the hero what plot armor is..."),
		Helper.to_entry("Squire", "or should I expand his planning extents?"),
	],
	5: [
		Helper.to_entry("Squire", "We finally know where the princess is!"),
		Helper.to_entry("Squire", "The hero needs some more attack power for this last battle."),
		Helper.to_entry("Squire", "Should I teach the hero how to increase the strength of his current attacks..."),
		Helper.to_entry("Squire", "or teach him a new deadly attack type."),
	],
}
