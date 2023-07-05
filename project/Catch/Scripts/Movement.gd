extends Node2D

export(float) var velocity = 0.5

onready var catch = get_parent()

var current_target
onready var nearby_catches = []

onready var sprites = $"../Sprites"

## Description

# Two States. Found a patch and havent

## End

func _ready():
	pass

func init(_parent):
	pass

func _physics_process(delta):
	var target_vector = Vector2.ZERO
	if (current_target):
		target_vector += (current_target - global_position)
	
	var invalid_instances = []
	for nearby in nearby_catches:
		if !is_instance_valid(nearby):
			invalid_instances.append(nearby)
			continue
		target_vector += (global_position - nearby.global_position) 
	
	for invalid_instance in invalid_instances:
		var index = nearby_catches.find(invalid_instance)
		nearby_catches.remove(index)
	
	if target_vector.length() >= 0.3:
		target_vector = target_vector.normalized()
		sprites.look_at(target_vector)
		catch.move_and_slide(
			target_vector * velocity)

func _on_ScanPatches_area_entered(area):
	current_target = area.global_position


func _on_ScanPatches_area_exited(area):
	if current_target == area.global_position:
		current_target = null


func _on_ScanOtherSheep_body_entered(body):
	if body == self:
		return
	nearby_catches.append(body)


func _on_ScanOtherSheep_body_exited(body):
	var index = nearby_catches.find(body)
	if index != -1:
		nearby_catches.remove(index)
