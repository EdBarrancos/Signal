extends Node2D

############
#COMPONENTS#
############

onready var sprite = $Sprite
onready var rng = RandomNumberGenerator.new()

export(Array, Texture) var plant_sprites = []

onready var timer = $Timer
export(float) var MAX_SECONDS_BEFORE_REGROWTH = 1.0

onready var animation_player = $AnimationPlayer

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

func init(_parent):
	pass

#func _process(delta):
#   pass

func set_wind(wind):
	sprite.material.set_shader_param("wind", wind)

##############
#MISCELANIOUS#
##############


func _on_HitBox_body_entered(_body):
	animation_player.play("Dead")
	timer.set_wait_time(rng.randf_range(0, MAX_SECONDS_BEFORE_REGROWTH))
	timer.start()


func _on_Timer_timeout():
	animation_player.play("Grow")
