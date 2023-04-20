extends GameState

onready var spawner = $"../../Spawner"

onready var temp_position = $Position2D

var current_patch;

func _ready():
	pass

func init(parent):
	pass

func start():
	spawner.spawn_patch()
	spawner.spawn_note(temp_position.position)

func stop():
	pass

func finish():
	print("finish")
