extends GameState

onready var camera_transition = $CameraTransiction
onready var spawner = $"../../Spawner"

var current_patch;

func _ready():
	pass

func init(parent):
	pass

func start():
	camera_transition.init_transition(6)
	
	print("start")

func finish():
	print("finish")


func _on_CameraTransiction_finished():
	spawner.spawn_patch()
