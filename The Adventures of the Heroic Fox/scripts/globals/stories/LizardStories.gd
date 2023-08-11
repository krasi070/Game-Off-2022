extends Node

var start_story: Array = [
	Helper.to_entry("Hero", "Where is this lizard, who has my princess?"),
	Helper.to_entry("Squire", "I believe it is behind the text box, sir."),
	Helper.to_entry("Hero", "And here I thought this was going to be a challenge."),
	Helper.to_entry("Squire", "Sir, you should know the lizard of this castle is said to be the wisest being alive."),
	Helper.to_entry("Squire", "It's thought to be the puppet master behind many recent wars."),
	Helper.to_entry("Transcended Lizard", "(stare)"),
	Helper.to_entry("Hero", "Don't make me laugh, dear squire. Let's get this over with and save the princess!"),
	Helper.to_entry("Transcended Lizard", "(stare)"),
]

var phase2_story: Array = [
	Helper.to_entry("Hero", "This lizard is... more sturdy that it looks."),
	Helper.to_entry("Transcended Lizard", "(stare)"),
	Helper.to_entry("Squire", "The rumors were true."),
	Helper.to_entry("Squire", "Make sure you take advantage of its weaknesses, sir!"),
]

var phase3_story: Array = [
	Helper.to_entry("Squire", "Great work, sir!"),
	Helper.to_entry("Hero", "How. Much. MORE!!!"),
	Helper.to_entry("Squire", "Just a lil' bit more, sir. Watch out for the lizard's deadly helmet!"),
]

var end_story: Array = [
	Helper.to_entry("Transcended Lizard", "(stare)"),
	Helper.to_entry("Transcended Lizard", "(cry)"),
	Helper.to_entry("Hero", "BRING US THE PRINCESS!!!"),
]
