extends Resource
class_name ActionBlockData

# Sprite data
export(SpriteFrames) var action_sprite_frames

# Enums
export(Enums.ACTION_TYPE) var action_type
export(int) var priority
export(bool) var execute_again_after = false
export(Enums.SHAPE) var shape

# Text to display on hover
export(String) var action_name
export(String, MULTILINE) var on_hover_text

var shape_sprite_frames setget , get_shape_sprite_frames

var _shape_dict: Dictionary = {
	Enums.SHAPE.TRIANGLE: load("res://assets/resources/sprite_frames/actions/TriangleSpriteFrames.tres"),
	Enums.SHAPE.CIRCLE: load("res://assets/resources/sprite_frames/actions/CircleSpriteFrames.tres"),
	Enums.SHAPE.SQUARE: load("res://assets/resources/sprite_frames/actions/SquareSpriteFrames.tres"),
}

func get_shape_sprite_frames() -> SpriteFrames:
	return _shape_dict[shape]
