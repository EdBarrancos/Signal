extends CanvasLayer

onready var score = $ScoreLabel
onready var score_points = 0

export(int) var MAX_LIVES
onready var lives = MAX_LIVES
onready var lives_label = $LivesLabel

func _ready():
	pass

func init(parent):
	pass

func set_score(val):
	score_points = val
	score.text = "Score: " + str(score_points)
	
func add_score(val):
	score_points += val
	score.text = "Score: " + str(score_points)
	
func reset_lives():
	set_lives(MAX_LIVES)
	
func decrement_lives():
	set_lives(lives - 1)
	
func set_lives(val):
	lives = val
	lives_label.text = "Lives: " + str(lives)
