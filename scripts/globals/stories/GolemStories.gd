extends Node

var start_story: Array = [
	Helper.to_entry("Hero", "What is this? A rock?"),
	Helper.to_entry("Golem", "..."),
	Helper.to_entry("Squire", "I believe that is a golem, sir!"),
	Helper.to_entry("Hero", "Whatever it is, it's in my way!"),
	Helper.to_entry("Hero", "Guess I have to show it a thing or two!"),
	Helper.to_entry("Hero", "PREPARE YOURSELF!"),
	Helper.to_entry("Golem", "..."),
	Helper.to_entry("Squire", "(Let me see how did battles work again...)"),
	Helper.to_entry("Squire", "(Ah yes, everyone plans their next actions in a sequence and teligraphs them! Perfect!)"),
	Helper.to_entry("Squire", "(They are executed from left to right at the same time so positioning is important)"),
	Helper.to_entry("Squire", "(The hero sometimes makes tiny mistakes so I have to make sure I advise him correctly)"),
	Helper.to_entry("Squire", "(Maybe just suggesting swapping the position of a couple of actions if necessary would do the trick)"),
	Helper.to_entry("Squire", "(Have to be careful not to overdo it or his ego might get hurt and he gets really sad when that happens)"),
	Helper.to_entry("Squire", "(They're starting!)"),
]

var phase2_story: Array = [
	Helper.to_entry("Squire", "(I almost forgot!)"),
	Helper.to_entry("Squire", "(Actions also have a shape attached to them: a triangle, a circle, or a square)"),
	Helper.to_entry("Squire", "(If there are 3 or more actions in a row with the same shape, each action in the chain gets twice!)"),
	Helper.to_entry("Squire", "(I should keep that in mind when giving tips to the hero)"),
]

var phase3_story: Array = [
	Helper.to_entry("Hero", "You make a worthy opponent, but don't think you've won!"),
	Helper.to_entry("Golem", "..."),
	Helper.to_entry("Squire", "That's right, sir! You show him!"),
	Helper.to_entry("Squire", "(So far so good)"),
	Helper.to_entry("Squire", "(I think there was a way to undo my suggestion if I changed my mind but what was it...)"),
	Helper.to_entry("Squire", "(Ah, yes! By pressing (U) I can undo my swap suggestions and it'll be as if I nevere made them in the first place!)"),
	Helper.to_entry("Squire", "(I should keep that in mind)"),
]

var end_story: Array = [
	Helper.to_entry("Hero", "I think he's learned his lesson."),
	Helper.to_entry("Squire", "How merciful of you, sir."),
	Helper.to_entry("Golem", "..."),
	Helper.to_entry("Squire", "Unfortunately, it seems like the princess isn't in this castle."),
	Helper.to_entry("Hero", "On to the next one then!"),
	Helper.to_entry("Squire", "As you say, sir. We should first rest for the night, it's been a tiring day."),
	Helper.to_entry("Golem", "..."),
]
