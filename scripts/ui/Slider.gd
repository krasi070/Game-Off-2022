extends Control

onready var label: Label = $Background/HBoxContainer/Label
onready var value_label: Label = $Background/HBoxContainer/ValueLabel
onready var slider: HSlider = $Background/HBoxContainer/HSlider


func _ready() -> void:
	connect("mouse_entered", self, "_mouse_entered")
	connect("mouse_exited", self, "_mouse_exited")


func set_label(text: String) -> void:
	label.text = text


func set_value_label(text: String) -> void:
	value_label.text = text


func set_min(min_val: float) -> void:
	slider.min_value = min_val


func set_max(max_val: float) -> void:
	slider.max_value = max_val


func set_step(step: float) -> void:
	slider.step = step


func set_value(val: float) -> void:
	slider.value = val


func get_slider() -> HSlider:
	return slider


func _mouse_entered() -> void:
	rect_scale = Vector2(1.03, 1.03)
	#AudioController.play_ui_sound(AudioController.BUBBLE_HOVER_SOUND)
	CursorManager.set_cursor(Enums.CURSOR_TYPE.SELECT)


func _mouse_exited() -> void:
	rect_scale = Vector2.ONE
	CursorManager.set_cursor(Enums.CURSOR_TYPE.DEFAULT)
