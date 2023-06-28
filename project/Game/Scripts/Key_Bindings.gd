extends Node2D

onready var is_using_keyboard = true
onready var is_arrows_right = true

signal input_changed

func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	if Input.get_connected_joypads().size() >= 1:
		set_controller()

func set_controller():
	is_using_keyboard = false
	emit_signal("input_changed")

func set_keyboard():
	is_using_keyboard = true
	emit_signal("input_changed")

func set_keyboard_with_event(event):
	if event.is_action_pressed("LEFT") or event.is_action_pressed("RIGHT"):
		if event.scancode in [KEY_UP, KEY_DOWN, KEY_RIGHT, KEY_LEFT]:
			is_arrows_right = true
		else:
			is_arrows_right = false
	set_keyboard()
		
func _on_joy_connection_changed(device_id, connected):
	if connected:
		set_controller()
	else:
		set_keyboard()
		
func _input(event):
	if event is InputEventKey:
		set_keyboard_with_event(event)
	elif event is InputEventJoypadButton:
		set_controller()

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
	# Expected: Arrow right - Arrow left - Controller
	# OR
	# Keyboard - Controller
	var events = InputMap.get_action_list(event_name)
	
	if is_playing_with_keyboard():
		if is_using_arrows_right():
			return events[0]
		else:
			if events.size() == 3:
				return events[1] 
			return events[0]
	else:
		if events.size() == 3:
			return events[2] 
		return events[1]

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

func is_using_arrows_right():
	return is_arrows_right
