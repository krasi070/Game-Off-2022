extends CanvasLayer

signal retried()

const MIN_VOLUME: int = 0
const MAX_VOLUME: int = 10
const DEFAULT_VOLUME: int = 5

const SPEED_VALUE_FORMAT: String = "%1.1fx"
const SOUND_VALUE_FORMAT: String = "%d"

var can_pause: bool = false

onready var label: Label = $Screen/Margin/Background/Margin/VBoxContainer/Label
onready var resume_btn: TextureButton = $Screen/ResumeButton
onready var retry_btn: TextureButton = $Screen/RetryButton
onready var main_menu_btn: TextureButton = $Screen/MainMenuButton
onready var master_vol_slider: Control = $Screen/Margin/Background/Margin/VBoxContainer/MasterSlider
onready var music_vol_slider: Control = $Screen/Margin/Background/Margin/VBoxContainer/MusicSlider
onready var sfx_vol_slider: Control = $Screen/Margin/Background/Margin/VBoxContainer/SfxSlider
onready var speed_slider: Control = $Screen/Margin/Background/Margin/VBoxContainer/SpeedSlider

func _ready() -> void:
	hide()
	_setup_speed_slider()
	_setup_master_vol_slider()
	_setup_music_vol_slider()
	_setup_sfx_vol_slider()
	_connect_buttons()


func show_pause() -> void:
	label.text = "paused"
	resume_btn.show()
	retry_btn.hide()
	main_menu_btn.show()


func show_settings() -> void:
	label.text = "settings"
	resume_btn.show()
	retry_btn.hide()
	main_menu_btn.hide()


func show_game_over() -> void:
	label.text = "game over"
	resume_btn.hide()
	retry_btn.show()
	main_menu_btn.show()


func _connect_buttons() -> void:
	resume_btn.connect("pressed", self, "_resume_btn_pressed")
	retry_btn.connect("pressed", self, "_retry_btn_pressed")
	main_menu_btn.connect("pressed", self, "_main_menu_btn_pressed")


func _setup_speed_slider() -> void:
	speed_slider.set_max(5)
	speed_slider.set_min(1)
	speed_slider.set_step(0.5)
	speed_slider.set_value(SpeedManager.speed)
	speed_slider.set_label("battle speed")
	speed_slider.set_value_label(SPEED_VALUE_FORMAT % SpeedManager.speed)
	speed_slider.get_slider().connect(
		"value_changed", 
		self, 
		"_speed_slider_value_changed")


func _setup_master_vol_slider() -> void:
	master_vol_slider.set_max(MAX_VOLUME)
	master_vol_slider.set_min(MIN_VOLUME)
	master_vol_slider.set_step(1)
	master_vol_slider.set_value(DEFAULT_VOLUME)
	master_vol_slider.set_label("master vol")
	master_vol_slider.set_value_label(SOUND_VALUE_FORMAT % 5)
	master_vol_slider.get_slider().connect(
		"value_changed", 
		self, 
		"_master_vol_slider_value_changed")


func _setup_music_vol_slider() -> void:
	music_vol_slider.set_max(MAX_VOLUME)
	music_vol_slider.set_min(MIN_VOLUME)
	music_vol_slider.set_step(1)
	music_vol_slider.set_value(DEFAULT_VOLUME)
	music_vol_slider.set_label("music vol")
	music_vol_slider.set_value_label(SOUND_VALUE_FORMAT % 5)
	music_vol_slider.get_slider().connect(
		"value_changed", 
		self, 
		"_music_vol_slider_value_changed")


func _setup_sfx_vol_slider() -> void:
	sfx_vol_slider.set_max(MAX_VOLUME)
	sfx_vol_slider.set_min(MIN_VOLUME)
	sfx_vol_slider.set_step(1)
	sfx_vol_slider.set_value(DEFAULT_VOLUME)
	sfx_vol_slider.set_label("sfx vol")
	sfx_vol_slider.set_value_label(SOUND_VALUE_FORMAT % 5)
	sfx_vol_slider.get_slider().connect(
		"value_changed", 
		self, 
		"_sfx_vol_slider_value_changed")


func _resume_btn_pressed() -> void:
	hide()
	get_tree().paused = OptionsLayer.visible


func _main_menu_btn_pressed() -> void:
	hide()
	get_tree().paused = OptionsLayer.visible
	TextBox.entry_queue = []
	TextBox.reset()
	TextBox.fsm.state_next = TextBox.fsm.states.Preparation
	Transition.transition_to_scene("res://scenes/ui/MainMenu.tscn", false)


func _retry_btn_pressed() -> void:
	hide()
	get_tree().paused = OptionsLayer.visible
	emit_signal("retried")


func _sfx_vol_slider_value_changed(value: float) -> void:
	AudioController.sfx_volume = (value - MAX_VOLUME) * 4
	if value == MIN_VOLUME:
		AudioController.sfx_volume = AudioController.MUTE_VOLUME
	sfx_vol_slider.set_value_label(SOUND_VALUE_FORMAT % value)


func _music_vol_slider_value_changed(value: float) -> void:
	AudioController.music_volume = (value - MAX_VOLUME) * 4
	if value == MIN_VOLUME:
		AudioController.music_volume = AudioController.MUTE_VOLUME
	AudioController.set_volume()
	music_vol_slider.set_value_label(SOUND_VALUE_FORMAT % value)


func _master_vol_slider_value_changed(value: float) -> void:
	music_vol_slider.set_value(value)
	sfx_vol_slider.set_value(value)
	master_vol_slider.set_value_label(SOUND_VALUE_FORMAT % value)


func _speed_slider_value_changed(value: float) -> void:
	SpeedManager.set_speed(value)
	speed_slider.set_value_label(SPEED_VALUE_FORMAT % SpeedManager.speed)
