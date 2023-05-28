extends Node

signal all_states_finished

export(int) var starting_state_index = 0
export(Array, NodePath) var states_paths
var states

var current_state : GameState

func _ready():
	states = []
	for state_path in states_paths:
		states.push_back(get_node(state_path))

func init():
	jump_start_state(starting_state_index)
	
func jump_start_state(state_index : int):
	start_state(state_index)

func start_next_state(state_index):
	if state_index + 1 >= len(states):
		emit_signal("all_states_finished")
		start_state(0)
		return
	start_state(state_index + 1)
	

func finish_state(state_index):
	states[state_index].finish()
	start_next_state(state_index)

func start_state(state_index):
	current_state = states[state_index]
	current_state.set_process(true)
	current_state.start()
	
func get_camera():
	return current_state.get_camera()
