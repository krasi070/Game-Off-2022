# This class is largely taken from Jon Topielski's code for
# Cursor Tutorial: https://github.com/jontopielski/cursor-tutorial/blob/main/src/CursorManager.gd

extends CanvasLayer

export(Texture) var default_cursor
export(Texture) var examine_cursor
export(Texture) var select_cursor

export(Vector2) var base_window_size
export(Vector2) var base_cursor_size

export(bool) var is_browser_version

var curr_texture: Texture
var curr_cursor_type: int

onready var sprite: Sprite = $Sprite

func _ready() -> void:
	if is_browser_version:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		sprite.hide()
	curr_texture = default_cursor
	update_cursor()
	get_tree().connect("screen_resized", self, "_screen_resized")


func _process(_delta: float) -> void:
	sprite.global_position = sprite.get_global_mouse_position()


func set_cursor(type: int) -> void:
	match type:
		Enums.CURSOR_TYPE.DEFAULT:
			curr_texture = default_cursor
		Enums.CURSOR_TYPE.EXAMINE:
			curr_texture = examine_cursor
		Enums.CURSOR_TYPE.SELECT:
			curr_texture = select_cursor
	curr_cursor_type = type
	update_cursor()


func update_cursor() -> void:
	var current_window_size: Vector2 = OS.window_size
	var scale_multiple: float = min(
		current_window_size.x / base_window_size.x, 
		current_window_size.y / base_window_size.y)
	var texture: ImageTexture = ImageTexture.new()
	var image: Image = curr_texture.get_data()

	image.resize(
		base_cursor_size.x * scale_multiple, 
		base_cursor_size.y * scale_multiple, 
		Image.INTERPOLATE_BILINEAR)
	texture.create_from_image(image)
	if is_browser_version:
		sprite.texture = curr_texture
	else:
		Input.set_custom_mouse_cursor(texture, Input.CURSOR_ARROW)


func _screen_resized() -> void:
	update_cursor()
