extends RigidBody3D


#axis lock is how oyu make 2d games in 3d by locking the axis you can move in

#basis.y is local up wich means local to the player, which means where ever the top of the player is is up
#global up is up from the whole world and local_up is up from the top of the object

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		apply_central_force(basis.y * delta * 1000)
		
	if Input.is_action_pressed("ui_left"):
		apply_torque(Vector3(0.0, 0.0, 100.00 * delta))
		
	if Input.is_action_pressed("ui_right"):
		apply_torque(Vector3(0.0, 0.0, -100.00 * delta))
