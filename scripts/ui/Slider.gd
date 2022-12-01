extends Control

onready var label: Label = $Background/HBoxContainer/Label
onready var value_label: Label = $Background/HBoxContainer/ValueLabel
onready var slider: HSlider = $Background/HBoxContainer/HSlider


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
