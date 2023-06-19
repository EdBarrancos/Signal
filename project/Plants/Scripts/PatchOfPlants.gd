extends Node2D

############
#COMPONENTS#
############

onready var plants = $Plants
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
	
	spawn_plants()
	
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

func _on_Area2D_destroy():
	emit_signal("eaten")
	queue_free()
