class_name MoveState
extends State

@export var actor: CharacterBody2D
@export var animator: AnimationTree
@export var dashTimer: Timer 
@export var runTimer: Timer
#bools
var hasDoubleJump: bool = false
var jumpTerminationMultiplier = 3

#state change signals
signal rolling_start
signal attack_start
signal air_attack

func _ready():
	set_physics_process(false)
	
func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta):
	#reset attack bools
	actor.attackQueued = false
	actor.animationFinished = true
	actor.isAttacking = false
	actor.hitBoxCollision.disabled = true
	
	var inputVector = actor.get_input_vector()
	actor.running(inputVector, delta)
	actor.velocity.x = clamp(actor.velocity.x, -actor.MAX_SPEED, actor.MAX_SPEED)
	#JUMPING
	handle_jump(inputVector)
	handle_descent(delta)
	#ROLL STATE SWITCH
	handle_roll_state_switch()
	run_stop_animation()
	#ATTACK STATE SWITCH
	hand_attack_state_switch()
	
func handle_jump(inputVector):
	if (inputVector.y < 0 && (actor.is_on_floor() || hasDoubleJump)):
		actor.velocity.y = inputVector.y * actor.JUMP_POWER
		animator.set("parameters/in_air/transition_request", "jumping")
		if (!actor.is_on_floor()):
			hasDoubleJump = false
	if (actor.is_on_floor()):
		hasDoubleJump = true

func handle_descent(delta):
	if (actor.velocity.y < 0 && !Input.is_action_pressed("jump")):
		actor.velocity.y += actor.GRAVITY * jumpTerminationMultiplier * delta
	if (actor.velocity.y > 0):
		animator.set("parameters/in_air/transition_request", "falling")
	animator.set("parameters/in_air_state/transition_request", !actor.is_on_floor())

func handle_roll_state_switch():
	if (Input.is_action_just_pressed("roll") && actor.is_on_floor() && !actor.isRolling):
		dashTimer.start()
		actor.isRolling = true
		rolling_start.emit()
		
func run_stop_animation():
	if (Input.is_action_just_pressed("move_left") || Input.is_action_just_pressed("move_right")):
		runTimer.start()
	if (runTimer.time_left > 0.1 && runTimer.time_left < 0.2):
		animator.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	elif (Input.is_action_just_released("move_left") || Input.is_action_just_released("move_right")):
		runTimer.stop()
		if (runTimer.time_left > 0.2):
			animator.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

func hand_attack_state_switch():
	if (Input.is_action_just_pressed("attack") && actor.is_on_floor() && !actor.isAttacking):
		animator.set("parameters/movement/transition_request", "attack")
		animator.set("parameters/combo/transition_request", "attackOne")
		attack_start.emit()
		actor.attackQueued = false
		actor.animationFinished = false
		actor.isAttacking = true
	elif (Input.is_action_just_pressed("attack") && !actor.is_on_floor() && !actor.isAttacking):
#		animator.set("parameters/in_air/transition_request", "airAttack")
		air_attack.emit()
		actor.attackQueued = false
		actor.animationFinished = false
		actor.isAttacking = true
