extends Node2D

export var arena_scene : PackedScene
export var end_scene : PackedScene

enum Scenes {Arena, End}

export(Scenes) var initial_scene

onready var current_scene = $Arena

func _ready():
	update_scene(initial_scene)
	
func _input(event):
	if event.is_action_pressed("GO_TO_ENDSCREEN"):
		update_scene(Scenes.End)
	
func set_arena_scene():
	update_scene(Scenes.Arena)
	
func set_ending_scene(score_value):
	update_scene(Scenes.End)
	current_scene.init(self, score_value)
	
func update_scene(next_scene):
	current_scene.queue_free()
	set_scene(next_scene)
	
func set_scene(scene):
	current_scene = get_scene(scene)
	add_child(current_scene)

func get_scene(target_scene):
	match(target_scene):
		Scenes.Arena:
			return arena_scene.instance()
		Scenes.End:
			return end_scene.instance()

func get_blood_splatter_container():
	return $BloodSplatters
