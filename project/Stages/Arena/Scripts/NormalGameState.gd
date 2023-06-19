extends GameState

onready var camera_transition = $CameraTransiction
onready var spawner = $"../../Spawner"

onready var temp_position = $Position2D

onready var score_lives_label = $CanvasLayer

onready var spawn_interval_timer = $SpawnInterval

export(int) var max_number_of_notes = 15;
export(int) var starting_number_of_notes = 3;
export(float) var spawning_interval = 5.0;
export(float) var interval_increase = 0.8;
var current_notes

func _ready():
	pass

func init(_parent):
	pass

func start():
	camera_transition.init_transition(2)

func stop():
	score_lives_label.hide()

func finish():
	spawner.clean_notes()
	spawner.clean_patch()
	score_lives_label.hide()

func on_patch_eaten():
	spawner.spawn_patch().connect("eaten", self, "on_patch_eaten")

func on_note_destroyed():
	var note = spawner.spawn_note_in_random_position()
	note.connect("died", self, "on_note_killed")
	note.connect("caught", self, "on_note_caught")
	
func on_note_caught():
	on_note_destroyed()
	score_lives_label.add_score(1)
	
func on_note_killed():
	on_note_destroyed()
	score_lives_label.decrement_lives()
	if score_lives_label.lives <= 0:
		get_parent().finish_state(state_index)

func _on_CameraTransiction_finished():
	score_lives_label.show()
	score_lives_label.set_score(0)
	score_lives_label.reset_lives()
	spawner.spawn_patch().connect("eaten", self, "on_patch_eaten")
	for _i in range(starting_number_of_notes):
		var note = spawner.spawn_note_in_random_position()
		note.connect("died", self, "on_note_killed")
		note.connect("caught", self, "on_note_caught")
	current_notes = starting_number_of_notes
	spawn_interval_timer.set_wait_time(spawning_interval)
	spawn_interval_timer.start()

func _on_SpawnInterval_timeout():
	if current_notes >= max_number_of_notes:
		return
	
	var note = spawner.spawn_note_in_random_position()
	note.connect("died", self, "on_note_killed")
	note.connect("caught", self, "on_note_caught")
	current_notes += 1
	spawning_interval += interval_increase
	spawn_interval_timer.set_wait_time(spawning_interval)
	spawn_interval_timer.start()
	
	
