extends Node

class_name GameState

export(int) var state_index;

export(NodePath) var camera_path;
onready var camera = get_node(camera_path)

onready var manager = get_parent()

func start():
	printerr("Unimplemented start in GameState")
	
func stop():
	printerr("Unimplemented start in GameState")

func finish():
	printerr("Unimplemented finish in GameState")
	
func get_camera():
	return camera
