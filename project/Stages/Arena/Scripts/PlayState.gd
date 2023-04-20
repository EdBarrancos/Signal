extends GameState

onready var spawner = $"../../Spawner"

onready var temp_position = $Position2D

var current_patch;

func _ready():
	pass

func init(parent):
	pass

func start():
	spawner.spawn_patch().connect("eaten", self, "on_patch_eaten")
	spawner.spawn_note_in_random_position()
	spawner.spawn_note_in_random_position()
	spawner.spawn_note_in_random_position()
	spawner.spawn_note_in_random_position()
	spawner.spawn_note_in_random_position()
	spawner.spawn_note_in_random_position()
	spawner.spawn_note_in_random_position()
	spawner.spawn_note_in_random_position()
	spawner.spawn_note_in_random_position()

func on_patch_eaten():
		spawner.spawn_patch().connect("eaten", self, "on_patch_eaten")

func stop():
	pass

func finish():
	print("finish")
