extends KinematicBody2D

############
#COMPONENTS#
############

onready var caught_sound_effect = $CaughtSound
onready var die_sound_effect = $DeadSound
onready var sound_timer = $SoundTimer
onready var animation_player = $AnimationPlayer

var blood = load("res://Catch/Scenes/Blood.tscn")

###########
#VARIABLES#
###########

onready var rng = RandomNumberGenerator.new()

onready var anim_finished = false
onready var sound_finished = false

onready var caught = false
onready var dead = false

signal died
signal caught

########
#EVENTS#
########

func _ready():
	pass

func init(_parent):
	pass

func _process(_delta):
	if sound_finished and anim_finished:
		self.queue_free()
		
func catch():
	if dead == false and caught == false:
		emit_signal("caught")
		caught = true
		play_sound_caught()
		animation_player.play("Caught")

func blood_splatter():
	var blood_instance = blood.instance()
	# /Node-Container/Arena/Global
	get_parent().get_parent().get_parent().get_blood_splatter_container().add_child(blood_instance)
	blood_instance.global_position = self.global_position
	
##############
#MISCELANIOUS#
##############

func play_sound_caught():
	rng.randomize()
	sound_timer.set_wait_time(rng.randf_range(0.1, 0.5))
	sound_timer.start()
	
func play_sound_dead():
	die_sound_effect.play_sound()
	
func die():
	if caught == false and dead == false:
		emit_signal("died")
		dead = true
		animation_player.play("Dead")
		play_sound_dead()
		blood_splatter()

func _on_SoundTimer_timeout():
	if caught == true:
		caught_sound_effect.play_sound()
	elif dead == true:
		die_sound_effect.play_sound()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Caught":
		anim_finished = true
		self.visible = false
	if anim_name == "Dead":
		anim_finished = true
		self.visible = true

func _on_CaughtSound_finished():
	sound_finished = true

func _on_HurtBox_area_entered(_area):
	if caught == false:
		die()

func _on_HurtBox_body_entered(_body):
	if caught == false:
		die()

func _on_DeadSound_finished():
	sound_finished = true
