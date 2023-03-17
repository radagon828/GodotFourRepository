extends CharacterBody2D

@export var GRAVITY = 900
@export var JUMP_POWER = 300
@export var ACCELERATION = 2000
@export var MAX_SPEED = 140
@export var ROLL_SPEED = 180
@export var FRICTION = 700

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var roll_vector = Vector2.RIGHT
var jumpTerminationMultiplier = 3

#BOOLS
var hasDoubleJump = false
# velcoity is a predefined variable in godot 4
@onready var animationPlayer = $AnimationPlayer
@onready var playerSprite = $PlayerSprite

func _ready() -> void:
	$AnimationTree.active = true
	velocity = velocity
	set_velocity(velocity)
#	Engine.time_scale = 0.2
	
func _physics_process(delta: float):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	debug()

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return input_vector

func move_state(delta):
	var inputVector = get_input_vector()
	
	#RUNNING
	running(inputVector, delta)
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	#JUMPING
	if (inputVector.y < 0 && (is_on_floor() || hasDoubleJump)):
		velocity.y = inputVector.y * JUMP_POWER
		$AnimationTree.set("parameters/in_air/transition_request", "jumping")
		if (!is_on_floor()):
			hasDoubleJump = false
	
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += GRAVITY * jumpTerminationMultiplier * delta
	else:
		velocity.y += GRAVITY * delta
	
	if (is_on_floor()):
		hasDoubleJump = true
		
	if (velocity.y > 0):
		$AnimationTree.set("parameters/in_air/transition_request", "falling")

	$AnimationTree.set("parameters/in_air_state/transition_request", !is_on_floor())
	
	#ROLL STATE SWITCH
	if (Input.is_action_just_pressed("roll") && is_on_floor()):
		$DashTimer.start()
		state = ROLL
	
	#processing for run stop animation
	if (Input.is_action_just_pressed("move_left") || Input.is_action_just_pressed("move_right")):
		$RunTimer.start()
	
	if ($RunTimer.time_left > 0.1 && $RunTimer.time_left < 0.2):
		$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	elif (Input.is_action_just_released("move_left") || Input.is_action_just_released("move_right")):
		$RunTimer.stop()
		if ($RunTimer.time_left > 0.2):
			$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	
	#ATTACK STATE SWITCH
	if (Input.is_action_just_pressed("attack") && is_on_floor()):
		state = ATTACK
		
	
	update_sprite()
	move()

func running(inputVector, delta):
	if (inputVector.x != 0):
		roll_vector.x = inputVector.x
		velocity.x += inputVector.x * ACCELERATION * delta
		$AnimationTree.set("parameters/movement/transition_request", "run")
	elif inputVector.x == 0:
		$AnimationTree.set("parameters/movement/transition_request", "idle")
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	

#NEXT--maybe cancel roll animation with runn or attack input
func roll_state(delta):
	$AnimationTree.set("parameters/movement/transition_request", "roll")
	if ($DashTimer.time_left > 0.1):
		velocity.x = roll_vector.x * ROLL_SPEED
#	velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	velocity.x = lerp(0.0, velocity.x, pow(2, -8 * delta))
	
	velocity.y += GRAVITY * delta
	move()
	
func on_roll_finished():
	state = MOVE
	$AnimationTree.set("parameters/movement/transistion_request", "idle")
#
func attack_state(delta):
	$AnimationTree.set("parameters/movement/transistion_request", "attack")
	print("hello i worked")
#	velocity.x = roll_vector.x * ROLL_SPEED

	velocity.y += GRAVITY * delta
	move()

#func on_attack_finished():
#	state = MOVE
#	$AnimationTree.set("parameters/movement/transistion_request", "idle")
	
func move():
	set_up_direction(Vector2.UP)
	move_and_slide()

func update_sprite():
	var moveVec = get_input_vector()
	if (moveVec.x != 0):
		playerSprite.flip_h = true if moveVec.x < 0 else false

func debug():
	pass
#	print(!$RayCast2D.is_colliding())
#	print(velocity, $DashTimer.time_left, "         ", $RunTimer.time_left)
#	print(is_on_floor())
	

	
