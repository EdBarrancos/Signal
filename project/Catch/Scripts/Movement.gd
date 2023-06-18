extends Node2D

export(float) var velocity = 0.5

onready var catch = get_parent()

var current_target

onready var sprites = $"../Sprites"

## Description

# Two States. Found a patch and havent

## End

func _ready():
	pass

func init(_parent):
	pass

func _physics_process(delta):
	if (current_target):
		sprites.look_at(current_target)
		catch.move_and_collide(
			(current_target - global_position) * velocity * delta)


func _on_ScanPatches_area_entered(area):
	current_target = area.global_position


func _on_ScanPatches_area_exited(area):
	if current_target == area.global_position:
		current_target = null
