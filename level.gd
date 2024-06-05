extends Node3D

var globals
var time = 0
var score = 0

func _ready():
	globals = get_node("/root/Globals")
	globals.load_game()
	$lblTime.text = "Time: " + str(time) + "    Best: " + str(globals.ts[get_meta("Level")]["Time"])
	$lblScore.text = "Best: " + str(globals.ts[get_meta("Level")]["Score"]) + "    Score: " + str(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction = Input.get_vector("Move_Left","Move_Right","Move_Up","Move_Down")

	# rotate the ground around the ball
	$Ground.global_translate (-$Ball.global_position)
	if direction == Vector2.ZERO:
		# not intentionally moving anywhere, reset the ground to 0
		var rot = (-$Ground.rotation_degrees.x) / 10
		if rot : $Ground.transform = $Ground.transform.rotated( Vector3(1, 0, 0), deg_to_rad( rot ) )
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
		$Ball.freeze = true
		$Timer.start()
		if globals.ts[get_meta("Level")]["Time"] == 0 or globals.ts[get_meta("Level")]["Time"] > time: globals.ts[get_meta("Level")]["Time"] = time
		if globals.ts[get_meta("Level")]["Score"] < score: globals.ts[get_meta("Level")]["Score"] = score
		globals.save_game()

func _on_timer_timeout():
	get_tree().change_scene_to_file(get_meta("NextLevel"))


func _on_area_3d_area_entered(area):
	if area.is_in_group("collectables"):
		score += 1
		$lblScore.text = "Best: " + str(globals.ts[get_meta("Level")]["Score"]) + "    Score: " + str(score)
		area.queue_free()


func _on_play_time_timer_timeout():
	if globals != null:
		time += 1
		$lblTime.text = "Time: " + str(time) + "    Best: " + str(globals.ts[get_meta("Level")]["Time"])



func _on_murder_death_kill_body_entered(body):
	if body is RigidBody3D:
		get_tree().reload_current_scene()
