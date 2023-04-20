extends GameState

onready var camera_transition = $CameraTransiction
onready var spawner = $"../../Spawner"

onready var temp_position = $Position2D

var current_patch;

func _ready():
	pass

func init(parent):
	pass

func start():
	camera_transition.init_transition(6)
	
	print("start")

func stop():
	pass

func finish():
	print("finish")


func _on_CameraTransiction_finished():
	spawner.spawn_patch()
	spawner.spawn_note(temp_position.position)
