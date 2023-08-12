extends Node2D

const WAIT_TIME_DEFAULT: float = 0.5

export(ShaderMaterial) var shader_material

var unit: UnitStats setget set_unit
var non_center_spawn_point: Position2D
var anim_name_suffix: String
var anim_active: bool = false
var wait_time: float

onready var anim_sprite: AnimatedSprite = $AnimatedSprite
onready var effect_sprite: AnimatedSprite = $EffectSprite
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var left_text_spawner: Position2D = $LeftTextSpawnPoint
onready var center_text_spawner: Position2D = $CenterTextSpawnPoint
onready var right_text_spawner: Position2D = $RightTextSpawnPoint

onready var text_effect: PackedScene = preload("res://scenes/ui/TextEffect.tscn")

func _ready() -> void:
	wait_time = WAIT_TIME_DEFAULT / SpeedManager.speed
	anim_player.playback_speed = SpeedManager.speed
	effect_sprite.material = shader_material
	anim_player.connect("animation_finished", self, "_anim_player_animation_finished")
	SpeedManager.connect("changed_speed", self, "_speed_manager_changed_speed")


func set_unit(_unit: UnitStats) -> void:
	unit = _unit
	if unit.character_name.to_lower() == "hero":
		non_center_spawn_point = right_text_spawner
		anim_name_suffix = ""
	else:
		non_center_spawn_point = left_text_spawner
		anim_name_suffix = "_right"
	unit.connect("attacked", self, "_unit_attacked")
	unit.connect("hurt", self, "_unit_hurt")
	unit.connect("defended", self, "_unit_defended")
	unit.connect("did_nothing", self, "_unit_did_nothing")
	unit.connect("broke_chain", self, "_unit_broke_chain")
	unit.connect("used_attack_up", self, "_unit_used_attack_up")
	unit.connect("was_enchanted", self, "_unit_was_enchanted")
	unit.connect("healed", self, "_unit_healed")
	if unit.character_name == PlayerStats.character_name:
		(unit as PlayerStats).connect("used_arrogance", self, "_unit_used_arrogance")


func set_sprite_frames(frames: SpriteFrames) -> void:
	anim_sprite.frames = frames
	anim_sprite.animation = "idle"
	effect_sprite.frames = frames
	effect_sprite.animation = "idle"


func set_is_sprite_anim_playing(is_playing: bool) -> void:
	anim_sprite.playing = is_playing
	effect_sprite.playing = is_playing


func play_leave_anim() -> void:
	anim_player.play("enemy_leave")


func play_appear_anim() -> void:
	anim_player.play_backwards("enemy_leave")


func play_attack_anim(attack_frames: SpriteFrames) -> void:
	var instance: Control = _create_text_effect_instance(center_text_spawner.global_position)
	instance.play_attacked_anim(attack_frames, anim_name_suffix)
	anim_player.play("attack" + anim_name_suffix)


func play_nothing_anim(nothing_frames: SpriteFrames) -> void:
	var instance: Control = _create_text_effect_instance(non_center_spawn_point.global_position)
	instance.play_nothing_anim(nothing_frames)


func play_break_chain_anim() -> void:
	var instance: Control = _create_text_effect_instance(non_center_spawn_point.global_position)
	instance.play_break_chain_anim()


func play_hurt_anim(damage: int) -> void:
	yield(get_tree().create_timer(WAIT_TIME_DEFAULT / SpeedManager.speed), "timeout")
	var instance: Control = _create_text_effect_instance(non_center_spawn_point.global_position)
	instance.play_damaged_anim(damage)
	anim_player.play("hurt" + anim_name_suffix)


func play_defended_anim() -> void:
	var instance: Control = _create_text_effect_instance(center_text_spawner.global_position)
	instance.play_defended_anim()
	anim_player.play("defend")


func play_used_arrogance_anim(_added_ego: int) -> void:
	var instance: Control = _create_text_effect_instance(center_text_spawner.global_position)
	instance.play_used_arrogance_anim()
	anim_player.play("used_arrogance")


func play_used_attack_up_anim() -> void:
	var instance: Control = _create_text_effect_instance(center_text_spawner.global_position)
	instance.play_used_attack_up_anim()
	anim_player.play("used_attack_up")


func play_parried_anim() -> void:
	var instance: Control = _create_text_effect_instance(center_text_spawner.global_position)
	instance.play_parried_anim()
	# Reuse
	anim_player.play("used_attack_up")


func play_enchanted_anim() -> void:
	var instance: Control = _create_text_effect_instance(center_text_spawner.global_position)
	instance.play_enchanted_anim()
	anim_player.play("was_enchanted")


func play_healed_anim(heal_frames: SpriteFrames, amount: int) -> void:
	var instance_one: Control = _create_text_effect_instance(center_text_spawner.global_position)
	instance_one.play_healed_anim(heal_frames)
	if amount > 0:
		var instance_two: Control = _create_text_effect_instance(non_center_spawn_point.global_position)
		instance_two.play_healed_amount_anim(amount)
	anim_player.play("healed")


func _create_text_effect_instance(pos: Vector2) -> Control:
	var text_effect_instance: Control = text_effect.instance()
	get_tree().root.add_child(text_effect_instance)
	text_effect_instance.rect_position = pos
	return text_effect_instance


func _unit_attacked(attack_frames: SpriteFrames) -> void:
	if anim_active:
		play_attack_anim(attack_frames)


func _unit_hurt(damage: int) -> void:
	if anim_active:
		play_hurt_anim(damage)


func _unit_defended() -> void:
	if anim_active:
		play_defended_anim()


func _unit_did_nothing(nothing_frames: SpriteFrames) -> void:
	if anim_active:
		play_nothing_anim(nothing_frames)


func _unit_broke_chain() -> void:
	if anim_active:
		play_break_chain_anim()


func _unit_was_enchanted() -> void:
	if anim_active:
		play_enchanted_anim()


func _unit_healed(heal_frames: SpriteFrames, healed_for: int) -> void:
	if anim_active:
		play_healed_anim(heal_frames, healed_for)


func _unit_used_arrogance(added_ego: int) -> void:
	if anim_active:
		play_used_arrogance_anim(added_ego)


func _unit_used_attack_up() -> void:
	if anim_active:
		play_used_attack_up_anim()


func _unit_parried() -> void:
	if anim_active:
		play_parried_anim()


func _anim_player_animation_finished(_anim_name: String) -> void:
	effect_sprite.hide()


func _speed_manager_changed_speed() -> void:
	anim_player.playback_speed = SpeedManager.speed
	wait_time = WAIT_TIME_DEFAULT / SpeedManager.speed
