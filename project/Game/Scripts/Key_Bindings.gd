extends Node2D

onready var is_using_keyboard = true

signal input_changed

func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	if Input.get_connected_joypads().size() >= 1:
		SetController()

func SetController():
	is_using_keyboard = false
	emit_signal("input_changed")

func SetKeyboard():
	is_using_keyboard = true
	emit_signal("input_changed")
	
func _on_joy_connection_changed(device_id, connected):
	if connected:
		SetController()
	else:
		SetKeyboard()
		
func _input(event):
	if event is InputEventKey:
		SetKeyboard()
	elif event is InputEventJoypadButton:
		SetController()

func get_key_binding_pin():
	return get_printable_keycode(get_active_input_event("CHORD"))

func get_key_binding_boost():
	return get_printable_keycode(get_active_input_event("BOOST"))

func get_printable_keycode(event: InputEvent):
	if event is InputEventKey:
		return  OS.get_scancode_string(event.physical_scancode)
	if event is InputEventJoypadButton:
		return map_joystick_index_to_button(event.button_index)

func get_active_input_event(event_name):
	var events = InputMap.get_action_list(event_name)
	for event in events:
		if is_playing_with_keyboard() and event is InputEventKey:
			return event
		if !is_playing_with_keyboard() and event is InputEventJoypadButton:
			return event

func map_joystick_index_to_button(index):
	# TODO: This is only taking into account XBOX commands. Could be improved
	match(index):
		0:
			return "A"
		1:
			return "B"
		2:
			return "X"
		4:
			return "Y"
	
func is_playing_with_keyboard():
	return is_using_keyboard
