extends Node

var ts = {"Level01" : {"Time" : 0, "Score" : 0}, "Level02" : {"Time" : 0, "Score" : 0} }

func save_game():
	FileAccess.open("user://savegame.save", FileAccess.WRITE).store_line(JSON.stringify(ts))

func load_game():
	if not FileAccess.file_exists("user://savegame.save"): return # Error! We don't have a save to load.
	ts = JSON.parse_string(FileAccess.open("user://savegame.save", FileAccess.READ).get_line())
