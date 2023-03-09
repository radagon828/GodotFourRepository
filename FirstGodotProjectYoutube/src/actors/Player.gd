extends Actor


func _physics_process(delta: float) -> void:
	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	#up direction required for jumping
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
	enemy_collision()
#gets x and y value based on which direction is pressed
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)
# sets variables
func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out
#detect enemy combat
func enemy_collision():
	#Returns the number of times the body collided 
	#and changed direction during the last call to move_and_slide() 
	for i in get_slide_count():
		var collision := get_slide_collision(i)
		#gets colliding body
		var collider := collision.collider
		var is_stomping := (
			#by manually setting class name of the 
			#enemy script the below code will work
			collider is Enemy and
			is_on_floor() and
			#is_equal_approx is used because vectors are float values
			collision.normal.is_equal_approx(Vector2.UP)
		)
		
		if is_stomping:
			_velocity.y = -stomp_impulse
			(collider as Enemy).kill()
		#kills player if collision is not from above
		elif collider is Enemy and !collision.normal.is_equal_approx(Vector2.UP):
			queue_free()
