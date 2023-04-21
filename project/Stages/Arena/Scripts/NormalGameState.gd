extends GameState

onready var camera_transition = $CameraTransiction
onready var spawner = $"../../Spawner"

onready var temp_position = $Position2D

onready var score_lives_label = $CanvasLayer

export(int) var number_of_notes = 10;

func _ready():
	pass

func init(parent):
	pass

func start():
	camera_transition.init_transition(6)

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
	for _i in range(number_of_notes):
		var note = spawner.spawn_note_in_random_position()
		note.connect("died", self, "on_note_killed")
		note.connect("caught", self, "on_note_caught")
