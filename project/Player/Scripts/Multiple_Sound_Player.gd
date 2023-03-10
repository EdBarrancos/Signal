extends AudioStreamPlayer2D

export(Array, AudioStream) var available_sounds = []

onready var random = RandomNumberGenerator.new()

func play_sound():
	if len(available_sounds) != 0:
		random.randomize()
		self.stream = available_sounds[random.randi_range(0, len(available_sounds) - 1)]
		self.play()

