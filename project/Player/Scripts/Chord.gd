extends Node2D

############
#COMPONENTS#
############

onready var player = get_parent()
onready var pin_scene = preload("res://Player/Scenes/Pin.tscn")
onready var spawn_position = $SpawnPoint
onready var fence_scene = preload("res://Player/Scenes/Fence.tscn")

###########
#VARIABLES#
###########

export(int) var MAX_PINS = 7
onready var current_pins = []

onready var fence = []

signal new_fence(fence)

########
#EVENTS#
########

func _ready():
	pass
	
func _process(_delta):
	if not current_pins.empty():
		current_pins.back().apply_collisions()

func spawn_point():
	if len(current_pins) >= MAX_PINS:
		current_pins.pop_front().close()
		
	var new_pin = pin_scene.instance()
	new_pin.init(self, spawn_position.global_position)
	player.get_parent().add_child(new_pin)
	
	if not current_pins.empty():
		current_pins.back().set_next(new_pin)
		new_pin.set_previous(current_pins.back())
	
	current_pins.append(new_pin)

func remove_pin(pin):
	current_pins.erase(pin)
	
func init_fence_surrounding():
	fence.clear()
	
func add_point_fence_surrounding(point):
	fence.append(point)

func finish_fence_surrounding():
	var poolVector = PoolVector2Array(fence)
	var collision_shape_poligon = CollisionPolygon2D.new()
	collision_shape_poligon.polygon = poolVector

	var area2d = fence_scene.instance()
	get_viewport().add_child(area2d)
	area2d.add_child(collision_shape_poligon)

	fence.clear()
	
	emit_signal("new_fence", area2d)
