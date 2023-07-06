extends StaticBody2D

############
#COMPONENTS#
############

onready var pin_scene = load("res://Player/Scenes/Pin.tscn")

onready var animation_player = $AnimationPlayer
onready var fence = $VisualFence
onready var auxiliary_fence = $AuxiliaryFence
onready var fence_collision = $VisualFence/FenceArea/FenceCollision
onready var fence_area = $VisualFence/FenceArea
onready var spawn_sound = $SpawnSound
onready var sparks_particles = $Sparks 

var parent

###########
#VARIABLES#
###########

onready var next = null
onready var previous = null

onready var colliding_with = []

onready var global_fence = []

onready var is_closed = false
onready var is_temp = false

########
#EVENTS#
########

func _ready():
	spawn_sound.play_sound()
	sparks_particles.emitting = true
	
func _process(_delta):
	if (next == null):
		auxiliary_fence.clear_points()
		auxiliary_fence.add_point(Vector2.ZERO)
		auxiliary_fence.add_point(parent.global_position - self.global_position)

func init(parent_tobe, pos):
	self.global_position = pos
	self.parent = parent_tobe

func set_next(next_pin):
	next = next_pin
	auxiliary_fence.clear_points()
	
func set_previous(previous_pin):
	previous = previous_pin
	fence.clear_points()
	fence.add_point(Vector2.ZERO)
	fence.add_point(previous.position - self.position)
	
	var segment = SegmentShape2D.new()
	segment.a = Vector2.ZERO
	segment.b = previous.position - self.position
	fence_collision.shape = segment
	
	global_fence.clear()
	global_fence.append(self.global_position)
	global_fence.append(previous_pin.global_position)
	
func apply_collisions():
	var was_colliding = not colliding_with.empty()
	
	while not colliding_with.empty():
		var target = colliding_with.pop_back()
			
		if (not is_instance_valid(target) or target.is_closed):
			continue
			
		var pin = self
		var crossing_fence = pin.global_fence.duplicate()
		parent.init_fence_surrounding()
		
		while not target_reached(pin, target):
			var tmp = pin.previous
			
			if pin != self:
				parent.add_point_fence_surrounding(pin.global_position)
				pin.close()
			pin = tmp

		parent.add_point_fence_surrounding(pin.global_position)
		
		var intercept_point = calculate_interception_point(
				crossing_fence, 
				pin.global_fence)
		parent.add_point_fence_surrounding(intercept_point)
				
		if not colliding_with.empty():
			create_temporary_pin(intercept_point, pin)
		else:
			if (is_instance_valid(pin.previous) and not pin.previous.is_closed):
				pin.previous.close()
			pin.close()
		
		parent.finish_fence_surrounding()
		
	if was_colliding:
		self.close()

func target_reached(current_pin, target):
	return current_pin.name == target.name

func create_temporary_pin(pin_position, current_pin):
	var help_pin = pin_scene.instance()
	help_pin.init(
		parent, 
		pin_position)
	self.get_parent().add_child(help_pin)
	
	help_pin.set_next(self)
	current_pin.next.set_next(help_pin)
	help_pin.set_previous(current_pin.next)
	self.set_previous(help_pin)
	
	help_pin.is_temp = true
	
	return help_pin
	
func calculate_interception_point(fence1, fence2):
	var fence1_point1 = fence1[0]
	var fence1_point2 = fence1[1]
	
	var fence2_point1 = fence2[0]
	var fence2_point2 = fence2[1]
	
	var interception = Geometry.line_intersects_line_2d(
		fence1_point1, 
		fence1_point2 - fence1_point1,
		fence2_point1,
		fence2_point2 - fence2_point1)
		
	return interception
	
# CLOSING
	
func close():
	if is_temp:
		finish_close()
		return
	
	is_closed = true
	animation_player.play("death")
	
func finish_close():
	if next != null:
		next.previous_closed()
	
	if previous != null:
		previous.next_closed()
		
	parent.remove_pin(self)
	self.queue_free()
	
func previous_closed():
	previous = null
	
	var segment = SegmentShape2D.new()
	segment.a = Vector2.ZERO
	segment.b = Vector2.ZERO
	fence_collision.shape = segment
	
	fence.clear_points()
	
	global_fence.clear()
	
func next_closed():
	next = null

func _on_PlayerCollision_body_entered(_body):
	animation_player.play("bounce")

func _on_FenceCollision_area_entered(area):
	if next != null and area == next.fence_area:
		pass
	elif previous != null and area == previous.fence_area:
		pass
	elif area.has_method("get_pin"):
		colliding_with.append(area.get_pin())

func _on_AnimationPlayer_animation_finished(_anim_name):
	if is_closed:
		finish_close()
		
