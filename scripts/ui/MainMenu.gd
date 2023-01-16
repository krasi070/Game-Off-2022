extends Node2D

var is_hovering_on_button: Dictionary = {
	"StartJourneyButton": false,
	"OptionsButton": false,
	"QuitButton": false,
}

onready var background: Sprite = $Background
onready var button_container: Control = $ButtonContainer
onready var start_journey_button: TextureButton = $ButtonContainer/StartJourneyButton
onready var options_button: TextureButton = $ButtonContainer/OptionsButton
onready var quit_button: TextureButton = $ButtonContainer/QuitButton

func _ready() -> void:
	Mouse.move_with_mouse = background
	OptionsLayer.can_pause = false
	start_journey_button.connect("pressed", self, "_start_journey_button_pressed")
	start_journey_button.connect("mouse_entered", self, "_button_mouse_entered", [start_journey_button.name])
	start_journey_button.connect("mouse_exited", self, "_button_mouse_exited", [start_journey_button.name])
	options_button.connect("mouse_entered", self, "_button_mouse_entered", [options_button.name])
	options_button.connect("mouse_exited", self, "_button_mouse_exited", [options_button.name])
	options_button.connect("pressed", self, "_options_button_pressed")
	quit_button.connect("mouse_entered", self, "_button_mouse_entered", [quit_button.name])
	quit_button.connect("mouse_exited", self, "_button_mouse_exited", [quit_button.name])
	quit_button.connect("pressed", self, "_quit_button_pressed")
	TextBox.connect("finished", self, "_textbox_finished")
	AudioController.play_music(AudioController.MENU_MUSIC)


func _physics_process(_delta: float) -> void:
	var is_hovering: bool = is_hovering_on_button.values().has(true)
	if is_hovering and \
		CursorManager.curr_cursor_type != Enums.CURSOR_TYPE.SELECT:
		CursorManager.set_cursor(Enums.CURSOR_TYPE.SELECT)
	if not is_hovering and \
		CursorManager.curr_cursor_type != Enums.CURSOR_TYPE.DEFAULT:
		CursorManager.set_cursor(Enums.CURSOR_TYPE.DEFAULT)


func _set_hovering_to_false() -> void:
	for key in is_hovering_on_button.keys():
		is_hovering_on_button[key] = false


func _start_journey_button_pressed() -> void:
	button_container.hide()
	AudioController.play_ui_sound(AudioController.BUBBLE_CLICK_SOUND)
	_set_hovering_to_false()
	TextBox.queue_entry({ "name": "Squire", "body": "We're on our way to our first castle..." })
	TextBox.queue_entry({ "name": "Squire", "body": "I was ecstatic that the village hero invited me on his next adventure." })
	TextBox.queue_entry({ "name": "Squire", "body": "The princess has gone missing and there's a reward for whoever finds her." })
	TextBox.queue_entry({ "name": "Squire", "body": "The hero's plans aren't always the best and he can get upset quite fast..." })
	TextBox.queue_entry({ "name": "Squire", "body": "But I'm sure that with just a little help from me he can finally prove to everyone what a hero he truly is!" })


func _button_mouse_entered(_name: String) -> void:
	if not is_hovering_on_button[_name]:
		AudioController.play_ui_sound(AudioController.BUBBLE_HOVER_SOUND)
		print("Mouse enter sound: ", _name)
	is_hovering_on_button[_name] = true


func _button_mouse_exited(_name: String) -> void:
	print("Mouse exited sound: ", _name)
	is_hovering_on_button[_name] = false


func _options_button_pressed() -> void:
	AudioController.play_ui_sound(AudioController.BUBBLE_CLICK_SOUND)
	OptionsLayer.show_settings()
	OptionsLayer.show()
	get_tree().paused = true


func _quit_button_pressed() -> void:
	AudioController.play_ui_sound(AudioController.BUBBLE_CLICK_SOUND)
	get_tree().quit()


func _textbox_finished() -> void:
	Transition.transition_to_scene("res://scenes/Battle.tscn")
