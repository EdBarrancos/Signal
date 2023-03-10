extends Node2D

onready var movement_handler = $"../Movement"
onready var player_animation = $"../Sprites/PlayerAnimation"

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
	
	boostTimer.set_wait_time(boost_length)
	boostTimer.one_shot = true
	boostTimer.start()
	
	if not boosting:
		movement_handler.set_turning(false)
		movement_handler.boost(boost_speed)
		
		player_animation.play("boost_init")

##############
#MISCELANIOUS#
##############

func _on_BoostTimer_timeout():
	movement_handler.set_turning(true)
	player_animation.play("boost_end")
	movement_handler.stop_boost(boost_speed)
