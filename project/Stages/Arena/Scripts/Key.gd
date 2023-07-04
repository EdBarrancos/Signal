extends Sprite

export var input_expected : String

export var arrow_keyboard_texture : Texture
export var awsd_keyboard_texture : Texture

func _ready():
	pass

func init(parent):
	pass

func _process(delta):
	if (Input.is_action_pressed(input_expected)):
		self.frame = 1
	else:
		self.frame = 0
