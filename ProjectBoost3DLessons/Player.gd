extends RigidBody3D

@export_range(750.0, 3000.0) var thrust: float = 1000.0

@export_range(50.0, 300.0) var torque_thrust: float = 100 

#basis y is whatever direction is up on the object, the direction the top of the object is
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
	
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))

#the landing pad has the file inside of it. attaching scenes to 
func _on_body_entered(body: Node) -> void:
#	print(body.name)
	if "Goal" in body.get_groups():
		complete_level(body.file_path)
		print("Landed Safely!")
	
	if "Basic_Ground" in body.get_groups():
		print("CRASH!!!")
		crash_sequence()
		
func crash_sequence() -> void:
	get_tree().reload_current_scene()
	
func complete_level(next_level_file: String) -> void:
	get_tree().change_scene_to_file(next_level_file)
