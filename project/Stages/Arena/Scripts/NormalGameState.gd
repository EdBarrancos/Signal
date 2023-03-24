extends GameState

onready var camera_transition = $CameraTransiction

func _ready():
	pass

func init(parent):
	pass

func start():
	camera_transition.init_transition(6)
	print("start")

func finish():
	print("finish")
