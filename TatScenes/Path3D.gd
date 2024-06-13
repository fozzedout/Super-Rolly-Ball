extends Path3D

@export var move_speed = 0.00

func _physics_process(delta):
	$PathFollow3D.progress += move_speed*delta
