extends Node2D
class_name NoteSpawner

onready var notes_container = $"../Notes" ;

export(Resource) var note;
export(Resource) var patch;

export(NodePath) var center_arena_path;
onready var center_arena = get_node(center_arena_path);
export(int) var width;
export(int) var height;

onready var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func spawn_note(note_position):
	var new_note = note.instance()
	notes_container.add_child(new_note)
	new_note.position = note_position
	return new_note

func spawn_patch():
	var new_path = patch.instance()
	add_child(new_path)
	new_path.position = random_position(new_path.radius)
	return new_path
	
func random_position(offset):
	var x = rng.randi_range(-width/2 + offset/2, width/2 - offset/2)
	var y = rng.randi_range(-height/2 + offset/2, height/2 - offset/2)
	return Vector2(x, y) + center_arena.global_position
