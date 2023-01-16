extends Control

onready var damage_label: Label = $DamageLabel
onready var heal_label: Label = $HealLabel
onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	damage_label.hide()
	heal_label.hide()
	animated_sprite.hide()
	anim_player.connect("animation_finished", self, "_anim_player_animation_finished")


func play_damaged_anim(damage: int) -> void:
	damage_label.text = "-%d" % damage
	damage_label.show()
	anim_player.play("damaged_effect") 


func play_healed_amount_anim(amount: int) -> void:
	heal_label.text = "+%d" % amount
	heal_label.show()
	anim_player.play("healed_amount_effect") 


func play_defended_anim() -> void:
	animated_sprite.show()
	anim_player.play("defended_effect2")


func play_attacked_anim(attack_frames: SpriteFrames, animation_suffix: String = "") -> void:
	animated_sprite.frames = attack_frames
	animated_sprite.animation = "boil"
	animated_sprite.playing = true
	animated_sprite.show()
	anim_player.play("attack_effect" + animation_suffix)


func play_nothing_anim(nothing_frames: SpriteFrames) -> void:
	animated_sprite.frames = nothing_frames
	animated_sprite.animation = "boil"
	animated_sprite.playing = true
	animated_sprite.show()
	anim_player.play("nothing_effect")


func play_break_chain_anim() -> void:
	animated_sprite.show()
	anim_player.play("break_chain_effect")


func play_used_arrogance_anim() -> void:
	animated_sprite.show()
	anim_player.play("arrogance_effect")


func play_used_attack_up_anim() -> void:
	animated_sprite.show()
	anim_player.play("attack_up_effect")


func play_parried_anim() -> void:
	animated_sprite.show()
	anim_player.play("parried_effect")


func play_enchanted_anim() -> void:
	animated_sprite.show()
	anim_player.play("enchanted_effect")


func play_healed_anim(heal_frames: SpriteFrames) -> void:
	animated_sprite.frames = heal_frames
	animated_sprite.animation = "boil"
	animated_sprite.playing = true
	animated_sprite.show()
	anim_player.play("heal_effect")


func _anim_player_animation_finished(_anim_name: String) -> void:
	queue_free()
