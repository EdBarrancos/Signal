extends CanvasLayer

onready var score = $ScoreLabel
onready var score_points = 0

export(int) var MAX_LIVES
onready var lives = MAX_LIVES
onready var lives_label = $LivesLabel

func _ready():
	pass

func init(_parent):
	pass

func set_score(val):
	score_points = val
	score.clear()
	score.append_bbcode(
		"[center]" +
		"Score: " + str(score_points) +
		"[/center]"
	)
	
func add_score(val):
	set_score(score_points + val)
	
func reset_lives():
	set_lives(MAX_LIVES)
	
func decrement_lives():
	set_lives(lives - 1)
	
func set_lives(val):
	lives = val
	lives_label.clear()
	lives_label.append_bbcode(
		"[center]" +
		"Lives: " + str(lives) +
		"[/center]"
	)
