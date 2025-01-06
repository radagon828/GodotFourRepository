extends State

@export var actor: CharacterBody2D

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	
func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	if (actor.isStateNew):
		actor.animator.set("parameters/discs_held/transition_request", actor.discs_held)
		actor.animator.set("parameters/isThrowing2/transition_request", "true")
		actor.animator.set("parameters/isThrowing/transition_request", "true")
		actor.throwTimer.start()
		$ShootTimer.start()
		if actor.discs_held == 2:
#			if face_vector.x > 0:
#				animator.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
#			else:
#				animator.set("parameters/OneShot2/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
#		elif discs_held == 1:
#			if face_vector.x > 0:
#				animator.set("parameters/OneShot3/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
#			else:
#				animator.set("parameters/OneShot4/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
#
#	if throwTimer.time_left < 0.2:
#		call_deferred("change_state", State.BASE)
#		animator.set("parameters/isThrowing2/transition_request", "false")
#		animator.set("parameters/isThrowing/transition_request", "false")
#
#	#GRAVITY
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	#get direction held and set face_vector
#	direction = get_input_vector()
#	if direction.x:
#		velocity.x = direction.x * SPEED
#		face_vector.x = direction.x
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#
#	#animations
#	animate_legs()
#	handle_jump()
#	flip()
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	return input_vector
