extends Node2D

const OFFSET: Vector2 = Vector2(41, 41)

var choices: Dictionary = {}

onready var message_label: Label = $Label
onready var decision_container: HBoxContainer = $DecisionContainer
onready var or_label: Label = $OrLabel
onready var left_container: Control = $DecisionContainer/LeftItemContainer
onready var right_container: Control = $DecisionContainer/RightItemContainer

onready var action_scene: PackedScene = preload("res://scenes/ActionBlock.tscn")
onready var passive_scene: PackedScene = preload("res://scenes/PassiveEffect.tscn")

onready var fsm: FSM = FSM.new(self, $States, $States/Story, true)

func _ready() -> void:
	AudioController.play_music(AudioController.MENU_MUSIC)


func _physics_process(delta: float) -> void:
	fsm.run_machine(delta)


func show_message_in_bubble(msg: String) -> void:
	decision_container.hide()
	or_label.hide()
	message_label.text = msg
	message_label.show()


func show_choices(choice_data: Resource) -> void:
	message_label.hide()
	_set_choice(choice_data)
	decision_container.show()
	or_label.show()


func remove_choices() -> void:
	for key in choices.keys():
		choices[key].queue_free()


func _set_choice(choice_data: Resource) -> void:
	if choice_data.type == Enums.CHOICE_TYPE.ACTION:
		_set_action_choice(choice_data.first_choice, left_container, 0)
		_set_action_choice(choice_data.second_choice, right_container, 1)
		PlayerStats.action_slots += 1
		EnemyStats.action_slots += 1
	else:
		_set_passive_choice(choice_data.first_choice, left_container, 0)
		_set_passive_choice(choice_data.second_choice, right_container, 1)


func _set_action_choice(action_data: Resource, container: Control, index: int) -> void:
	var instance: Node2D = action_scene.instance()
	instance.data = action_data
	instance.set_meta("id", str(index))
	container.add_child(instance)
	instance.position = OFFSET
	instance.is_in_intermission = true
	instance.set_sprite_data()
	choices[index] = instance


func _set_passive_choice(passive_data: Resource, container: Control, index: int) -> void:
	var instance: Node2D = passive_scene.instance()
	instance.data = passive_data
	instance.set_meta("p_id", str(index))
	container.add_child(instance)
	instance.position = OFFSET
	instance.is_in_intermission = true
	instance.set_visual_data()
	choices[index] = instance
