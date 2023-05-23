extends CharacterBody2D
class_name Player

@export var GRAVITY = 900
@export var JUMP_POWER = 300
@export var ACCELERATION = 2000
@export var MAX_SPEED = 140
@export var ROLL_SPEED = 180
@export var FRICTION = 700

enum {
	MOVE,
	ROLL,
	ATTACKONE,
	ATTACKTWO,
	ATTACKTHREE,
	AIRATTACK,
	HURT
}

var state = MOVE
var roll_vector = Vector2.RIGHT
var jumpTerminationMultiplier = 3
var knockback = Vector2.RIGHT

#BOOLS
var hasDoubleJump = false
var isAttacking = false
var isRolling = false

@export var attackQueued = false
@export var cancelable = false
@export var animationFinished = false
# velcoity is a predefined variable in godot 4
@onready var animationPlayer = $PlayerAnimations
@onready var animationTree = $AnimationTree
@onready var playerSprite = $PlayerSprite
@onready var leafSprite = $LeafSprite
@onready var airLeafSprite = $AirAttackSprite
@onready var dashTimer = $Timers/DashTimer
@onready var runTimer = $Timers/RunTimer
@onready var testTimer = $Timers/TestTimer
@onready var hitBox = $Hitboxes/AttackOneHit
@onready var stats = $Stats

func _ready() -> void:
	animationTree.active = true
	velocity = velocity
	set_velocity(velocity)
	airLeafSprite.frame = 0
	$HurtBox.area_entered.connect(on_hurtbox_entered)
#	Engine.time_scale = 0.2
	
func _physics_process(delta: float):
	match state:
		MOVE:
			move_state(delta)
			cancelable = false
			isAttacking = false
			isRolling = false
			$Hitboxes/AttackOneHit/CollisionShape2D.disabled = true
		ROLL:
			roll_state(delta)
		ATTACKONE:
			attack_one_state(delta)
		ATTACKTWO:
			attack_two_state(delta)
		ATTACKTHREE:
			attack_three_state(delta)
		AIRATTACK:
			air_attack_state(delta)
		HURT:
			hurt_state(delta)
	velocity.y += GRAVITY * delta
	debug()
	move()
	$AnimationTree.set("parameters/is_hurt/transition_request", state == HURT)

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
	
	if (is_on_floor()):
		hasDoubleJump = true
		
	if (velocity.y > 0):
		$AnimationTree.set("parameters/in_air/transition_request", "falling")

	$AnimationTree.set("parameters/in_air_state/transition_request", !is_on_floor())
	
	#ROLL STATE SWITCH
	if (Input.is_action_just_pressed("roll") && is_on_floor()):
		dashTimer.start()
		isRolling = true
		state = ROLL
	
	#processing for run stop animation
	if (Input.is_action_just_pressed("move_left") || Input.is_action_just_pressed("move_right")):
		runTimer.start()
	
	if (runTimer.time_left > 0.1 && runTimer.time_left < 0.2):
		$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	elif (Input.is_action_just_released("move_left") || Input.is_action_just_released("move_right")):
		runTimer.stop()
		if (runTimer.time_left > 0.2):
			$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	
	#ATTACK STATE SWITCH
	if (Input.is_action_just_pressed("attack") && is_on_floor() && !isAttacking):
		$AnimationTree.set("parameters/movement/transition_request", "attack")
		$AnimationTree.set("parameters/combo/transition_request", "attackOne")
		state = ATTACKONE
		attackQueued = false
		animationFinished = false
		isAttacking = true
	elif (Input.is_action_just_pressed("attack") && !is_on_floor() && !isAttacking):
		$AnimationTree.set("parameters/in_air/transition_request", "airAttack")
		state = AIRATTACK
		attackQueued = false
		animationFinished = false
		isAttacking = true
		
	
	update_sprite()

func running(inputVector, delta):
	if (inputVector.x != 0):
		roll_vector.x = inputVector.x
		velocity.x += inputVector.x * ACCELERATION * delta
		$AnimationTree.set("parameters/movement/transition_request", "run")
	elif inputVector.x == 0:
		$AnimationTree.set("parameters/movement/transition_request", "idle")
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func air_attack_state(delta):
	var inputVector = get_input_vector()
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	running(inputVector, delta)
	
	if (animationFinished || is_on_floor()):
		on_attack_finished()

func attack_one_state(delta):
	velocity.x = lerp(0.0, velocity.x, pow(2, -8 * delta))

	if(cancelable && Input.is_action_just_pressed("attack")):
		attackQueued = true
#		print("attack queued")
		
	if (attackQueued && animationFinished):
		attackQueued = false
		animationFinished = false
		state = ATTACKTWO
#		print("combo")
	
	if (!attackQueued && animationFinished):
#		print("done")
		on_attack_finished()
	
func attack_two_state(delta):
	$AnimationTree.set("parameters/combo/transition_request", "attackTwo")
	velocity.x = lerp(0.0, velocity.x, pow(2, -8 * delta))
#	print("success")
	if(cancelable && Input.is_action_just_pressed("attack")):
		attackQueued = true
#		print("attack queued")

	if (attackQueued && animationFinished):
		attackQueued = false
		animationFinished = false
		state = ATTACKTHREE
#		print("combo")

	if (!attackQueued && animationFinished):
#		print("done")
		on_attack_finished()

func attack_three_state(delta):
	$AnimationTree.set("parameters/combo/transition_request", "attackFinish")
	velocity.x += 7 * roll_vector.x
	velocity.x = lerp(0.0, velocity.x, pow(2, -16 * delta))
#	print("final")

	if (animationFinished):
#		print("done")
		on_attack_finished()

func on_attack_finished():
	$AnimationTree.set("parameters/movement/transition_request", "idle")
	velocity.x = 0
	isAttacking = false
	cancelable = false
	state = MOVE

#NEXT--maybe cancel roll animation with runn or attack input 3/17/2023
func roll_state(delta):
	$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	$AnimationTree.set("parameters/movement/transition_request", "roll")
	if (dashTimer.time_left > 0.1):
		velocity.x = roll_vector.x * ROLL_SPEED
#	velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	velocity.x = lerp(0.0, velocity.x, pow(2, -8 * delta))
	
func on_roll_finished():
	isRolling = false
	state = MOVE

	
func move():
	set_up_direction(Vector2.UP)
	move_and_slide()

func on_hurtbox_entered(area: Area2D):
	testTimer.start()
	velocity = Vector2.ZERO
	knockback = area.knockback_vector * 120
	velocity += knockback
	stats.health -= 1
	state = HURT

func hurt_state(delta):
	if testTimer.time_left < 0.1:
		state = MOVE
	velocity.x = lerp(0.0, velocity.x, pow(2, -8 * delta))

func _on_stats_no_health():
	queue_free()

func update_sprite():
	var moveVec = get_input_vector()
	if (moveVec.x != 0):
		playerSprite.flip_h = true if moveVec.x < 0 else false
		if moveVec.x < 0:
			leafSprite.flip_h = true 
			airLeafSprite.flip_h = true
			leafSprite.position.x = -24
			airLeafSprite.position.x = -29
			hitBox.position.x = -32
		else: 
			leafSprite.flip_h = false
			airLeafSprite.flip_h = false
			leafSprite.position.x = 24
			airLeafSprite.position.x = 29
			hitBox.position.x = 32

func debug():
	pass
#	print($AnimationTree.get("parameters/movement/current_state"))
#	print(!$RayCast2D.is_colliding())
#	print(dashTimer.time_left, "         ", runTimer.time_left)
#	print(is_on_floor())

	



