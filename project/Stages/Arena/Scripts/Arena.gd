extends Node2D

############
#COMPONENTS#
############

onready var camera = $Camera
onready var notes_node = $Notes

onready var game_states = $GameStates

###########
#VARIABLES#
###########

onready var active_fences = []

########
#EVENTS#
########

func _ready():
	game_states.init()

func init(_parent):
	pass

func _physics_process(_delta):
	var index = 0
	while index < len(active_fences):
		if not is_instance_valid(active_fences[index]):
			active_fences.remove(index)
			continue
		var notes = notes_node.get_children()
		for note in notes:
			if not is_instance_valid(note):
				continue
			if active_fences[index].overlaps_body(note):
				active_fences[index].caught = true
				note.catch()
		active_fences[index].destroy()
		index += 1

##############
#MISCELANIOUS#
##############

func _on_Player_collision():
	camera.increase_trauma(camera.TraumaIntensity.Minor)

func _on_Player_spawn_pin():
	camera.increase_trauma(camera.TraumaIntensity.Minor)

func _on_Player_new_fence(fence):
	active_fences.append(fence)
