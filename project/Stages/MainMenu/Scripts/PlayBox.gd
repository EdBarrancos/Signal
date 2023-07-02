extends StaticBody2D

export var max_wave_size : float;
export var animation_time : float;

onready var tween = $Tween
onready var sprite = $Sprite

func _ready():
	pass

func init(parent):
	pass

#func _process(delta):
#   pass



func _on_PlayerCollision_body_entered(body):
	var waving = (self.global_position - body.global_position).normalized() * max_wave_size;
	tween.interpolate_property(
		sprite.material, 
		"shader_param/wind", 
		Vector2.ZERO, 
		waving, 
		animation_time / 2, 
		Tween.TRANS_CUBIC,Tween.EASE_OUT)
	tween.start()
	
	yield(tween,"tween_completed")
	tween.interpolate_property(
		sprite.material, 
		"shader_param/wind", 
		waving, 
		Vector2.ZERO,
		animation_time / 2,
		Tween.TRANS_ELASTIC, 
		Tween.EASE_OUT)
	tween.start()
