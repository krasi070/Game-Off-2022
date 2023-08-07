extends Node

var start_story: Array = [
	Helper.to_entry("Hero", "What is this? A rock?"),
	Helper.to_entry("Golem", "..."),
	Helper.to_entry("Squire", "I believe that is a golem, sir!"),
	Helper.to_entry("Hero", "Whatever it is, it's in my way! PREPARE YOURSELF, MONSTER!"),
#	Helper.to_entry("Hero", "Guess I have to show it a thing or two!"),
#	Helper.to_entry("Squire", "Before that, sir. Can I ask for a favor?"),
#	Helper.to_entry("Squire", "Can we move this textbox a bit? It's covering my face and I can't see."),
#	Helper.to_entry("Hero", "No need."),
#	Helper.to_entry("Hero", "I am the hero and I am visible, which is all that matters."),
#	Helper.to_entry("Squire", "(I meant that I can't see...)"),
#	Helper.to_entry("Hero", "Now... PREPARE YOURSELF, MONSTER!"),
	Helper.to_entry("Golem", "..."),
]

var phase2_story: Array = [
	Helper.to_entry("Hero", "Does this cretin know that he is keeping ME from saving the princess?"),
	Helper.to_entry("Golem", "..."),
	Helper.to_entry("Squire", "I believe golems don't have their own thoughts, sir."),
	Helper.to_entry("Hero", "Figures. Everyone has an excuse these days."),
]

var phase3_story: Array = [
	Helper.to_entry("Hero", "I'll give the cretin this, it knows how to fight."),
	Helper.to_entry("Golem", "..."),
	Helper.to_entry("Squire", "How humble of you, sir."),
	Helper.to_entry("Squire", "(It's just the tutorial but positive reinforcement is always a good thing)"),
]

var end_story: Array = [
	Helper.to_entry("Hero", "I think the golem has learned its lesson."),
	Helper.to_entry("Squire", "Sir! You called the golem by it's name!"),
	Helper.to_entry("Hero", "Yes, you're right."),
	Helper.to_entry("Hero", "I meant to say cretin."),
	Helper.to_entry("Squire", "..."),
	Helper.to_entry("Golem", "..."),
	Helper.to_entry("Squire", "Unfortunately, it seems like the princess isn't in this castle, sir."),
	Helper.to_entry("Hero", "On to the next one then!"),
	Helper.to_entry("Squire", "As you say, sir. We should first rest for the night, it's been a long and tiring day."),
]
