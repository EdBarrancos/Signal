extends KinematicBody2D

onready var playerAnimation = $Sprites/PlayerAnimation
onready var collisionSound = $Bump_Sound
onready var movement = $Movement
onready var habilities = $Habilities
onready var chord = $Chord

signal collision
signal spawn_pin

signal new_fence(fence)

enum PlayerStates {Idle, Boost}
onready var player_state = PlayerStates.Idle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _input(event):
	if event.is_action_pressed("BOOST"):
		player_state = PlayerStates.Boost
		habilities.activate_boost()
	
	if event.is_action_pressed("CHORD"):
		chord.spawn_point()
		emit_signal("spawn_pin")

func _on_Movement_collision():
	if player_state == PlayerStates.Idle:
		playerAnimation.play("squeeze")
	emit_signal("collision")
	collisionSound.play_sound()

func _on_BoostTimer_timeout():
	player_state = PlayerStates.Idle

func _on_Chord_new_fence(fence):
	emit_signal("new_fence", fence)
