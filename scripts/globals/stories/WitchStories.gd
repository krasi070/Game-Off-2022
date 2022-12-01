extends Node

var start_story: Array = [
	Helper.to_entry("Hero", "*gulp* Hello, ma'am!"),
	Helper.to_entry("Weech", "Ew... Get lost loser!"),
	Helper.to_entry("Squire", "This'll be a rough battle for the hero..."),
]

var phase2_story: Array = [
	Helper.to_entry("Hero", "I do not fight with women!"),
	Helper.to_entry("Weech", "Watever you say creep."),
	Helper.to_entry("Squire", "..."),
]

var end_story: Array = [
	Helper.to_entry("Hero", "Wait, is this the last battle!? Do you have the princess?"),
	Helper.to_entry("Weech", "No? Why would I want your princess, beat it!"),
	Helper.to_entry("Squire", "It seems like our adventures are only beginning..."),
	Helper.to_entry("Squire", "Thanks for playing! We'll see you soon with the rest of our adventure!"),
]
