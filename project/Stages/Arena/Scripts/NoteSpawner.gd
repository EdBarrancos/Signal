extends Node2D
class_name NoteSpawner

onready var notes_container = $"../Notes" ;
onready var grass_container = $"../GrassContainer";

export(Resource) var note;
export(Resource) var patch;

export(NodePath) var center_arena_path;
onready var center_arena = get_node(center_arena_path);
export(int) var width;
export(int) var height;
export(int) var offset;

onready var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func spawn_note(note_position):
	var new_note = note.instance()
	notes_container.call_deferred("add_child", new_note)
	new_note.position = note_position
	return new_note

func spawn_note_in_random_position():
	var new_note = note.instance()
	notes_container.call_deferred("add_child", new_note)
	new_note.position = random_position(offset)
	return new_note

func spawn_patch():
	var new_path = patch.instance()
	grass_container.add_child(new_path)
	new_path.position = random_position(new_path.radius + offset)
	return new_path
	
func clean_notes():
	for child in notes_container.get_children():
		child.queue_free()
	
func clean_patch():
	for child in grass_container.get_children():
		child.queue_free()
	
func random_position(offset):
	var x = rng.randi_range(-width/2 + offset/2, width/2 - offset/2)
	var y = rng.randi_range(-height/2 + offset/2, height/2 - offset/2)
	return Vector2(x, y) + center_arena.global_position
