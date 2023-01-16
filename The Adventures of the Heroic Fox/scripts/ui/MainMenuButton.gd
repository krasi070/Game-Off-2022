extends TextureButton

const HOVER_OFFSET: Vector2 = Vector2(20, 20)
const HOVER_ANIM_DURATION: float = 0.1

var was_not_hovering: bool = true

var original_position: Vector2
var shadow_original_position: Vector2

var tweens: Dictionary = {
	"hover": null,
	"exit": null,
}

onready var shadow: TextureRect = $Shadow

func _ready() -> void:
	original_position = rect_position
	shadow_original_position = shadow.rect_position


func _physics_process(_delta: float) -> void:
	if is_hovered() and was_not_hovering:
		was_not_hovering = false
		#CursorManager.set_cursor(Enums.CURSOR_TYPE.SELECT)
		play_hover_anim()
	elif not is_hovered() and not was_not_hovering:
		was_not_hovering = true
		#CursorManager.set_cursor(Enums.CURSOR_TYPE.DEFAULT)
		play_exit_anim()


func play_hover_anim() -> void:
	_stop_tween("exit")
	tweens["hover"] = create_tween()
	var percentage_self_x: float = \
		_get_percentage(original_position.x, (original_position - HOVER_OFFSET).x, rect_position.x)
	tweens["hover"].tween_property(
		self, 
		"rect_position:x", 
		(original_position - HOVER_OFFSET).x, 
		HOVER_ANIM_DURATION * percentage_self_x)
	var percentage_self_y: float = \
		_get_percentage(original_position.y, (original_position - HOVER_OFFSET).y, rect_position.y)
	tweens["hover"].parallel().tween_property(
		self, 
		"rect_position:y",
		(original_position - HOVER_OFFSET).y,
		HOVER_ANIM_DURATION * percentage_self_y)
	var percentage_shadow_x: float = \
		_get_percentage(shadow_original_position.x, (shadow_original_position + HOVER_OFFSET).x, shadow.rect_position.x)
	tweens["hover"].parallel().tween_property(
		shadow, 
		"rect_position:x", 
		(shadow_original_position + HOVER_OFFSET).x,
		HOVER_ANIM_DURATION * percentage_shadow_x)
	var percentage_shadow_y: float = \
		_get_percentage(shadow_original_position.y, (shadow_original_position + HOVER_OFFSET).y, shadow.rect_position.y)
	tweens["hover"].parallel().tween_property(
		shadow, 
		"rect_position:y", 
		(shadow_original_position + HOVER_OFFSET).y,
		HOVER_ANIM_DURATION * percentage_shadow_y)


func play_exit_anim() -> void:
	_stop_tween("hover")
	tweens["exit"] = create_tween()
	var percentage_self_x: float = \
		_get_percentage((original_position - HOVER_OFFSET).x, original_position.x, rect_position.x)
	tweens["exit"].tween_property(
		self, 
		"rect_position:x", 
		original_position.x, 
		HOVER_ANIM_DURATION * percentage_self_x)
	var percentage_self_y: float = \
		_get_percentage((original_position - HOVER_OFFSET).y, original_position.y, rect_position.y)
	tweens["exit"].parallel().tween_property(
		self, 
		"rect_position:y",
		original_position.y,
		HOVER_ANIM_DURATION * percentage_self_y)
	var percentage_shadow_x: float = \
		_get_percentage((shadow_original_position + HOVER_OFFSET).x, shadow_original_position.x, shadow.rect_position.x)
	tweens["exit"].parallel().tween_property(
		shadow, 
		"rect_position:x", 
		shadow_original_position.x,
		HOVER_ANIM_DURATION * percentage_shadow_x)
	var percentage_shadow_y: float = \
		_get_percentage((shadow_original_position + HOVER_OFFSET).y, shadow_original_position.y, shadow.rect_position.y)
	tweens["exit"].parallel().tween_property(
		shadow, 
		"rect_position:y", 
		shadow_original_position.y,
		HOVER_ANIM_DURATION * percentage_shadow_y)


func _stop_tween(tween_name: String) -> void:
	if is_instance_valid(tweens[tween_name]):
		tweens[tween_name].stop()


func _get_percentage(start: float, end: float, curr: float) -> float:
	var diff: float = abs(end - start)
	var curr_diff: float = abs(end - curr)
	return curr_diff / diff
