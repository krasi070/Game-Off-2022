extends TextureProgress

export(Enums.ALIGNMENT) var alignment: int
export(Texture) var progress_texture

var wrapper: String = ""

onready var health_label: RichTextLabel = $RichTextLabel

func _ready() -> void:
	_set_alignment()
	texture_progress = progress_texture
	connect("value_changed", self, "_value_changed")


func _set_alignment() -> void:
	if alignment == Enums.ALIGNMENT.LEFT:
		fill_mode = FILL_LEFT_TO_RIGHT
		wrapper = "%s"
	elif alignment == Enums.ALIGNMENT.RIGHT:
		fill_mode = FILL_RIGHT_TO_LEFT
		wrapper = "[right]%s[/right]"


func _value_changed(new_value: float) -> void:
	var inner_wrapper: String = "%s"
	if new_value < max_value / 2:
		inner_wrapper = "[shake rate=12 level=20]%s[/shake]"
	var inner_text: String = "%d/%d" % [new_value, max_value]
	health_label.bbcode_text = wrapper % (inner_wrapper % inner_text)
