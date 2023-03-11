extends KinematicBody2D

############
#COMPONENTS#
############

onready var caught_sound_effect = $CaughtSound
onready var die_sound_effect = $DeadSound
onready var sound_timer = $SoundTimer
onready var animation_player = $AnimationPlayer

###########
#VARIABLES#
###########

onready var rng = RandomNumberGenerator.new()

onready var anim_finished = false
onready var sound_finished = false

onready var caught = false
onready var dead = false

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
	if dead == false:
		caught = true
		play_sound_caught()
		animation_player.play("Caught")
	
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
	dead = true
	animation_player.play("Dead")
	play_sound_dead()

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

func _on_HurtBox_area_entered(area):
	if caught == false:
		die()

func _on_HurtBox_body_entered(body):
	if caught == false:
		die()

func _on_DeadSound_finished():
	sound_finished = true
