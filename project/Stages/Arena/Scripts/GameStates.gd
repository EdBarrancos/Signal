extends Node

export(int) var starting_state_index = 0
onready var states = []

var current_state
var current_index

func _ready():
	for state in self.get_children():
		states.append(state)

func init():
	start_state(starting_state_index)

#func _process(delta):
#   pass

func finish_state(state_index):
	current_state.finish()

func start_next_state(state_index):
	finish_state(state_index)
	current_state.connect("finished", self, "on_state_finished")
	

func on_state_finished():
	if current_index + 1 >= len(states):
		print("No new state")
		return
	start_state(current_index + 1)

func start_state(state_index):
	current_state = states[state_index]
	current_index = state_index
	current_state.start()
