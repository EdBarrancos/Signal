tool
extends Node2D

export var texture : Texture
export var max_size : Vector2
export var min_size : Vector2
export var number_of_instances : float

export var angle : float setget set_angle
export var delay : float
export var damp_time : float
export var damp_angle : float
export var actual_delay : float
export var actual_delay_increase : float

export var storage_inst : NodePath
export var center : NodePath
export var background_inst : PackedScene

export var populate : bool setget set_populate
export var clear : bool setget set_clear

var last_spawned_instance = null

func set_angle(new_angle):
	angle = new_angle
	if check_sets() and last_spawned_instance:
		last_spawned_instance.set_angle(
			angle, 
			delay, 
			damp_time, 
			damp_angle,
			actual_delay,
			actual_delay_increase)

func set_populate(new_populate):
	if new_populate:
		if Engine.editor_hint and check_sets():
			clear_all()
			populate_background()
	populate = new_populate
	
func set_clear(new_clear):
	if new_clear:
		if Engine.editor_hint and check_sets():
			clear_all()
	clear = new_clear

onready var screen_center_position = Vector2(80, 72)
onready var background_instance_storage = $BackgroundInstances

func check_sets():
	return storage_inst and center and background_inst
	
func clear_all():
	last_spawned_instance = null
	for i in self.get_node(storage_inst).get_children():
		if i.name.find("bck") != -1:
			i.queue_free()

func _ready():
	if max_size.length() < min_size.length():
		push_error("Max Size greater then Min Size")
	populate_background()

func populate_background():
	var step_size = get_step_size()
	var target_size = max_size
	var last_instance = null
	var tmp_instance = null
	for i in range(number_of_instances) :
		tmp_instance = create_instance_background(texture, target_size, last_instance)
		if last_instance:
			last_instance.set_previous_instance(tmp_instance)
		last_instance = tmp_instance
		
		target_size = update_size(target_size, step_size)
	last_spawned_instance = last_instance
	
func create_instance_background(target_texture, size, last_instance):
	var new_instance = background_inst.instance()
	var parent_target = self.get_node(storage_inst)
	
	new_instance.name += "bck"
	
	parent_target.add_child(new_instance)
	new_instance.set_owner(self)

	new_instance \
		.set_texture(target_texture) \
		.set_position(self.get_node(center).position) \
		.set_scale(size) \
		.set_linked_instance(last_instance)
		
	return new_instance
	
func update_size(current_size, step_size):
	return current_size - step_size
	
func get_step_size():
	var diff = max_size - min_size
	return diff / number_of_instances
