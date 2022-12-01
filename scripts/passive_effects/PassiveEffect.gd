extends Node2D

const ON_HOVER_SCALE: float = 1.1
const HOVER_ANIM_DURATION: float = 0.15

export var data: Resource

var tweens: Dictionary = {
	"hover": null,
	"exit": null,
}

var is_in_intermission: bool = false

onready var background: Sprite = $Background
onready var sprite: Sprite = $Sprite
onready var label: Label = $Label

func set_visual_data() -> void:
	background.texture = data.is_positive_texture
	sprite.texture = data.texture
	if data.associated_number > 0:
		label.text = str(data.associated_number)
	else:
		label.hide()


func is_equal(passive: Node2D) -> bool:
	if has_meta("p_id") and passive.has_meta("p_id"):
		return get_meta("p_id") == passive.get_meta("p_id")
	return false


func play_hover_anim() -> void:
	_stop_tween("exit")
	var percentage: float = _get_percentage(1, ON_HOVER_SCALE, scale.x)
	tweens["hover"] = create_tween()
	tweens["hover"].tween_property(
		self, 
		"scale", 
		Vector2(ON_HOVER_SCALE, ON_HOVER_SCALE), 
		HOVER_ANIM_DURATION * percentage)


func play_exit_anim() -> void:
	_stop_tween("hover")
	var percentage: float = _get_percentage(ON_HOVER_SCALE, 1, scale.x)
	tweens["exit"] = create_tween()
	tweens["exit"].tween_property(
		self, 
		"scale", 
		Vector2.ONE, 
		HOVER_ANIM_DURATION * percentage)


func _stop_tween(tween_name: String) -> void:
	if is_instance_valid(tweens[tween_name]):
		tweens[tween_name].stop()


func _get_percentage(start: float, end: float, curr: float) -> float:
	var diff: float = abs(end - start)
	var curr_diff: float = abs(end - curr)
	return curr_diff / diff
