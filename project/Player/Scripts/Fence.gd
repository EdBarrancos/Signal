extends Area2D

onready var fence_visuals = $FenceVisual

onready var lives = 3
onready var current_life = 0

onready var caught = false

onready var rng = RandomNumberGenerator.new()

func _ready():
	pass

func init(_parent):
	pass

##############
#MISCELANIOUS#
##############

func destroy():
	current_life += 1
	if current_life >= lives:
		self.queue_free()

func _on_Timer_timeout():
	self.queue_free()

func _on_Fence_child_entered_tree(node):
	if node.get_class() == "CollisionPolygon2D":
		fence_visuals.polygon = node.polygon
		generate_glitch_displacement()
		
func generate_glitch_displacement():
	var displacement = create_glitch_displacement()
	fence_visuals.material.set_shader_param("red_displacement", displacement.red)
	fence_visuals.material.set_shader_param("green_displacement", displacement.green)
	fence_visuals.material.set_shader_param("blue_displacement", displacement.blue)	
	pass
	
class Displacement:
	var red = Vector2.ZERO
	var green = Vector2.ZERO
	var blue = Vector2.ZERO

func create_glitch_displacement():
	var displacements = generate_array_displacements()
	var displacement = Displacement.new()
	for index in range(len(displacements)):
		match(index):
			0:
				displacement.red = displacements[0]
			1:
				displacement.green = displacements[1]
			2:
				displacement.blue = displacements[2]
	return displacement
	
func generate_array_displacements():
	rng.randomize()
	var zeroed = rng.randi_range(0, 2)
	
	var displacements = []
	for index in [0,1,2]:
		if index == zeroed:
			displacements.append(Vector2.ZERO)
		displacements.append(
			Vector2(
				rng.randf_range(-0.02, 0.02),
				rng.randf_range(-0.02, 0.02)))
	return displacements
