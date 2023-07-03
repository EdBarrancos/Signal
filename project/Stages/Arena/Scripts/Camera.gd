extends Camera2D

###########
#VARIABLES#
###########

onready var trauma = 0
export var maxOffSet = 10
export var maxAngle = 20
export(int, 2,3) var powerTraumaTo = 3
export(float) var decreaseTrauma = 0.01
onready var decrease_flag = true

enum TraumaIntensity {Minor, Medium, Major}

onready var noise = OpenSimplexNoise.new()
onready var noiseGenerator = 0

########
#EVENTS#
########

func _ready():
	# Configure
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	
func _process(_delta):
	if trauma > 1:
		trauma = 1
		
	if trauma > 0:
		rotational_shake(pow(trauma, powerTraumaTo))
		translational_shake(pow(trauma, powerTraumaTo))
		if decrease_flag:
			trauma -= decreaseTrauma
		noiseGenerator += 0.6
	else:
		reset_shake()
		trauma = 0
	
##############
#CAMERA SHAKE#
##############

func set_trauma(additional_trauma):
	decrease_flag = false
	match(additional_trauma):
		TraumaIntensity.Minor:
			trauma = 0.2
		TraumaIntensity.Medium:
			trauma = 0.5
		TraumaIntensity.Major:
			trauma = 0.8

func increase_trauma(additional_trauma):
	match(additional_trauma):
		TraumaIntensity.Minor:
			trauma += 0.2
		TraumaIntensity.Medium:
			trauma += 0.5
		TraumaIntensity.Major:
			trauma += 0.8

func translational_shake(shakeAmount):
	var offsetx = maxOffSet * shakeAmount * noise.get_noise_2d(noiseGenerator, 0.0)
	var offsety = maxOffSet * shakeAmount * noise.get_noise_2d(noiseGenerator, 1.0)
	offset = Vector2(offsetx, offsety)
	
func reset_shake():
	offset = Vector2.ZERO
	rotation_degrees = 0
	
func rotational_shake(shakeAmount):
	rotation_degrees = maxAngle * shakeAmount * noise.get_noise_2d(noiseGenerator, 0.0)

	
##############
#MISCELANIOUS#
##############
