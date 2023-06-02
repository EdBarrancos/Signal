tool
extends Node2D
class_name BackgroundInstance

onready var sprite = $Sprite
onready var tween = $Tween

onready var rng = RandomNumberGenerator.new()

var linked_instance
var previous_instance

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
	
func set_angle(
	new_angle, 
	delay, 
	damp, 
	damp_angle,
	actual_delay,
	actual_delay_increase):
		
	if actual_delay > 0:
		yield(get_tree().create_timer(actual_delay), "timeout")
	
	animate_angle(new_angle, delay)
		
	if linked_instance:
		linked_instance.set_angle(
			(1 - damp_angle) * new_angle, 
			delay + damp, 
			damp,
			damp_angle,
			actual_delay + actual_delay_increase,
			actual_delay_increase)
			
	return self

func animate_angle(target_angle, delay):
	tween.interpolate_property(
		self, 
		"rotation_degrees",
		null,
		target_angle,
		delay,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT)
	tween.start()
