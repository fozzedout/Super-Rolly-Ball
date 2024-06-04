extends Node3D

var globals
var time = 0
var score = 0

func _ready():
	globals = get_node("/root/Globals")
	globals.load_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("Move_Left","Move_Right","Move_Up","Move_Down")
	if direction != Vector2.ZERO:
		$Ground.rotate(Vector3(direction.y, 0, direction.x).normalized(), rad_to_deg(0.0001) )

	$Node3D.global_position = Vector3 ( $Ball.global_position.x, $Ball.global_position.y + 25, $Ball.global_position.z + 50 )


func _on_goal_body_entered(body):
	if body is RigidBody3D:
		$Ball.freeze = true
		$Timer.start()
		if globals.ts[get_meta("Level")]["Time"] > time: globals.ts[get_meta("Level")]["Time"] = time
		if globals.ts[get_meta("Level")]["Score"] > score: globals.ts[get_meta("Level")]["Score"] = score
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
