extends ColorRect

const DISPLAY_DURATION: float = 5.0
const EMPTY_EGO_BBCODE_TEXT: String = "[center][shake rate=10 level=10]the hero's ego is all dried up[/shake][/center]"

var tweens: Dictionary = {
	"show_empty_ego": null,
}

onready var label: RichTextLabel = $RichTextLabel

func _ready() -> void:
	hide()


func play_empty_ego_message_anim() -> void:
	if is_instance_valid(tweens["show_empty_ego"]):
		tweens["show_empty_ego"].stop()
	modulate = Color.white
	show()
	label.bbcode_text = EMPTY_EGO_BBCODE_TEXT
	tweens["show_empty_ego"] = create_tween()
	tweens["show_empty_ego"].connect("finished", self, "_tween_finished")
	tweens["show_empty_ego"].tween_property(
		self,
		"modulate:a",
		0.0,
		DISPLAY_DURATION)


func _tween_finished() -> void:
	hide()
