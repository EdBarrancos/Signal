tool
extends Node2D
class_name BackgroundInstance

onready var sprite = $Sprite
onready var tween = $Tween

onready var rng = RandomNumberGenerator.new()

var linked_instance
var previous_instance

var total_number_of_instances
var id

func _ready():
	rng.randomize()

func set_texture(new_texture):
	sprite.texture = new_texture
	return self

func set_linked_instance(new_linked_instance):
	linked_instance = new_linked_instance
	return self
	
func set_previous_instance(new_previous_instance):
	previous_instance = new_previous_instance
	return self

func set_position(new_position):
	position = new_position
	return self

func set_scale(new_scale):
	scale = new_scale
	return self
	
func set_total_number_of_instances(new_total):
	total_number_of_instances = new_total
	return self

func set_instance_id(new_id):
	id = new_id
	return self
	
func rotate_background_piece(
	new_angle, 
	delay, 
	damp, 
	damp_angle,
	actual_delay,
	actual_delay_increase):
		
	if actual_delay * (1 / total_number_of_instances) > 0:
		yield(get_tree().create_timer(actual_delay * (1 / total_number_of_instances)), "timeout")

	animate_angle(new_angle, delay * (1 / total_number_of_instances))
		
	if linked_instance:
		linked_instance.rotate_background_piece(
			new_angle, 
			delay + damp * (1 / total_number_of_instances), 
			damp,
			damp_angle,
			actual_delay + actual_delay_increase * (1 / total_number_of_instances),
			actual_delay_increase)
			
	return self

func animate_angle(target_angle, delay):
	tween.interpolate_property(
		self, 
		"rotation_degrees",
		null,
		target_angle,
		delay,
		Tween.TRANS_SINE,
		Tween.EASE_OUT)
	tween.start()
