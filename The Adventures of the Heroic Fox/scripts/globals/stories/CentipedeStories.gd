extends Node

var start_story: Array = [
	Helper.to_entry("Hero", "What a wretched worm, I'll pull it out of its misery!"),
	Helper.to_entry("Squire", "I believe that's a centipede, sir."),
	Helper.to_entry("Squire", "And you thinking it's unsightly, doesn't mean it's life is miserable..."),
	Helper.to_entry("Centiworm", "AAAAGGGGHHGHHAAGAAAGHHGHGH!!!"),
	Helper.to_entry("Hero", "I believe the worm is on my side on this matter, dear squire."),
	Helper.to_entry("Hero", "Now stand aside and let me do my job!"),
]

var phase2_story: Array = [
	Helper.to_entry("Squire", "Watch out, sir! It's began using its claws!"),
	Helper.to_entry("Centiworm", "AAAAGGGGHHGHHAAGAAAGHHGHGH!!!"),
]

var end_story: Array = [
	Helper.to_entry("Centiworm", "EEEEEEEEKKKKGKGGGKGKGGG!!!"),
	Helper.to_entry("Squire", "Well done, sir! It's retreating!"),
	Helper.to_entry("Hero", "Good! I hadn't even begun to sweat, HA HA HA!"),
	Helper.to_entry("Squire", "As expected from you, sir! (I don't think we can sweat...)"),
]
