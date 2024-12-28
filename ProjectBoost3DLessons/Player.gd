extends RigidBody3D



#basis y is whatever direction is up on the object, the direction the top of the object is

func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * 1000)
	
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, 100.0 * delta))
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -100.0 * delta))


func _on_body_entered(body: Node) -> void:
#	print(body.name)
	if "Goal" in body.get_groups():
		print("Landed safely!")
	if "Basic_Ground" in body.get_groups():
		print("CRASH!!!")
