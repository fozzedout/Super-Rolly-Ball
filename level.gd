extends Node3D

var globals
var time : float = 0
var stars : int = 0
var doTimer : bool = false

func _ready():
	globals = get_node("/root/Globals")
	globals.load_game()
	time = globals.ts[get_meta("Level")]["Par"]
	$Ball.freeze = true

	AudioServer.set_bus_volume_db(globals.bus_index, linear_to_db(globals.ts["Volume"]))

func _physics_process(delta):
	if doTimer: time -= delta
		
	if time <= 0 and $TimerReload.is_stopped():
		time = 0
		goal_screen("TIME UP!")

	$Hud/lblTime.text = "Time: %0.2f" % time
	$Hud/lblDonuts.text = "Stars: " + str(stars)

	var direction = Input.get_vector("Move_Left","Move_Right","Move_Up","Move_Down")
	
	$Ground.global_translate (-$Ball.global_position)
	
	if direction == Vector2.ZERO:
		$Ground.transform = $Ground.transform.rotated( Vector3(1, 0, 0), deg_to_rad( (-$Ground.rotation_degrees.x) / 10 ) )
		$Ground.transform = $Ground.transform.rotated( Vector3(0, 0, 1), deg_to_rad( (-$Ground.rotation_degrees.z) / 10 ) )
	else:
		if (direction.y < 0 and $Ground.rotation_degrees.x - 0.1 > -10) or (direction.y > 0 and $Ground.rotation_degrees.x + 0.1 < 10):
			$Ground.transform = $Ground.transform.rotated( Vector3(direction.y, 0, 0).normalized(), 0.01 * abs(direction.y) )
		if (direction.x > 0 and $Ground.rotation_degrees.z - 0.1 > -10) or (direction.x < 0 and $Ground.rotation_degrees.z + 0.1 < 10):
			$Ground.transform = $Ground.transform.rotated( Vector3(0, 0, direction.x).normalized(), -0.01 * abs(direction.x) )

	$Ground.global_translate ($Ball.global_position)

	$CameraPivot.global_position = $Ball.global_position
	$CameraPivot/Camera3D.look_at($Ball.global_position)

func _on_goal_body_entered(body):
	if body is RigidBody3D: goal_screen("GOAL!")


func _on_area_3d_area_entered(star):
	if star.is_in_group("collectables"):
		$Audio/Collected.pitch_scale = randf_range(0.8,1.2); $Audio/Collected.play()
		stars += 1
		star.queue_free()



func _on_murder_death_kill_body_entered(_body):
	goal_screen("FALL OUT!")

func _on_timer_timeout():
	get_tree().reload_current_scene()

func goal_screen(title):
	$Ball.freeze = true; doTimer = false
	$lblLevelResult.text = title; $lblLevelResult.show()
	if title == "GOAL!" and $Ground/Collectables.get_child_count() == 0: $lblLevelResult.text = "PERFECT!"
	match $lblLevelResult.text:
		"GOAL!": $Audio/HitPortal.play(); $Audio/Goal.play()
		"PERFECT!" : $Audio/HitPortal.play(); $Audio/Perfect.play()
		"FALL OUT!" : $Audio/FallOut.play()
		"TIME UP!" : $Audio/TimeUp.play()

	if title == "GOAL!":
		var score = round(time * 100 * max(1, (stars * (1 if $Ground/Collectables.get_child_count() > 0 else 10)) ))
		$GoalScreen.show()
		$GoalScreen/lblClearScore.text = "Clear Score: %8d" % (time * 100)
		$GoalScreen/lblDonutBonus.text = ("Star Bonus      x%d" % (stars * (1 if $Ground/Collectables.get_child_count() > 0 else 10))) if stars >= 2 else ""
		$GoalScreen/lblLevelScore.text = "Level Score: %8d" % score
		$GoalScreen/btnNextLevel.grab_focus()
		if globals.ts[get_meta("Level")]["Time"] < time: globals.ts[get_meta("Level")]["Time"] = time
		if globals.ts[get_meta("Level")]["Score"] < score: globals.ts[get_meta("Level")]["Score"] = score
		globals.save_game()

	else: $TimerReload.start()


func _on_timer_start_timeout():
	$Ball.freeze = false; doTimer = true
	$lblLevelResult.text = "START!"
