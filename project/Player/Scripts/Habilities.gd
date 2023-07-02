extends Node2D

onready var movement_handler = $"../Movement"
onready var player_animation = $"../Sprites/PlayerAnimation"
onready var boost_sound = $"../Boost_Sound"
onready var boost_particles = $"../BoostParticles"

# Boost
export(float) var BOOST_LENGTH = 0.2
export(float) var BOOST_SPEED = 30.0
onready var boost_length = BOOST_LENGTH
onready var boost_speed = BOOST_SPEED
onready var boostTimer = $BoostTimer

func _ready():
	pass

func init(_parent):
	pass

func activate_boost():
	var boosting = not boostTimer.is_stopped()
	
	if not boosting:
		boostTimer.set_wait_time(boost_length)
		boostTimer.one_shot = true
		boostTimer.start()
	
		movement_handler.boost(boost_speed)
		
		player_animation.play("boost_init")
		
		boost_sound.play_sound()
		boost_particles.restart()
		get_parent().set_collision_layer_bit(4, false) # Dodege Catches
		get_parent().set_collision_mask_bit(5, false) # Dodge pins

##############
#MISCELANIOUS#
##############

func _on_BoostTimer_timeout():
	player_animation.play("boost_end")
	movement_handler.stop_boost(boost_speed)
	get_parent().set_collision_layer_bit(4, true)
	get_parent().set_collision_mask_bit(5, true)
