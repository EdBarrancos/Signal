extends Node

# In this state. One enemy + Player 
# Every time the player kills the enemy it spawns again
# Move on when enemy captured

onready var manager = get_parent()

onready var enemy_position = $Position2D;
onready var note_spawner = $"../../NoteSpawner";

func _ready():
	pass

func init(parent):
	pass

func start():
	spawn_note()

func finish():
	pass

func spawn_note():
	var note = note_spawner.spawn_note(enemy_position.position)
	note.connect("tree_exited", self, "on_note_killed")
	note.connect("caught", self, "on_note_caught")

func on_note_killed():
	spawn_note()

func on_note_caught():
	print("caught")

