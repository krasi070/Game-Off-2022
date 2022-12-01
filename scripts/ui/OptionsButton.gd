extends TextureButton

export(String) var text

onready var label: Label = $Label
onready var shadow: TextureRect = $Shadow

func _ready() -> void:
	label.text = text
	shadow.rect_position = Vector2.ZERO
