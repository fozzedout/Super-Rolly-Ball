extends Node

var ts = { "Volume" : 0, 
"Level01" : {"Time" : 0, "Par" : 30, "Score" : 0}, 
"Level02" : {"Time" : 0, "Par" : 50, "Score" : 0}, 
"Level03" : {"Time" : 0, "Par" : 60, "Score" : 0}, 
"Level04" : {"Time" : 0, "Par" : 60, "Score" : 0}, 
"Level05" : {"Time" : 0, "Par" : 50, "Score" : 0}, 
"Level06" : {"Time" : 0, "Par" : 90, "Score" : 0}, 
"Level07" : {"Time" : 0, "Par" : 30, "Score" : 0}, 
"Level08" : {"Time" : 0, "Par" : 60, "Score" : 0}, 
"Level09" : {"Time" : 0, "Par" : 60, "Score" : 0}, 
"Level10" : {"Time" : 0, "Par" : 150, "Score" : 0}, 
"Level11" : {"Time" : 0, "Par" : 70, "Score" : 0}, 
"Level12" : {"Time" : 0, "Par" : 100, "Score" : 0}, 
"Level13" : {"Time" : 0, "Par" : 50, "Score" : 0}, 
"Level14" : {"Time" : 0, "Par" : 150, "Score" : 0}, 
"Level15" : {"Time" : 0, "Par" : 70, "Score" : 0}, 
"Level16" : {"Time" : 0, "Par" : 60, "Score" : 0}, 
"Level17" : {"Time" : 0, "Par" : 60, "Score" : 0}, 
"Level18" : {"Time" : 0, "Par" : 60, "Score" : 0}, 
"Level19" : {"Time" : 0, "Par" : 60, "Score" : 0}, 
"Level20" : {"Time" : 0, "Par" : 60, "Score" : 0} }
var bus_index : int = AudioServer.get_bus_index("Master")

func save_game():
	FileAccess.open("user://savegame.save", FileAccess.WRITE).store_line(JSON.stringify(ts))

func load_game():
	if !OS.has_feature("editor"):
		if not FileAccess.file_exists("user://savegame.save"): return # Error! We don't have a save to load.
		ts = JSON.parse_string(FileAccess.open("user://savegame.save", FileAccess.READ).get_line())

func _on_pressed(extra_arg_0):
	get_tree().change_scene_to_file(extra_arg_0)
