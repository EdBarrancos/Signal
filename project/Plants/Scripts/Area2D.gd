extends Area2D

onready var catches = []

export(int) var number_of_catches = 3

signal destroy

func _ready():
	pass

func _process(_delta):
	if len(catches) >= number_of_catches:
		emit_signal("destroy")

func _on_Area2D_body_entered(body):
	catches.append(body)
