extends Resource
class_name PassiveEffectData

# Sprite data
export(Texture) var texture
export(SpriteFrames) var sprite_frames

# Enums
export(Enums.PASSIVE_EFFECT_TYPE) var passive_effect_type

# Text to display on hover
export(String) var passive_name
export(String, MULTILINE) var on_hover_text

# Other data
export(String) var signal_to_emit_on_click
export(bool) var is_permanent
export(bool) var is_positive
export(bool) var is_clickable = false
export(bool) var is_active_by_default = false
export(int) var associated_number
export(bool) var remove_on_zero

var is_positive_texture: Texture setget , get_is_positive_texture

var _positive_texture: Texture = load("res://assets/sprites/passives/positive_passive.png")
var _negative_texture: Texture = load("res://assets/sprites/passives/negative_passive.png")

func get_is_positive_texture() -> Texture:
	if is_positive:
		return _positive_texture
	return _negative_texture
