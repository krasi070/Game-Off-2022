extends Node2D

const ON_HOVER_SCALE: float = 1.2
const HOVER_ANIM_DURATION: float = 0.15

const SELECT_Y_OFFSET: float = 30.0
const SELECT_ANIM_DURATION: float = 0.15

const SWAP_ANIM_DURATION: float = 0.2

export var data: Resource

var is_in_intermission: bool = false
var selectable: bool = true
var is_locked: bool = false
var selected: bool = false
var is_doubled: bool = false
var final_action: Resource

var tweens: Dictionary = {
	"hover": null,
	"exit": null,
	"select": null,
	"unselect": null,
}

onready var top_sprites: Node2D = $TopSprites
onready var effect_sprite: AnimatedSprite = $TopSprites/EffectSprite
onready var vine_lock_sprite: AnimatedSprite = $TopSprites/VineLock
onready var top_shape_animated_sprite: AnimatedSprite = $TopSprites/ShapeSprite
onready var top_action_animated_sprite: AnimatedSprite = $TopSprites/ActionSprite
onready var two_x_animated_sprite: AnimatedSprite = $TwoXAnimatedSprite
onready var poof_animted_sprite: AnimatedSprite = $PoofSprite
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var area: Area2D = $Area2D

func _ready() -> void:
	set_is_doubled(false)
	vine_lock_sprite.hide()
	effect_sprite.hide()
	poof_animted_sprite.hide()


func set_sprite_data() -> void:
	top_shape_animated_sprite.frames = data.shape_sprite_frames
	top_shape_animated_sprite.animation = "boil"
	top_shape_animated_sprite.playing = true
	top_action_animated_sprite.frames = data.action_sprite_frames
	top_action_animated_sprite.animation = "boil"
	top_action_animated_sprite.playing = true
	effect_sprite.frames = data.action_sprite_frames
	effect_sprite.animation = "boil"
	effect_sprite.playing = true
	final_action = data


func update_after_swap() -> void:
	set_sprite_data()
	click()


func click() -> void:
	if not selectable:
		return
	selected = not selected
	if selected:
		play_select_anim()
	else:
		play_unselect_anim()


func lock() -> void:
	vine_lock_sprite.show()
	selectable = false
	is_locked = true


func is_equal(action: Node2D) -> bool:
	if has_meta("id") and action.has_meta("id"):
		return get_meta("id") == action.get_meta("id")
	return false


func set_is_doubled(doubled: bool) -> void:
	is_doubled = doubled
	two_x_animated_sprite.visible = is_doubled


func set_area_layer(layer: int) -> void:
	area.collision_layer = layer


func release_double() -> void:
	two_x_animated_sprite.animation = "poof"
	two_x_animated_sprite.frame = 0
	two_x_animated_sprite.scale = Vector2(0.4, 0.3)
	two_x_animated_sprite.speed_scale = SpeedManager.speed
	two_x_animated_sprite.playing = true
	yield(two_x_animated_sprite, "animation_finished")
	set_is_doubled(false)


func release() -> void:
	set_meta("id", "")
	selectable = false
	top_sprites.hide()
	poof_animted_sprite.show()
	poof_animted_sprite.frame = 0
	poof_animted_sprite.speed_scale = SpeedManager.speed
	poof_animted_sprite.playing = true
	yield(poof_animted_sprite, "animation_finished")
	queue_free()


func change_to(to_action_data: Resource) -> void:
	poof_animted_sprite.show()
	poof_animted_sprite.frame = 0
	poof_animted_sprite.speed_scale = SpeedManager.speed
	poof_animted_sprite.playing = true
	final_action = to_action_data
	top_action_animated_sprite.frames = to_action_data.action_sprite_frames
	top_action_animated_sprite.animation = "boil"
	top_action_animated_sprite.playing = true
	yield(poof_animted_sprite, "animation_finished")
	poof_animted_sprite.hide()


func set_effect_anim(active: bool) -> void:
	if active:
		effect_sprite.show()
		anim_player.play("effect")
	else:
		effect_sprite.hide()
		anim_player.stop()


func play_hover_anim() -> void:
	_stop_tween("exit")
	var percentage: float = _get_percentage(1, ON_HOVER_SCALE, top_sprites.scale.x)
	tweens["hover"] = create_tween()
	tweens["hover"].tween_property(
		top_sprites, 
		"scale", 
		Vector2(ON_HOVER_SCALE, ON_HOVER_SCALE), 
		HOVER_ANIM_DURATION * percentage)


func play_exit_anim() -> void:
	_stop_tween("hover")
	var percentage: float = _get_percentage(ON_HOVER_SCALE, 1, top_sprites.scale.x)
	tweens["exit"] = create_tween()
	tweens["exit"].tween_property(
		top_sprites, 
		"scale", 
		Vector2.ONE, 
		HOVER_ANIM_DURATION * percentage)


func play_select_anim() -> void:
	_stop_tween("unselect")
	var percentage: float = _get_percentage(0, SELECT_Y_OFFSET, position.y)
	tweens["select"] = create_tween()
	tweens["select"].tween_property(
		self, 
		"position", 
		Vector2(position.x, SELECT_Y_OFFSET), 
		SELECT_ANIM_DURATION * percentage)


func play_unselect_anim() -> void:
	_stop_tween("select")
	var percentage: float = _get_percentage(SELECT_Y_OFFSET, 0, position.y)
	tweens["unselect"] = create_tween()
	tweens["unselect"].tween_property(
		self, 
		"position", 
		Vector2(position.x, 0), 
		SELECT_ANIM_DURATION * percentage)


func unselect() -> void:
	self.position = Vector2(position.x, 0)
	selected = false


# Return anim duration
func play_before_swap_anim() -> float:
	var tween: SceneTreeTween = create_tween()
	tween.tween_property(self, "modulate", Color.transparent, SWAP_ANIM_DURATION)
	return SWAP_ANIM_DURATION


# Return anim duration
func play_after_swap_anim() -> float:
	var tween: SceneTreeTween = create_tween()
	tween.tween_property(self, "modulate", Color.white, SWAP_ANIM_DURATION)
	return SWAP_ANIM_DURATION


func _stop_tween(tween_name: String) -> void:
	if is_instance_valid(tweens[tween_name]):
		tweens[tween_name].stop()


func _get_percentage(start: float, end: float, curr: float) -> float:
	var diff: float = abs(end - start)
	var curr_diff: float = abs(end - curr)
	return curr_diff / diff
