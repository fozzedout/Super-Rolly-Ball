extends Node2D
var globals
func _ready():
	globals = get_node("/root/Globals")
	globals.load_game()
	$btnStart.grab_focus()
	$audio_volume.value = globals.ts["Volume"]
func _on_audio_volume_value_changed(value):
	AudioServer.set_bus_volume_db(globals.bus_index, linear_to_db(value))
	globals.ts["Volume"] = value
	globals.save_game()
