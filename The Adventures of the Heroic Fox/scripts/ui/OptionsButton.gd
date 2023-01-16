extends TextureButton

const DEFAULT_SCALE: float = 0.75
const HOVER_SCALE: float = 0.775
const HOVER_ANIM_DURATION: float = 0.05

export(String) var text
export(String) var unpressed_text
export(Texture) var pressed_texture
export(Texture) var unpressed_texture

var tweens: Dictionary = {
	"hover": null,
	"exit": null,
}

var was_not_hovering: bool = true

onready var label: Label = $Label

func _ready() -> void:
	label.text = text
	if toggle_mode:
		pressed = true
		connect("pressed", self, "_pressed")


func _physics_process(_delta: float) -> void:
	if is_hovered() and was_not_hovering:
		was_not_hovering = false
		CursorManager.set_cursor(Enums.CURSOR_TYPE.SELECT)
		play_hover_anim()
	elif not is_hovered() and not was_not_hovering:
		was_not_hovering = true
		CursorManager.set_cursor(Enums.CURSOR_TYPE.DEFAULT)
		play_exit_anim()


func set_text(_text: String) -> void:
	label.text = _text


func play_hover_anim() -> void:
	_stop_tween("exit")
	#AudioController.play_ui_sound(AudioController.BUBBLE_HOVER_SOUND)
	tweens["hover"] = create_tween()
	var percentage_self_x: float = \
		_get_percentage(DEFAULT_SCALE, HOVER_SCALE, rect_scale.x)
	tweens["hover"].tween_property(
		self, 
		"rect_scale:x", 
		HOVER_SCALE, 
		HOVER_ANIM_DURATION * percentage_self_x)
	tweens["hover"].parallel().tween_property(
		self, 
		"rect_scale:y",
		HOVER_SCALE,
		HOVER_ANIM_DURATION * percentage_self_x)


func play_exit_anim() -> void:
	_stop_tween("hover")
	tweens["exit"] = create_tween()
	var percentage_self_x: float = \
		_get_percentage(HOVER_SCALE, DEFAULT_SCALE, rect_scale.x)
	tweens["exit"].tween_property(
		self, 
		"rect_scale:x", 
		DEFAULT_SCALE, 
		HOVER_ANIM_DURATION * percentage_self_x)
	tweens["exit"].parallel().tween_property(
		self, 
		"rect_scale:y",
		DEFAULT_SCALE,
		HOVER_ANIM_DURATION * percentage_self_x)


func _stop_tween(tween_name: String) -> void:
	if is_instance_valid(tweens[tween_name]):
		tweens[tween_name].stop()


func _get_percentage(start: float, end: float, curr: float) -> float:
	var diff: float = abs(end - start)
	var curr_diff: float = abs(end - curr)
	return curr_diff / diff


func _pressed() -> void:
	if pressed:
		texture_normal = pressed_texture
		label.text = text
	else:
		texture_normal = unpressed_texture
		label.text = unpressed_text
