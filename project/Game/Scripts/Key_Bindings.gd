extends Node2D

func get_key_binding_pin():
	return OS.get_scancode_string(InputMap.get_action_list("CHORD")[0].scancode)

func get_key_binding_boost():
	return OS.get_scancode_string(InputMap.get_action_list("BOOST")[0].scancode)
