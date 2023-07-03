extends Node2D

############
#COMPONENTS#
############

onready var notes_node = $Notes
onready var game_states = $GameStates

# Ugly, get an actual score manager
onready var score_manager = $GameStates/NormalGameState/CanvasLayer

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
	game_states.get_camera().increase_trauma(
		game_states.get_camera().TraumaIntensity.Minor)

func _on_Player_spawn_pin():
	game_states.get_camera().increase_trauma(
		game_states.get_camera().TraumaIntensity.Minor)

func _on_Player_new_fence(fence):
	active_fences.append(fence)
	game_states.get_camera().increase_trauma(
		game_states.get_camera().TraumaIntensity.Medium)

func _on_GameStates_all_states_finished():
	get_parent().set_ending_scene(score_manager.score_points)
