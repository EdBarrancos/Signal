extends Node2D

export(int) var velocity = 15

onready var catch = get_parent()

var current_target : Position2D

func _ready():
	pass

func init(parent):
	pass

func _physics_process(delta):
	if (current_target):
		catch.move_and_collide(
			(global_position - current_target.global_position) * velocity * delta)
