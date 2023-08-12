extends Node2D

onready var background: Sprite = $Background

func _ready() -> void:
	AudioController.play_music(AudioController.MENU_MUSIC)
	Mouse.move_with_mouse = background
	Mouse.connect("left_clicked", self, "_mouse_left_clicked")


func _mouse_left_clicked() -> void:
	Transition.transition_to_scene("res://scenes/ui/MainMenu.tscn", false)
