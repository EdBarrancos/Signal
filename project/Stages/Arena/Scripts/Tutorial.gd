extends CanvasLayer

export(String) var pin_tutorial_label = "to fence"
export(String) var boost_tutorial_label = "to boost"

onready var move_left = $MoveLeft
onready var move_right = $MoveRight 
onready var pin_tutorial = $XTutorial
onready var boost_tutorial =$ZTutorial

onready var kill_tipe = $KillTip
onready var capture_tip = $CaptureTip

func _ready():
	pin_tutorial.clear()
	pin_tutorial.append_bbcode(
		"[center]" +
		"[" + KeyBindings.get_key_binding_pin() + "] " + 
		pin_tutorial_label +
		"[/center]")
	
	boost_tutorial.clear()
	boost_tutorial.append_bbcode(
		"[center]" +
		"[" + KeyBindings.get_key_binding_boost() + "]" +
		boost_tutorial_label +
		"[/center]")

func init(parent):
	pass

func _process(delta):
   pass

func set_left(new_value):
	move_left.visible = new_value
	
func set_right(new_value):
	move_right.visible = new_value
	
func set_pin(new_value):
	pin_tutorial.visible = new_value
	
func set_boost(new_value):
	boost_tutorial.visible = new_value

func set_kill_tip(new_value):
	kill_tipe.visible = new_value

func set_capture_tip(new_value):
	capture_tip.visible = new_value