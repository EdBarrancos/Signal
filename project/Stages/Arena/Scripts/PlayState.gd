extends GameState

export(int) var number_of_notes = 5

onready var spawner = $"../../Spawner"

onready var temp_position = $Position2D

var current_patch;

func _ready():
	pass

func init(_parent):
	pass

func start():
	spawner.spawn_patch().connect("eaten", self, "on_patch_eaten")
	for _i in range(number_of_notes):
		var note = spawner.spawn_note_in_random_position()
		note.connect("died", self, "on_note_destroyed")
		note.connect("caught", self, "on_note_destroyed")

func on_patch_eaten():
	spawner.spawn_patch().connect("eaten", self, "on_patch_eaten")

func on_note_destroyed():
	var note = spawner.spawn_note_in_random_position()
	note.connect("died", self, "on_note_destroyed")
	note.connect("caught", self, "on_note_destroyed")

func stop():
	pass

func finish():
	print("finish")
