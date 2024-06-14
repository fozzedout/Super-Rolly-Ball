extends Node2D
func _ready():
	var globals = get_node("/root/Globals")
	globals.load_game()
	AudioServer.set_bus_volume_db(globals.bus_index, linear_to_db(globals.ts["Volume"]))
	$btnLevel01.grab_focus()
