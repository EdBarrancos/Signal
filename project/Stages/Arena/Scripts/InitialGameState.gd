extends GameState

# In this state. One enemy + Player 
# Every time the player kills the enemy it spawns again
# Move on when enemy captured

onready var enemy_position = $Position2D;
onready var note_spawner = $"../../Spawner";
onready var tutorial = $Tutorial
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
	tutorial.start()
	state_camera.show()
	state_camera.current = true
	tilemap.show()
	new_tutorial.show()

func stop():
	set_process(false)
	tutorial.hide()
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
		tutorial.set_kill_tip(true)
		tutorial.set_capture_tip(true)
		murderer = false

func on_note_caught():
	manager.finish_state(state_index)
	
func finish():
	set_process(false)
	tutorial.hide()
	tilemap.hide()
	new_tutorial.hide()
	
func _process(_delta):
	if Input.is_action_just_pressed("LEFT"):
		tutorial.set_left(false)
	elif Input.is_action_just_pressed("RIGHT"):
		tutorial.set_right(false)
	elif Input.is_action_just_pressed("CHORD"):
		tutorial.set_pin(false)
	elif Input.is_action_just_pressed("BOOST"):
		tutorial.set_boost(false)

