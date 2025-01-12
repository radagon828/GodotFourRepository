class_name ThrowState
extends State

@export var actor: CharacterBody2D
@export var fsm: FiniteStateMachine
@onready var base_state = $"../Base" as BaseState
func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	actor.animator.set("parameters/discs_held/transition_request", actor.discs_held)
	actor.animator.set("parameters/isThrowing2/transition_request", "true")
	actor.animator.set("parameters/isThrowing/transition_request", "true")
	actor.throwTimer.start()
	$"../../ShootTimer".start()
	if actor.discs_held == 2:
		pass
		if actor.face_vector.x > 0:
			actor.animator.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		else:
			actor.animator.set("parameters/OneShot2/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	elif actor.discs_held == 1:
		if actor.face_vector.x > 0:
			actor.animator.set("parameters/OneShot3/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		else:
			actor.animator.set("parameters/OneShot4/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	if actor.throwTimer.time_left < 0.2:
		fsm.call_deferred("change_state", base_state)
		actor.animator.set("parameters/isThrowing2/transition_request", "false")
		actor.animator.set("parameters/isThrowing/transition_request", "false")

	#GRAVITY
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	#get direction held and set face_vector
	actor.direction = get_input_vector()
	if actor.direction.x:
		actor.velocity.x = actor.direction.x * actor.SPEED
		actor.face_vector.x = actor.direction.x
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	#animations
	actor.animate_legs()
	actor.handle_jump()
	actor.flip()
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	return input_vector
	

