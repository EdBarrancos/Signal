extends Node2D

onready var player = get_parent()

export(float) var SPEED = 130.0;
export(float) var ROTATION_SPEED = 0.07;

onready var direction = Vector2(1,0)
onready var angle = 0
onready var extra_velocity = Vector2.ZERO
onready var extra_speed = 1

signal collision

onready var turning = true

func set_turning(value):
	turning = value
	
func boost(speed):
	#This is flawed
	extra_speed += speed
	
func stop_boost(speed):
	#This is flawed
	extra_speed -= speed

func _process(_delta):
	player.rotation = Vector2(1, 0).angle_to(direction) + angle
	get_input()
	
func _physics_process(delta):
	update_direction()
	var target_velocity = direction*SPEED + direction*extra_speed + extra_velocity
	
	var collision = player.move_and_collide(target_velocity * delta)
	if collision:
		var new_direction = target_velocity.bounce(collision.normal).normalized()
		angle = direction.angle_to(new_direction)
		emit_signal("collision")
		
func update_direction():
	direction = direction.rotated(angle)
	angle = 0

func get_input():
	if turning:
		angle += Input.get_action_strength("RIGHT") * ROTATION_SPEED;
		angle -= Input.get_action_strength("LEFT") * ROTATION_SPEED;
