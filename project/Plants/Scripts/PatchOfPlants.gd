extends Node2D

############
#COMPONENTS#
############

onready var plants = $Plants
onready var circle = $CirclePatch
onready var debug_line = $Line2D
onready var tween = $Tween
onready var circle_area = $Area2D/CollisionShape2D

signal eaten

###########
#VARIABLES#
###########

# Instantiate
var noise = OpenSimplexNoise.new()

onready var offset = 0
export(float) var speed = 0.01
export(float) var scale_noise = 0.01

export(int) var frame_skip = 5
onready var frame_counter = 0

# Spawning Plants
export(int) var radius = 20 
export(float) var density = 0.1
export(int) var number_of_entities = 10
export(float) var separation_radius = 0.5

var max_circle_scale
var min_circle_scale

export(float) var time_scale_tween_rotation = 1.0
export(float) var time_scale_tween_scale = 2.0
export(float) var max_scale_multiplier = 1.5
export(float) var min_scale_multiplier = 1.0


export(int) var max_rotation_angle_degree = 70

export(Resource) var plant_scene_path = preload("res://Plants/Scenes/Plant.tscn")

onready var rng = RandomNumberGenerator.new()

########
#EVENTS#
########

func _ready():
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	
	circle_area.shape.radius = radius * 1
	
	resize_circle(radius * 1.5)
	
	spawn_plants()
	
	begin_rotation_tween_animation()
	begin_scale_tween_animation()

func init(_parent):
	pass

func _physics_process(_delta):
	if frame_counter == frame_skip:
		offset += speed
		for plant in plants.get_children():
			var noise_output = noise.get_noise_3d(
				plant.global_position.x * scale_noise, 
				plant.global_position.y * scale_noise,
				offset)
			
			var wind = Vector2(1, 1)
			
			plant.set_wind(wind.rotated(noise_output * 180) )
		frame_counter = 0
	else:
		frame_counter += 1
	
func spawn_plants():
	var spawned_positions = []
	for _i in range(number_of_entities):
		var new_plant = plant_scene_path.instance()
		var new_position = get_spawn_position(radius)
		while is_in_range(spawned_positions, new_position, separation_radius):
			new_position = get_spawn_position(radius)
		spawned_positions.append(new_position)
		
		new_plant.position = new_position
		plants.add_child(new_plant)
		
func is_in_range(previous, target, distance):
	for pos in previous:
		if pos.distance_to(target) <= distance:
			return true
	return false

func get_spawn_position(radius_modifier):
	rng.randomize()
	return Vector2(1,1).rotated(rng.randi_range(0, 360)) \
			* (rng.randf_range(0, 1) * radius_modifier)

func resize_circle(target_size):
	debug_line.clear_points()
	debug_line.add_point(Vector2.ZERO)
	debug_line.add_point(Vector2(target_size, 0))
	
	var scale_one_size = circle.texture.get_width() / 2
	var new_scale = float(target_size)/scale_one_size
	
	min_circle_scale = new_scale * min_scale_multiplier
	max_circle_scale = new_scale * max_scale_multiplier
	
	circle.scale = Vector2(new_scale, new_scale)
	
func begin_rotation_tween_animation():
	var current_rotation = circle.rotation
	var noise_output = noise.get_noise_3d(0, 0, offset)
	
	var interpolation_time = (noise_output + 2)/2 * time_scale_tween_rotation
	
	tween.interpolate_property(circle, "rotation",
		current_rotation, current_rotation + noise_output * max_rotation_angle_degree, interpolation_time,
		Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		
	tween.start()

func begin_scale_tween_animation():	
	var current_scale = circle.scale
	var noise_output = noise.get_noise_3d(0, 0, offset)
	
	var interpolation_time = (noise_output + 2)/2 * time_scale_tween_scale
		
	var target_scale = Vector2(max_circle_scale, max_circle_scale)
	
	if current_scale.x >= max_circle_scale:
		target_scale = Vector2(min_circle_scale, min_circle_scale)
	elif current_scale.x <= min_circle_scale:
		target_scale = Vector2(max_circle_scale, max_circle_scale)
	
	tween.interpolate_property(circle, "scale",
		current_scale, target_scale, interpolation_time,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()


func _on_Tween_tween_completed(_object, key):
	if key == ":scale":
		begin_scale_tween_animation()
	elif key == ":rotation":
		begin_rotation_tween_animation()


func _on_Area2D_destroy():
	emit_signal("eaten")
	queue_free()
