extends HBoxContainer

export var ego_full_texture: Texture
export var ego_empty_texture: Texture

var max_value: int = 5 setget set_max_value
var value: int = 3 setget set_value

onready var icons: Array = [
	$Icon1,
	$Icon2,
	$Icon3,
	$Icon4,
	$Icon5,
]

func set_max_value(_max_value: int) -> void:
	if _max_value > icons.size():
		return
	max_value = _max_value
	for i in range(max_value):
		icons[i].show()
	for i in range(max_value, icons.size()):
		icons[i].hide()


func set_value(_value: int) -> void:
	if _value > max_value:
		return
	value = _value
	for i in range(value):
		icons[i].texture = ego_full_texture
		icons[i].self_modulate = Color.white
	for i in range(value, max_value):
		icons[i].texture = ego_empty_texture
		icons[i].self_modulate = Color(1, 1, 1, 0.6)
