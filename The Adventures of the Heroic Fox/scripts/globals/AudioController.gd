extends Node

const ABILITY_SOUND: String = "ability"
const CLICK_SOUND: String = "click"
const DEFEND_SOUND: String = "defend"
const HIT_SOUND: String = "hit"
const HOVER_SOUND: String = "hover"
const STRONG_HIT_SOUND: String = "strong_hit"
const WHIMPER_SOUND: String = "whimper"
const BUBBLE_HOVER_SOUND: String = "bubble_hover"
const BUBBLE_CLICK_SOUND: String = "bubble_click"
const TEXTBOX_CLICK_SOUND: String = "textbox_click"
const POOF_SOUND: String = "poof"

const MENU_MUSIC: AudioStreamMP3 = preload("res://assets/audio/TavernStyleMusic.mp3")
const BATTLE_MUSIC: AudioStreamMP3 = preload("res://assets/audio/TavernSuspenceMusic.mp3")
const SFX: Dictionary = {
	ABILITY_SOUND: preload("res://assets/audio/ability.wav"),
	CLICK_SOUND: preload("res://assets/audio/click.ogg"),
	DEFEND_SOUND: preload("res://assets/audio/defend.wav"),
	HIT_SOUND: preload("res://assets/audio/attack.ogg"),
	HOVER_SOUND: preload("res://assets/audio/hover.ogg"),
	STRONG_HIT_SOUND: preload("res://assets/audio/strong hit.mp3"),
	WHIMPER_SOUND: preload("res://assets/audio/whimper.ogg"),
	BUBBLE_HOVER_SOUND: preload("res://assets/audio/bubble_hover.ogg"),
	BUBBLE_CLICK_SOUND: preload("res://assets/audio/bubble_click.ogg"),
	TEXTBOX_CLICK_SOUND: preload("res://assets/audio/textbox_click.ogg"),
	POOF_SOUND: preload("res://assets/audio/poof.ogg"),
}

const VOLUME_FIXER: Dictionary = {
	ABILITY_SOUND: 0,
	CLICK_SOUND: 0.0,
	DEFEND_SOUND: 0,
	HIT_SOUND: 0,
	HOVER_SOUND: -10.0,
	STRONG_HIT_SOUND: 0,
	WHIMPER_SOUND: 2.0,
	BUBBLE_HOVER_SOUND: -2.0,
	BUBBLE_CLICK_SOUND: 0.0,
	TEXTBOX_CLICK_SOUND: -2.0,
	POOF_SOUND: 10.0,
}

const PITCH_RANDOMIZER: Dictionary = {
	ABILITY_SOUND: [1, 1],
	CLICK_SOUND: [0.8, 1.2],
	DEFEND_SOUND: [1, 1],
	HIT_SOUND: [1, 1],
	HOVER_SOUND: [0.8, 1.2],
	STRONG_HIT_SOUND: [1, 1],
	WHIMPER_SOUND: [1.1, 1.4],
	BUBBLE_HOVER_SOUND: [0.6, 1.4],
	BUBBLE_CLICK_SOUND: [0.6, 1.4],
	TEXTBOX_CLICK_SOUND: [0.5, 1.5],
	POOF_SOUND: [0.6, 1.4],
}

const MUTE_VOLUME: float = -1000.0

var music_volume: float = -20.0
var sfx_volume: float = -20.0

onready var music_player: AudioStreamPlayer = $MusicPlayer
onready var player_sfx_player: AudioStreamPlayer = $PlayerSfxPlayer
onready var enemy_sfx_player: AudioStreamPlayer = $EnemySfxPlayer
onready var ui_player: AudioStreamPlayer = $UiPlayer


func _ready() -> void:
	randomize()


func play_ui_sound(ui_sfx: String) -> void:
	_play_sound(ui_player, ui_sfx)


func play_player_sfx(sfx: String) -> void:
	_play_sound(player_sfx_player, sfx)


func play_enemy_sfx(sfx: String) -> void:
	_play_sound(enemy_sfx_player, sfx)


func play_music(music: AudioStreamMP3) -> void:
	music_player.volume_db = music_volume
	music_player.stream = music
	music_player.play()


func set_volume() -> void:
	music_player.volume_db = music_volume


func _play_sound(player: AudioStreamPlayer, sfx: String) -> void:
	player.pitch_scale = \
		rand_range(PITCH_RANDOMIZER[sfx][0], PITCH_RANDOMIZER[sfx][1])
	player.volume_db = sfx_volume + VOLUME_FIXER[sfx]
	player.stream = SFX[sfx]
	player.play()
