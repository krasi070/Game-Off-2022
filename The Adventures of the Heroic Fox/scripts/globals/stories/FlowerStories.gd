extends Node

var start_story: Array = [
	Helper.to_entry("Hero", "Is that a flower?"),
	Helper.to_entry("Squire", "I think so, sir. It looks like it was left all alone and it grew to this size."),
	Helper.to_entry("Abandoned Houseplant", "Are you a new friend?"),
	Helper.to_entry("Hero", "Hmm, this flower would make for a mighty fine bouquet for the princess..."),
	Helper.to_entry("Hero", "It's decided! I will defeat you and bring you to the princess!"),
	Helper.to_entry("Abandoned Houseplant", "You'll introduce me to new friends?"),
]

var phase2_story: Array = [
	Helper.to_entry("Hero", "Damn, I'm sick of these vines!"),
	Helper.to_entry("Squire", "I agree, sir."),
	Helper.to_entry("Abandoned Houseplant", "Why do you hurt me?"),
]

var end_story: Array = [
	Helper.to_entry("Abandoned Houseplant", "I don't want you as friends ;-;"),
	Helper.to_entry("Squire", "I think that might be enough, sir."),
	Helper.to_entry("Hero", "I was just getting started but if you say so."),
	Helper.to_entry("Hero", "Princess isn't here and this flower is way to ugly for her anyway."),
	Helper.to_entry("Abandoned Houseplant", ";-;"),
	Helper.to_entry("Squire", "Shall we move on to the next castle, sir?"),
	Helper.to_entry("Hero", "Yes, but first I need my beauty sleep."),
]
