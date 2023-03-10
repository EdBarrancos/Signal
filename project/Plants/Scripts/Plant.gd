extends Node2D

############
#COMPONENTS#
############

onready var sprite = $Sprite

###########
#VARIABLES#
###########

########
#EVENTS#
########

func _ready():
	pass

func init(parent):
	pass

#func _process(delta):
#   pass

func set_offset(new_offset):
	sprite.material.set_shader_param("offset", new_offset)

##############
#MISCELANIOUS#
##############
