extends Node2D

signal pressed_execute

const ON_HOVER_SCALE: float = 1.2
const HOVER_ANIM_DURATION: float = 0.05

var tweens: Dictionary = {
	"hover": null,
	"exit": null,
	"appear": null,
	"hide": null,
}

var is_active: bool = false

onready var squire_sprite: AnimatedSprite = $SquireAnimatedSprite
onready var bubble_sprite: Sprite = $Bubble
onready var bubble_label: Label = $Bubble/Label

func _ready() -> void:
	_connect_to_mouse_events()
	squire_sprite.animation = "idle"
	squire_sprite.playing = true
	is_active = false
	bubble_sprite.modulate = Color.transparent


func _connect_to_mouse_events() -> void:
	Mouse.connect("hovered_bubble", self, "_hovered_bubble")
	Mouse.connect("exited_bubble", self, "_exited_bubble")
	Mouse.connect("clicked_bubble", self, "_clicked_bubble")


func appear_bubble() -> void:
	_stop_tween("hover")
	_stop_tween("exit")
	is_active = true
	tweens["appear"] = create_tween()
	tweens["appear"].tween_property(
		bubble_sprite, 
		"modulate:a", 
		1.0,
		HOVER_ANIM_DURATION)
	yield(tweens["appear"], "finished")
	is_active = true


func hide_bubble() -> void:
	_stop_tween("hover")
	_stop_tween("exit")
	is_active = false
	CursorManager.set_cursor(Enums.CURSOR_TYPE.DEFAULT)
	tweens["hide"] = create_tween()
	tweens["hide"].tween_property(
		bubble_sprite, 
		"modulate:a", 
		0.0,
		HOVER_ANIM_DURATION)


func play_hover_anim() -> void:
	_stop_tween("exit")
	var percentage: float = _get_percentage(1, ON_HOVER_SCALE, scale.x)
	tweens["hover"] = create_tween()
	tweens["hover"].tween_property(
		bubble_sprite, 
		"scale", 
		Vector2(ON_HOVER_SCALE, ON_HOVER_SCALE), 
		HOVER_ANIM_DURATION * percentage)


func play_exit_anim() -> void:
	_stop_tween("hover")
	var percentage: float = _get_percentage(ON_HOVER_SCALE, 1, scale.x)
	tweens["exit"] = create_tween()
	tweens["exit"].tween_property(
		bubble_sprite, 
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


func _clicked_bubble() -> void:
	if is_active:
		emit_signal("pressed_execute")


func _hovered_bubble() -> void:
	if is_active:
		play_hover_anim()
		CursorManager.set_cursor(Enums.CURSOR_TYPE.SELECT)


func _exited_bubble() -> void:
	if is_active:
		play_exit_anim()
		CursorManager.set_cursor(Enums.CURSOR_TYPE.DEFAULT)
