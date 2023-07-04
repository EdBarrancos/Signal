extends GameState

# In this state. One enemy + Player 
# Every time the player kills the enemy it spawns again
# Move on when enemy captured

onready var enemy_position = $Position2D;
onready var note_spawner = $"../../Spawner";
onready var new_tutorial = $Tutorial2
onready var state_camera = $Camera
onready var tilemap = $TileMap

onready var murderer = false

func _ready():
	pass

func init(_parent):
	pass

func start():
	set_process(true)
	spawn_note()
	state_camera.show()
	state_camera.current = true
	tilemap.show()
	new_tutorial.show()

func stop():
	set_process(false)
	state_camera.hide()
	tilemap.hide()
	new_tutorial.hide()

func spawn_note():
	var note = note_spawner.spawn_note(enemy_position.position)
	note.connect("died", self, "on_note_died")
	note.connect("tree_exited", self, "on_note_killed")
	note.connect("caught", self, "on_note_caught")

func on_note_died():
	murderer = true

func on_note_killed():
	if murderer:
		spawn_note()
		murderer = false

func on_note_caught():
	manager.finish_state(state_index)
	
func finish():
	set_process(false)
	tilemap.hide()
	new_tutorial.hide()

