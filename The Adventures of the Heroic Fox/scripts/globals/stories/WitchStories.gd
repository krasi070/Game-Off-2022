extends Node

var start_story: Array = [
	Helper.to_entry("Hero", "(Gulp) Hello, ma'am!"),
	Helper.to_entry("Weech", "Ew... Get lost loser!"),
	Helper.to_entry("Squire", "This'll be a rough battle for the hero..."),
]

var phase2_story: Array = [
	Helper.to_entry("Hero", "I do not fight with women!"),
	Helper.to_entry("Weech", "Whatever you say creep."),
	Helper.to_entry("Weech", "My spider friends will make short work of you. Won't you my lil' spidies."),
	Helper.to_entry("Hero", "Sp... sp... sp... SPIDERS!"),
	Helper.to_entry("Squire", "Oh no..."),
]

var phase3_story: Array = [
	Helper.to_entry("Weech", "Eeny, meeny, miny, moe, let's see what's inside my magic hat this time."),
	Helper.to_entry("Weech", "I foresee a dead fox!"),
	Helper.to_entry("Squire", "Sir, I believe it might be best to reconsider your chances with this lady."),
	Helper.to_entry("Hero", "For once I agree with you my squire..."),
	Helper.to_entry("Hero", "Let's get this over with, I need plenty of sleep after battling these horrific sp... sp..."),
	Helper.to_entry("Squire", "Stay strong, sir!"),
]

var end_story: Array = [
	Helper.to_entry("Hero", "I demand you give us back our princess!"),
	Helper.to_entry("Hero", "...madam"),
	Helper.to_entry("Weech", "Princess? The closest princess here is the one in the lizard's castle."),
	Helper.to_entry("Squire", "So the princess isn't here?"),
	Helper.to_entry("Weech", "No? Why would I want your princess, beat it!"),
	Helper.to_entry("Squire", "Oh... maybe we should have asked first..."),
	Helper.to_entry("Weech", "I said BEAT IT!"),
	Helper.to_entry("Squire", "We should go, sir."),
]

#var end_story: Array = [
#	Helper.to_entry("Hero", "Wait, is this the last battle!? Do you have the princess?"),
#	Helper.to_entry("Weech", "No? Why would I want your princess, beat it!"),
#	Helper.to_entry("Squire", "It seems like our adventures are only beginning..."),
#	Helper.to_entry("Squire", "Thanks for playing! We'll see you soon with the rest of our adventure!"),
#]
