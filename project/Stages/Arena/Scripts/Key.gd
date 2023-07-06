extends Sprite

export var input_expected : String

export var arrow_keyboard_texture : Texture
export var awsd_keyboard_texture : Texture

onready var sprite = self

func _ready():
	KeyBindings.connect("input_changed", self, "input_changed")

func init(_parent):
	pass

func _process(_delta):
	if (Input.is_action_pressed(input_expected)):
		self.frame = 1
	else:
		self.frame = 0

func input_changed():
	if KeyBindings.is_playing_with_keyboard():
		if KeyBindings.is_using_arrows_right():
			sprite.texture = arrow_keyboard_texture
		else:
			sprite.texture = awsd_keyboard_texture
