extends Node

var start_story: Array = [
	Helper.to_entry("Squire", "Watch out, sir! We've got a pirate in front of us!"),
	Helper.to_entry("Hero", "Do not fret my dear squire, for I shall protect you."),
	Helper.to_entry("Scratchy the Pirate", "What are ya staring at ya lil' runt?"),
	Helper.to_entry("Hero", "Eek!"),
	Helper.to_entry("Scratchy the Pirate", "Cat got yar tongue?"),
	Helper.to_entry("Scratchy the Pirate", "Or did ya come 'ere for this ol' cat to ring it out for ya?"),
	Helper.to_entry("Hero", "I, uh... no..."),
	Helper.to_entry("Hero", "I came here to have a duel with uh..."),
	Helper.to_entry("Scratchy the Pirate", "Shut ya trap! Yar voice is like nails on chalkboard!"),
	Helper.to_entry("Hero", "..."),
	Helper.to_entry("Squire", "(Oh no, the hero can't handle personalities like this pirate's)"),
	Helper.to_entry("Squire", "(I have to step in for my hero!)"),
	Helper.to_entry("Squire", "Do not speak to the brave sir like that or you will regret it!"),
	Helper.to_entry("Scratchy the Pirate", "Ho ho!"),
	Helper.to_entry("Scratchy the Pirate", "At least yar pet's got some bite."),
	Helper.to_entry("Scratchy the Pirate", "Time to say goodbye to yar life ya momma's boy!"),
]

var phase2_story: Array = [
	Helper.to_entry("Scratchy the Pirate", "Did ya do something? Aye didn't even feel it!"),
	Helper.to_entry("Hero", "You will... prepa..."),
	Helper.to_entry("Scratchy the Pirate", "By the seas, I told ya to shut ya trap boy, didn't aye!"),
]

var phase4_story: Array = [
	Helper.to_entry("Squire", "That's the spirit, sir! Show him who's the real man here!"),
	Helper.to_entry("Squire", "(The hero is going to need extra encouragement from me for this fight)"),
	Helper.to_entry("Scratchy the Pirate", "Aye can tell ya've neva' had a woman!"),
	Helper.to_entry("Scratchy the Pirate", "Too bad ya won't be walking outta 'ere alive to change that!"),
]

var phase3_story: Array = [
	Helper.to_entry("Scratchy the Pirate", "This is it! ya've done it now ya lil' runt!"),
	Helper.to_entry("Scratchy the Pirate", "Now ya've got me mad! No one gets me mad and gets away with it!"),
	Helper.to_entry("Scratchy the Pirate", "Kiss ya ugly arse goodbye!"),
]

var end_story: Array = [
	Helper.to_entry("Squire", "You did it, sir! You proved who's the real gentlemen here!"),
	Helper.to_entry("Hero", "Ha ha... I won."),
	Helper.to_entry("Hero", "Of course, I won! For I am the hero who will save the princess!"),
	Helper.to_entry("Scratchy the Pirate", "ROAR!"),
	Helper.to_entry("Hero", "Eeek!"),
	Helper.to_entry("Squire", "(We should get going...)"),
]
