extends Node2D

var globals

func _ready():
	globals = get_node("/root/Globals")
	globals.load_game()
	AudioServer.set_bus_mute(globals.bus_index, globals.ts["Muted"])
	AudioServer.set_bus_volume_db(globals.bus_index, linear_to_db(globals.ts["Volume"]))
	$btnLevel01.grab_focus()

func _on_pressed(extra_arg_0):
	get_tree().change_scene_to_file(extra_arg_0)
