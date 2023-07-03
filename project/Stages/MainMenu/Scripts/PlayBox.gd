extends StaticBody2D

export var max_wave_size : float;
export var wave_animation_time : float;
onready var queue_wave_animation = null;

export var flash_animation_time : float;
onready var queue_flash_animation = null;


onready var tween = $Tween
onready var sprite = $Sprite

func _ready():
	pass

func init(parent):
	pass


func _on_PlayerCollision_body_entered(body):
	var waving = (self.global_position - body.global_position).normalized() * max_wave_size;
	tween.interpolate_property(
		sprite.material, 
		"shader_param/wind", 
		Vector2.ZERO, 
		waving, 
		wave_animation_time / 2, 
		Tween.TRANS_CUBIC,Tween.EASE_OUT)
		
	tween.interpolate_property(
		sprite.material, 
		"shader_param/wind", 
		waving, 
		Vector2.ZERO,
		wave_animation_time / 2,
		Tween.TRANS_ELASTIC, 
		Tween.EASE_OUT,
		wave_animation_time / 2)
	
	tween.interpolate_property(
		sprite.material, 
		"shader_param/flash_modifier",
		0,
		1,
		flash_animation_time / 2) 
	tween.interpolate_property(
		sprite.material, 
		"shader_param/flash_modifier",
		1,
		0,
		flash_animation_time / 2, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT, 
		flash_animation_time / 2)
	tween.start()


func _on_FencingCollisions_area_exited(area):
	print("hello")
