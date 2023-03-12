extends Node2D

############
#COMPONENTS#
############

onready var sprite = $Sprite
onready var rng = RandomNumberGenerator.new()

export var plant_sprite_path = "res://Plants/Assets/plant_sprites/"
export(Array, Texture) var plant_sprites = []

###########
#VARIABLES#
###########

########
#EVENTS#
########

func _ready():
	rng.randomize()
	sprite.material.set_shader_param("heightOffset", rng.randf_range(0.1, 0.5))
	
	var sprite_to_be = plant_sprites[rng.randi_range(0, len(plant_sprites) - 1)]
	sprite.texture = sprite_to_be

func init(parent):
	pass

#func _process(delta):
#   pass

func set_wind(wind):
	sprite.material.set_shader_param("wind", wind)

##############
#MISCELANIOUS#
##############
