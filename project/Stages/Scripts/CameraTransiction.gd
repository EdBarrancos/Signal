extends Node2D

class_name CameraTransition

export(NodePath) var default_current_camera
export(NodePath) var default_target_camera
export(Array, String) var default_property_list = [
	"rotation",
	"scale",
	"position",
	"offset",
	"zoom"
]
export(int, 0, 3) var default_ease_out = Tween.EASE_IN_OUT
export(int, 0, 10) var default_transition_type = Tween.TRANS_LINEAR

onready var current_camera = get_node(default_current_camera)
onready var target_camera = get_node(default_target_camera)
var tmp_camera

class property_transition:
	var property_name : String
	var transition_type : int
	var ease_type: int

func create_property_transition(property_name, transition_type, ease_type):
	var new_property_transition = property_transition.new()
	new_property_transition.property_name = property_name
	new_property_transition.transition_type = transition_type
	new_property_transition.ease_type = ease_type
	
	return new_property_transition

onready var properties_to_transition = [];

onready var tween = $Tween

signal finished

func _ready():
	for property in default_property_list:
		properties_to_transition.append(
			create_property_transition(property, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT))

func init(_parent):
	pass
	
func set_current_camera(new_current_camera: Camera2D):
	current_camera = new_current_camera
	return self
	
func set_target_camera(new_target_camera: Camera2D):
	target_camera = new_target_camera
	return self
	
func set_properties_to_transition(new_properties_to_transition):
	properties_to_transition = new_properties_to_transition
	return self

func append_properties_to_transition(property_to_transition : property_transition):
	properties_to_transition.append(property_to_transition)

func init_transition(interpolation_time):
	tmp_camera = current_camera.duplicate()
	get_parent().add_child(tmp_camera)
	tmp_camera.current = true
	current_camera.current = false
	
	for property_to_transtion in properties_to_transition:
		tween.interpolate_property(
			tmp_camera, 
			property_to_transtion.property_name,
			tmp_camera.get(property_to_transtion.property_name),
			target_camera.get(property_to_transtion.property_name),
			interpolation_time,
			property_to_transtion.transition_type,
			property_to_transtion.ease_type)
	
	tween.start()

func _on_Tween_tween_all_completed():
	tmp_camera.current = false
	target_camera.current = true
	get_parent().remove_child(tmp_camera)
	emit_signal("finished")
