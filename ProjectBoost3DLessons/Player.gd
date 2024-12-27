extends RigidBody3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		apply_central_force(Vector3.UP * delta * 1000)
	
	if Input.is_action_pressed("ui_left"):
#		apply_torque()
		pass
	if Input.is_action_pressed("ui_right"):
		rotate_z(-delta)
