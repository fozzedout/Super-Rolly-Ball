extends Node2D

var globals

func _ready():
	globals = get_node("/root/Globals")
	globals.load_game()
	
	$btnStart.grab_focus()
	
	globals.bus_index = AudioServer.get_bus_index("Master")
	$audio_volume.value = globals.ts["Volume"]
	$btnAudio.button_pressed = not globals.ts["Muted"]


func _on_btn_audio_toggled(toggled_on):
	AudioServer.set_bus_mute(globals.bus_index, not toggled_on)
	globals.ts["Muted"] = not toggled_on
	globals.save_game()

func _on_audio_volume_value_changed(value):
	AudioServer.set_bus_volume_db(globals.bus_index, linear_to_db(value))
	globals.ts["Volume"] = value
	globals.save_game()

func _on_btn_start_pressed():
	get_tree().change_scene_to_file("res://Levels/Level01.tscn")


func _on_btn_level_select_pressed():
	get_tree().change_scene_to_file("res://Scenes/LevelSelection.tscn")
