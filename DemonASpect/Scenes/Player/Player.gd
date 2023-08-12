extends CharacterBody2D

@export var GRAVITY = 900
@export var JUMP_POWER = 300
@export var ACCELERATION = 2000
@export var MAX_SPEED = 140
@export var ROLL_SPEED = 180
@export var FRICTION = 700

#var state = MOVE
var roll_vector = Vector2.RIGHT
#var jumpTerminationMultiplier = 3
var knockback = Vector2.RIGHT
		
#BOOLS
@export var isAttacking: bool = false
@export var isRolling: bool = false
@export var cancelable: bool = false

@export var attackQueued: bool = false
@export var animationFinished: bool = false

## velocity is a predefined variable in godot 4
@onready var animationTree: AnimationTree = $AnimationTree
@onready var playerSprite: Sprite2D = $PlayerSprite
@onready var leafSprite: Sprite2D = $LeafSprite
@onready var airLeafSprite: Sprite2D = $AirAttackSprite

@onready var testTimer: Timer = $Timers/TestTimer
@onready var hitBox: Area2D = $Hitboxes/AttackOneHit
@onready var stats: Node = $Stats

@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var move_state = $FiniteStateMachine/MoveState as MoveState
@onready var roll_state = $FiniteStateMachine/RollState as RollState
@onready var hurt_state = $FiniteStateMachine/HurtState as HurtState
@onready var attack_one_state = $FiniteStateMachine/AttackOneState as AttackOneState
@onready var attack_two_state = $FiniteStateMachine/AttackTwoState as AttackTwoState
@onready var attack_three_state = $FiniteStateMachine/AttackThreeState as AttackThreeState
@onready var air_attack = $FiniteStateMachine/AirAttack as AirAttack


func _ready() -> void:
#	animationTree.active = true
	velocity = velocity
	set_velocity(velocity)
	airLeafSprite.frame = 0
	move_state.rolling_start.connect(fsm.change_state.bind(roll_state))
	move_state.attack_start.connect(fsm.change_state.bind(attack_one_state))
	move_state.air_attack.connect(fsm.change_state.bind(air_attack))
	hurt_state.recovery.connect(fsm.change_state.bind(move_state))
	attack_one_state.second_attack.connect(fsm.change_state.bind(attack_two_state))
	attack_two_state.third_attack.connect(fsm.change_state.bind(attack_three_state))
	$HurtBox.area_entered.connect(on_hurtbox_entered)#	Engine.time_scale = 0.2
	
func _physics_process(delta: float):
	velocity.y += GRAVITY * delta
	debug()
	move()
	update_sprite()
#	$AnimationTree.set("parameters/is_hurt/transition_request", state == HURT)

func get_input_vector():
	var input_vector = Vector2.ZERO
#	roll_vector.x = input_vector.x
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return input_vector

func running(inputVector, delta):
	if (inputVector.x != 0):
		roll_vector.x = inputVector.x
		velocity.x += inputVector.x * ACCELERATION * delta
		$AnimationTree.set("parameters/movement/transition_request", "run")
	elif inputVector.x == 0:
		$AnimationTree.set("parameters/movement/transition_request", "idle")
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func on_attack_finished():
	$AnimationTree.set("parameters/movement/transition_request", "idle")
	velocity.x = 0
	isAttacking = false
	cancelable = false
	fsm.change_state(move_state)

func on_roll_finished():
	$AnimationTree.set("parameters/movement/transition_request", "idle")
	isRolling = false
	fsm.change_state(move_state)

func move():
	set_up_direction(Vector2.UP)
	move_and_slide()
#
func on_hurtbox_entered(area: Area2D):
	testTimer.start()
	velocity = Vector2.ZERO
	knockback = area.knockback_vector * 120
	velocity += knockback
	stats.health -= 1
	fsm.change_state(hurt_state)

func _on_stats_no_health():
	queue_free()

func update_sprite():
	var moveVec = get_input_vector()
	airLeafSprite.visible == false if is_on_floor() else true 
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
#	print(animationFinished)
#	print(dash_timer.time_left)
#	print($AnimationTree.get("parameters/movement/current_state"))
#	print(Input.is_action_just_pressed("attack"))
#	print(!$RayCast2D.is_colliding())
#	print(dashTimer.time_left, "         ", runTimer.time_left)
#	print(is_on_floor())
