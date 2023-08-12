extends Node

signal changed_speed()

var speed: float = 5

func set_speed(_speed: float) -> void:
	speed = _speed
	emit_signal("changed_speed")
