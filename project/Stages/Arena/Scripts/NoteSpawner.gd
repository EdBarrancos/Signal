extends Node2D
class_name NoteSpawner

onready var notes_container = $"../Notes" ;
export(Resource) var note;


func spawn_note(note_position):
	var new_note = note.instance()
	notes_container.add_child(new_note)
	new_note.position = note_position
	return new_note

