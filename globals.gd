extends Node

var ts = { "Volume" : 0, "Level01" : {"Time" : 0, "Par" : 20, "Score" : 0}, "Level02" : {"Time" : 0, "Par" : 50, "Score" : 0}, "Level03" : {"Time" : 0, "Par" : 50, "Score" : 0} }
var bus_index : int = AudioServer.get_bus_index("Master")

func save_game():
	FileAccess.open("user://savegame.save", FileAccess.WRITE).store_line(JSON.stringify(ts))

func load_game():
	if !OS.has_feature("editor"):
		if not FileAccess.file_exists("user://savegame.save"): return # Error! We don't have a save to load.
		ts = JSON.parse_string(FileAccess.open("user://savegame.save", FileAccess.READ).get_line())

func _on_pressed(extra_arg_0):
	get_tree().change_scene_to_file(extra_arg_0)
