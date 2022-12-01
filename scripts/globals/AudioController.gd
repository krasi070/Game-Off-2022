extends Node

const ABILITY_SOUND: String = "ability"
const CLICK_SOUND: String = "click"
const DEFEND_SOUND: String = "defend"
const HIT_SOUND: String = "hit"
const HOVER_SOUND: String = "hover"
const STRONG_HIT_SOUND: String = "strong_hit"


const MENU_MUSIC: AudioStreamMP3 = preload("res://assets/audio/TavernStyleMusic.mp3")
const BATTLE_MUSIC: AudioStreamMP3 = preload("res://assets/audio/TavernSuspenceMusic.mp3")
const SFX: Dictionary = {
	ABILITY_SOUND: preload("res://assets/audio/ability.wav"),
	CLICK_SOUND: preload("res://assets/audio/click.mp3"),
	DEFEND_SOUND: preload("res://assets/audio/defend.wav"),
	HIT_SOUND: preload("res://assets/audio/hit.wav"),
	HOVER_SOUND: preload("res://assets/audio/hover.wav"),
	STRONG_HIT_SOUND: preload("res://assets/audio/strong hit.mp3"),
}

const VOLUME_FIXER: Dictionary = {
	ABILITY_SOUND: 0,
	CLICK_SOUND: 0,
	DEFEND_SOUND: 0,
	HIT_SOUND: 0,
	HOVER_SOUND: 0,
	STRONG_HIT_SOUND: 0,
}

var music_volume: float = -20.0
var sfx_volume: float = -20.0
const MUTE_VOLUME: float = -1000.0

onready var music_player: AudioStreamPlayer = $MusicPlayer
onready var player_sfx_player: AudioStreamPlayer = $PlayerSfxPlayer
onready var enemy_sfx_player: AudioStreamPlayer = $EnemySfxPlayer
onready var ui_player: AudioStreamPlayer = $UiPlayer


func _ready() -> void:
	#play_music()
	pass


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
	player.volume_db = sfx_volume + VOLUME_FIXER[sfx]
	player.stream = SFX[sfx]
	player.play()
