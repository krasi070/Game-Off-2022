extends CanvasLayer

onready var action_sprite_container: Control = \
	$InfoBox/Margin/NinePatchRect/Margin/HBox/ActionSpriteContainer
onready var action_bottom_pic: AnimatedSprite = \
	$InfoBox/Margin/NinePatchRect/Margin/HBox/ActionSpriteContainer/BottomSprite
onready var action_top_pic: AnimatedSprite = \
	$InfoBox/Margin/NinePatchRect/Margin/HBox/ActionSpriteContainer/TopSprite
onready var passive_sprite_container: Control = \
	$InfoBox/Margin/NinePatchRect/Margin/HBox/PassiveEffectSpriteContainer
onready var passive_bottom_pic: Sprite = \
	$InfoBox/Margin/NinePatchRect/Margin/HBox/PassiveEffectSpriteContainer/BottomSprite
onready var passive_top_pic: Sprite = \
	$InfoBox/Margin/NinePatchRect/Margin/HBox/PassiveEffectSpriteContainer/TopSprite
onready var info_label: Label = \
	$InfoBox/Margin/NinePatchRect/Margin/HBox/VBox/VBox/Label
onready var name_label: Label = \
	$InfoBox/Margin/NinePatchRect/Margin/HBox/VBox/VBox/NameLabel

var showing_passive: bool = false
var showing_action: bool = false

func _ready() -> void:
	_connect_mouse_signals()
	hide()


func set_action_texture(data: Resource, shape_res: Resource = null) -> void:
	if is_instance_valid(shape_res):
		action_bottom_pic.frames = shape_res.shape_sprite_frames
	else:
		action_bottom_pic.frames = data.shape_sprite_frames
	action_top_pic.frames = data.action_sprite_frames
	action_sprite_container.show()
	passive_sprite_container.hide()


func set_passive_texture(data: Resource) -> void:
	passive_bottom_pic.texture = data.is_positive_texture
	passive_top_pic.texture = data.texture
	action_sprite_container.hide()
	passive_sprite_container.show()


func _connect_mouse_signals() -> void:
	Mouse.connect("hovered_action", self, "_hovered_action")
	Mouse.connect("exited_action", self, "_exited_action")
	Mouse.connect("hovered_passive", self, "_hovered_passive")
	Mouse.connect("exited_passive", self, "_exited_passive")


func _hovered_action(action: Node2D) -> void:
	set_action_texture(action.final_action, action.data)
	info_label.text = action.final_action.on_hover_text
	name_label.text = action.final_action.action_name.to_upper()
	if action.is_locked:
		name_label.text += " (locked)"
	show()
	showing_action = true


func _exited_action(_action_id: String) -> void:
	hide()
	showing_action = false
 

func _hovered_passive(passive_effect: Node2D) -> void:
	showing_passive = true
	set_passive_texture(passive_effect.data)
	info_label.text = passive_effect.data.on_hover_text
	name_label.text = passive_effect.data.passive_name.to_upper()
	show()


func _exited_passive(_passive_effect_id: String) -> void:
	hide()
