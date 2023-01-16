extends CanvasLayer

const BACKGROUND_WAIT_TIME: float = 1.0

var is_transitioning: bool = false

onready var background: TextureRect = $Background
onready var fade: ColorRect = $Fade
onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	background.hide()
	fade.color = Color(0, 0, 0, 0)


func transition_to_scene(scene: String, show_bg: bool = true) -> void:
	if is_transitioning:
		return
	is_transitioning = true
	_set_input_activity(false)
	anim_player.play("fade in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene(scene)
	if show_bg:
		background.show()
		anim_player.play_backwards("fade in")
		yield(anim_player, "animation_finished")
		yield(get_tree().create_timer(BACKGROUND_WAIT_TIME), "timeout")
		anim_player.play("fade in")
		yield(anim_player, "animation_finished")
		background.hide()
	anim_player.play_backwards("fade in")
	yield(anim_player, "animation_finished")
	_set_input_activity(true)
	is_transitioning = false


func _set_input_activity(is_active: bool) -> void:
	set_process_input(is_active)
	Mouse.is_active = is_active
	Keyboard.is_active = is_active
	TextBox.is_active = is_active
