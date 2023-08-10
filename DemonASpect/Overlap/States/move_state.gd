class_name MoveState
extends State

@export var actor: Player
@export var animator: AnimationTree

#bools
var hasDoubleJump: bool = false
var jumpTerminationMultiplier = 3

func _ready() -> void:
	animator.active = true

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta):
	var inputVector = actor.get_input_vector()
	
	#RUNNING
	running(inputVector, delta)
	actor.velocity.x = clamp(actor.velocity.x, -actor.MAX_SPEED, actor.MAX_SPEED)

	#JUMPING
	if (inputVector.y < 0 && (actor.is_on_floor() || hasDoubleJump)):
		actor.velocity.y = inputVector.y * actor.JUMP_POWER
		animator.set("parameters/in_air/transition_request", "jumping")
		if (!actor.is_on_floor()):
			hasDoubleJump = false

	if (actor.velocity.y < 0 && !Input.is_action_pressed("jump")):
		actor.velocity.y += actor.GRAVITY * jumpTerminationMultiplier * delta

	if (actor.is_on_floor()):
		hasDoubleJump = true

	if (actor.velocity.y > 0):
		animator.set("parameters/in_air/transition_request", "falling")

	animator.set("parameters/in_air_state/transition_request", !actor.is_on_floor())

	#ROLL STATE SWITCH
#	if (Input.is_action_just_pressed("roll") && is_on_floor()):
#		dashTimer.start()
#		isRolling = true
#		state = ROLL
#
#	#processing for run stop animation
#	if (Input.is_action_just_pressed("move_left") || Input.is_action_just_pressed("move_right")):
#		runTimer.start()
#
#	if (runTimer.time_left > 0.1 && runTimer.time_left < 0.2):
#		$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
#	elif (Input.is_action_just_released("move_left") || Input.is_action_just_released("move_right")):
#		runTimer.stop()
#		if (runTimer.time_left > 0.2):
#			$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
#
#	#ATTACK STATE SWITCH
#	if (Input.is_action_just_pressed("attack") && is_on_floor() && !isAttacking):
#		$AnimationTree.set("parameters/movement/transition_request", "attack")
#		$AnimationTree.set("parameters/combo/transition_request", "attackOne")
#		state = ATTACKONE
#		attackQueued = false
#		animationFinished = false
#		isAttacking = true
#	elif (Input.is_action_just_pressed("attack") && !is_on_floor() && !isAttacking):
#		$AnimationTree.set("parameters/in_air/transition_request", "airAttack")
#		state = AIRATTACK
#		attackQueued = false
#		animationFinished = false
#		isAttacking = true
		
func running(inputVector, delta):
	if (inputVector.x != 0):
#		roll_vector.x = inputVector.x
		actor.velocity.x += inputVector.x * actor.ACCELERATION * delta
		animator.set("parameters/movement/transition_request", "run")
	elif inputVector.x == 0:
		animator.set("parameters/movement/transition_request", "idle")
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.FRICTION * delta)
