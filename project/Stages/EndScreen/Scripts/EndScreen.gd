extends Node2D

onready var score_label = $ActualScoreLabel
onready var score_value_label = $ActualScoreLabel/RichTextLabel

export var score_value = 120

onready var can_skip = false

func _ready():
	score_value_label.bbcode_text = "[center]" + str(score_value) + "[/center]"

func init(_parent, new_score_value):
	score_value = new_score_value
	score_value_label.bbcode_text = "[center]" + str(score_value) + "[/center]"

func _input(event):
	if event is InputEventKey:
		#skip()
		pass
		
func skip():
	if can_skip:
		get_parent().set_arena_scene()

func _on_Timer_timeout():
	can_skip = true
