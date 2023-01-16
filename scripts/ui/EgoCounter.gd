extends HBoxContainer

const LOSE_EGO_ANIM_DURATION: float = 0.5
const LOSE_EGO_ANIM_FALL_DISTANCE: float = 50.0
const GAIN_EGO_ANIM_DURATION: float = 0.3
const GAIN_EGO_ANIM_SCALE: float = 1.2

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

onready var effect_sprites: Array = [
	$Icon1/EffectSprite,
	$Icon2/EffectSprite,
	$Icon3/EffectSprite,
	$Icon4/EffectSprite,
	$Icon5/EffectSprite,
]

func _ready() -> void:
	for sprite in effect_sprites:
		sprite.hide()


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
		_value = max_value
	var diff: int = value - _value
	if diff > 0:
		play_lose_ego_anim(range(_value, value))
	elif diff < 0:
		play_gain_ego_anim(range(value, _value))
	value = _value
	for i in range(value):
		icons[i].texture = ego_full_texture
		icons[i].self_modulate = Color.white
	for i in range(value, max_value):
		icons[i].texture = ego_empty_texture
		icons[i].self_modulate = Color(1, 1, 1, 0.6)


func play_gain_ego_anim(indexes: Array) -> void:
	for index in indexes:
		_play_single_gain_ego_anim(icons[index])


func _play_single_gain_ego_anim(icon: TextureRect) -> void:
	var tween: SceneTreeTween = create_tween()
	tween.tween_property(
		icon, 
		"rect_scale:x",
		GAIN_EGO_ANIM_SCALE,
		GAIN_EGO_ANIM_DURATION / 2)
	tween.parallel().tween_property(
		icon,
		"rect_scale:y",
		GAIN_EGO_ANIM_SCALE,
		GAIN_EGO_ANIM_DURATION / 2)
	yield(tween, "finished")
	tween = create_tween()
	tween.tween_property(
		icon, 
		"rect_scale:x",
		1.0,
		GAIN_EGO_ANIM_DURATION / 2)
	tween.parallel().tween_property(
		icon,
		"rect_scale:y",
		1.0,
		GAIN_EGO_ANIM_DURATION / 2)


func play_lose_ego_anim(indexes: Array) -> void:
	for index in indexes:
		effect_sprites[index].position = Vector2.ZERO
		effect_sprites[index].self_modulate = Color.white
		effect_sprites[index].show()
		var tween: SceneTreeTween = create_tween()
		tween.connect("finished", self, "_effect_sprite_tween_finished", [index])
		tween.tween_property(
			effect_sprites[index], 
			"position:y",
			LOSE_EGO_ANIM_FALL_DISTANCE,
			LOSE_EGO_ANIM_DURATION)
		tween.parallel().tween_property(
			effect_sprites[index],
			"self_modulate:a",
			0.0,
			LOSE_EGO_ANIM_DURATION)


func _effect_sprite_tween_finished(index: int) -> void:
	effect_sprites[index].hide()
