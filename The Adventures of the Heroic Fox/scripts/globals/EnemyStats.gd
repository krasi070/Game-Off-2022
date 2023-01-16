extends UnitStats

var phase_stories: Array
var phase: int = 0

var action_seq_pool: Array = []

var played_start_story: bool = false

func is_new_phase_reached() -> bool:
	return phase_stories.size() > 0 and phase_stories[0].threshold >= health


func update_phase() -> void:
	for i in range(phase_stories.size()):
		if phase_stories[i].threshold < health:
			break
		phase += 1


func get_phase_story() -> Array:
	var entries: Array = []
	while phase_stories.size() > 0 and phase_stories[0].threshold >= health:
		entries.append_array(phase_stories.pop_front().story_entries)
	return entries
