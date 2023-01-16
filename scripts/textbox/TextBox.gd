# This class is largely taken from Jon Topielski's code for
# Into the Deep Web: https://github.com/jontopielski/into-the-deep-web-jam

extends CanvasLayer

# It is used, just in another script
# warning-ignore:unused_signal
signal finished

const CHAR_READ_RATE: float = 0.015

export(Texture) var tutorial_hero_actions_texture 
export(Texture) var tutorial_enemy_actions_texture
export(Texture) var tutorial_ego_texture
export(Texture) var tutorial_passives_texture
export(Texture) var tutorial_end_turn_texture
export(Texture) var tutorial_enemy_passives_texture

var tween: SceneTreeTween
var entry_queue: Array = []

var is_active: bool = true

var portrait_by_name: Dictionary = {
	"CENTIWORM": load("res://assets/resources/sprite_frames/character_portraits/CentipedePortraitSpriteFrames.tres"),
	"SCRATCHY THE PIRATE": load("res://assets/resources/sprite_frames/character_portraits/PiratePortraitSpriteFrames.tres"),
	"ABANDONED HOUSEPLANT": load("res://assets/resources/sprite_frames/character_portraits/FlowerPortraitSpriteFrames.tres"),
	"GOLEM": load("res://assets/resources/sprite_frames/character_portraits/GolemPortraitSpriteFrames.tres"),
	"HERO": load("res://assets/resources/sprite_frames/character_portraits/HeroPortraitSpriteFrames.tres"),
	"TRANSCENDED LIZARD": load("res://assets/resources/sprite_frames/character_portraits/LizardPortraitSpriteFrames.tres"),
	"MONSTER": load("res://assets/resources/sprite_frames/character_portraits/MonsterPortraitSpriteFrames.tres"),
	"SQUIRE": load("res://assets/resources/sprite_frames/character_portraits/SquirePortraitSpriteFrames.tres"),
	"WEECH": load("res://assets/resources/sprite_frames/character_portraits/WitchPortraitSpriteFrames.tres"),
	"PRINCESS": load("res://assets/resources/sprite_frames/character_portraits/PrincessPortraitSpriteFrames.tres"),
}

onready var textbox: Control = $TextBox
onready var background: TextureRect = $Background
onready var name_label: Label = \
	$TextBox/Margin/NinePatchRect/Margin/HBox/HBox/VBox/CharacterName
onready var body: RichTextLabel = \
	$TextBox/Margin/NinePatchRect/Margin/HBox/HBox/VBox/Text
onready var portrait: AnimatedSprite = \
	$TextBox/Margin/NinePatchRect/Margin/HBox/Control/AnimatedPortrait
onready var ticker: TextureRect = \
	$TextBox/Margin/NinePatchRect/Margin/HBox/HBox/TickerBox/Ticker

onready var fsm: FSM = FSM.new(self, $States, $States/Preparation, true)

func _physics_process(delta: float) -> void:
	fsm.run_machine(delta)


func queue_entry(entry: Dictionary) -> void:
	entry_queue.append(entry)


func queue_entries(entries: Array) -> void:
	for entry in entries:
		queue_entry(entry)


func set_name(char_name: String) -> void:
	name_label.text = char_name.to_upper()


func set_portrait(portrait_frames: SpriteFrames) -> void:
	portrait.frames = portrait_frames


func set_portrait_by_name() -> void:
	set_portrait(portrait_by_name[name_label.text])


func set_tutorial_background(type: int = -1) -> void:
	background.show()
	match type:
		Enums.TUTORIAL.HERO_ACTIONS:
			 background.texture = tutorial_hero_actions_texture
		Enums.TUTORIAL.ENEMY_ACTIONS:
			background.texture = tutorial_enemy_actions_texture
		Enums.TUTORIAL.EGO:
			background.texture = tutorial_ego_texture
		Enums.TUTORIAL.PASSIVES:
			background.texture = tutorial_passives_texture
		Enums.TUTORIAL.END_TURN:
			background.texture = tutorial_end_turn_texture
		Enums.TUTORIAL.ENEMY_PASSIVES:
			background.texture = tutorial_enemy_passives_texture
		_:
			background.hide()


func reset() -> void:
	hide()
	ticker.hide()
	background.hide()
	body.text = ""
