extends Node3D

var globals
var time : float = 0
var donuts : int = 0

func _ready():
	globals = get_node("/root/Globals")
	globals.load_game()
	$Hud/lblTime.text = "Time: " + str(globals.ts[get_meta("Level")]["Par"])
	$Hud/lblDonuts.text = "Donuts: " + str(donuts)

	AudioServer.set_bus_mute(globals.bus_index, globals.ts["Muted"])
	AudioServer.set_bus_volume_db(globals.bus_index, linear_to_db(globals.ts["Volume"]))

func _physics_process(delta):
	if not $lblLevelResult.visible:
		time += delta
		if globals != null:
			$Hud/lblTime.text = "Time: %0.2f" % (globals.ts[get_meta("Level")]["Par"] - time)
			#$Hud/lblTime.text = "Time: " + str(time) + "    Best: " + str(globals.ts[get_meta("Level")]["Time"])
		
	if time >= globals.ts[get_meta("Level")]["Par"] and $Timer.is_stopped():
		goal_screen("TIME UP!")

	var direction = Input.get_vector("Move_Left","Move_Right","Move_Up","Move_Down")
	
	# rotate the ground around the ball
	$Ground.global_translate (-$Ball.global_position)
	
	if direction == Vector2.ZERO:
		# not intentionally moving anywhere, reset the ground to 0
		var rot = (-$Ground.rotation_degrees.x) / 10
		if rot: $Ground.transform = $Ground.transform.rotated( Vector3(1, 0, 0), deg_to_rad( rot ) )
		if abs(rot) < 0.01: $Ground.rotation_degrees.x = 0
		
		rot = (-$Ground.rotation_degrees.z) / 10
		if rot : $Ground.transform = $Ground.transform.rotated( Vector3(0, 0, 1), deg_to_rad( rot ) )
		if abs(rot) < 0.01: $Ground.rotation_degrees.z = 0
	else:
		if (direction.y < 0 and $Ground.rotation_degrees.x - 0.1 > -10) or (direction.y > 0 and $Ground.rotation_degrees.x + 0.1 < 10):
			$Ground.transform = $Ground.transform.rotated( Vector3(direction.y, 0, 0).normalized(), 0.01 * abs(direction.y) )
		if (direction.x > 0 and $Ground.rotation_degrees.z - 0.1 > -10) or (direction.x < 0 and $Ground.rotation_degrees.z + 0.1 < 10):
			$Ground.transform = $Ground.transform.rotated( Vector3(0, 0, direction.x).normalized(), -0.01 * abs(direction.x) )

	$Ground.global_translate ($Ball.global_position)

	$CameraPivot.global_position = $Ball.global_position
	$CameraPivot/Camera3D.look_at($Ball.global_position)

func _on_goal_body_entered(body):
	if body is RigidBody3D:
		goal_screen("GOAL!")


func _on_area_3d_area_entered(area):
	if area.is_in_group("collectables"):
		$Collected.pitch_scale = randf_range(0.8,1.2); $Collected.play()
		donuts += 1
		$Hud/lblDonuts.text = "Donuts: " + str(donuts)
		area.queue_free()



func _on_murder_death_kill_body_entered(body):
	if body is RigidBody3D:
		goal_screen("FALL OUT!")


func _on_btn_next_level_pressed():
	get_tree().change_scene_to_file(get_meta("NextLevel"))

func _on_timer_timeout():
	get_tree().reload_current_scene()

func goal_screen(title):
	$Ball.freeze = true
	$lblLevelResult.text = title; $lblLevelResult.show()
	var score = round((globals.ts[get_meta("Level")]["Par"] - time) * 100 * max(1, (donuts * (1 if $Ground/Collectables.get_child_count() > 0 else 10)) ))
	if title == "GOAL!":
		$GoalScreen.show()
		if $Ground/Collectables.get_child_count() == 0: $lblLevelResult.text = "PERFECT!"
		$GoalScreen/lblClearScore.text = "Clear Score: %8d" % round((globals.ts[get_meta("Level")]["Par"] - time) * 100)
		if donuts >= 2: $GoalScreen/lblDonutBonus.text = "Donut Bonus      x%d" % (donuts * (1 if $Ground/Collectables.get_child_count() > 0 else 10))
		else: $GoalScreen/lblDonutBonus.text = ""
		$GoalScreen/lblLevelScore.text = "Level Score: %8d" % score
		$GoalScreen/btnNextLevel.grab_focus()
		if globals.ts[get_meta("Level")]["Time"] == 0 or globals.ts[get_meta("Level")]["Time"] > time: globals.ts[get_meta("Level")]["Time"] = time
		if globals.ts[get_meta("Level")]["Score"] < score: globals.ts[get_meta("Level")]["Score"] = score
		globals.save_game()

	else: $Timer.start()


func _on_btn_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
