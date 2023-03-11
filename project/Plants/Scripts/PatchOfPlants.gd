extends Node2D

############
#COMPONENTS#
############

###########
#VARIABLES#
###########

# Instantiate
var noise = OpenSimplexNoise.new()

onready var offset = Vector2.ZERO
export(float) var speed = 0.1

########
#EVENTS#
########

func _ready():
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8

func init(parent):
	pass

func _process(delta):
	offset += Vector2(speed, speed);
	for plant in self.get_children():
		var noise_output = noise.get_noise_2d(plant.global_position.x + offset.x, plant.global_position.y + offset.y)
		print(noise_output + 1)
		plant.set_offset(clamp(noise_output, 0, 1) )


##############
#MISCELANIOUS#
##############
