tool
extends Node2D

export(float, -360, 360) var offset_rotation = 0 setget changeSlider_x

func changeSlider_x(changed_val):
	offset_rotation=changed_val
	self.rotation_degrees = changed_val

func look_at(target: Vector2):
	.look_at(target)
	rotation_degrees += offset_rotation

func _ready():
	rotation_degrees = 0
