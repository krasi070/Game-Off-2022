extends Node

var choices: Array = [
	load("res://assets/resources/choices/FirstChoice.tres"),
	load("res://assets/resources/choices/FirstChoice.tres"),
	load("res://assets/resources/choices/SecondChoice.tres"),
]

var intermission_beginnings: Dictionary = {
	0: [
		Helper.to_entry("Squire", "Test test"),
		Helper.to_entry("Squire", "1 2 3"),
	],
	1: [
		Helper.to_entry("Squire", "The hero doesn't really like learning new things but it's essential that he gets stronger for future battles!"),
		Helper.to_entry("Squire", "But I found that if I whisper new ideas while he is sleeping, he dreams them and thinks that he came up with them."),
		Helper.to_entry("Squire", "He's quite happy when that happens."),
		Helper.to_entry("Squire", "I know some good action ideas from a book of tactics I read once, maybe I should teach him something from there."),
		Helper.to_entry("Squire", "What should I teach the hero?"),
		Helper.to_entry("Squire", "The ability to copy previous actions or..."),
		Helper.to_entry("Squire", "the ability to be more confident? (not that he really needs the second)"),
		Helper.to_entry("Squire", "Tough choice..."),
	],
	2: [
		Helper.to_entry("Squire", "Should I teach the hero how to parry or how to recover mid battle?"),
	]
}
