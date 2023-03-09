extends CharacterBody2D

@export var GRAVITY = 900
@export var JUMP_POWER = 300

@export var ACCELERATION = 2000
@export var MAX_SPEED = 140
@export var ROLL_SPEED = 125
@export var FRICTION = 500

var jumpTerminationMultiplier = 3
var hasDoubleJump = false
#i velcoity is a predefined variable in godot 4

@onready var animationPlayer = $AnimationPlayer
@onready var playerSprite = $PlayerSprite

func _ready() -> void:
	$AnimationTree.active = true
	velocity = velocity
	set_velocity(velocity)
#	Engine.time_scale = 0.5
	
func _physics_process(delta: float):
	var inputVector = get_input_vector()
	
	if (inputVector.x != 0):
		$AnimationTree.set("parameters/OneShot/request", "Fire")
		$AnimationTree.set("parameters/movement/transition_request", "run")
		velocity.x += inputVector.x * ACCELERATION * delta
	elif inputVector.x == 0:
		$AnimationTree.set("parameters/movement/transition_request", "idle")
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
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
	
	if (velocity.y > 0):
		$AnimationTree.set("parameters/in_air/transition_request", "falling")
#	else:
#		$AnimationTree.set("parameters/in_air/transition_request", "jumping")
	
	if (is_on_floor()):
		hasDoubleJump = true
		
	$AnimationTree.set("parameters/in_air_state/transition_request", !is_on_floor())
	
	
	set_up_direction(Vector2.UP)
	move_and_slide()
	update_animation()
	debug()
#	print(get_input_vector())

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return input_vector

func update_animation():
	var moveVec = get_input_vector()
	
	
#	if !is_on_floor() && velocity.y <= 0:
#		animationPlayer.play("JumpUp")
#	elif !is_on_floor() && velocity.y > 0:
#		animationPlayer.play("JumpDecent")
#	elif moveVec.x != 0 && is_on_floor():
#		if animationPlayer.current_animation != "Run":
#			animationPlayer.play("RunStartup")
#			animationPlayer.queue("Run")
#	elif moveVec.x == 0 && is_on_floor() && animationPlayer.current_animation == "Run":
#		animationPlayer.play("RunSlowdown")
#		animationPlayer.queue("Idle")
#	else:
#		animationPlayer.queue("Idle")

	if (moveVec.x != 0):
		playerSprite.flip_h = true if moveVec.x < 0 else false

func debug():
	pass
#	print(!$RayCast2D.is_colliding())
#	print(velocity)
#	print(is_on_floor())
#	print(animationPlayer.current_animation_position)
