extends CharacterBody2D

enum State {BASE, SLIDE, THROW, HURT}

const SPEED = 150.0
const JUMP_VELOCITY = -200.0
@export var slide_speed = 500
var minDashSpeed = 100
var gravity = 500

var direction = Vector2(0, 0)
var face_vector = Vector2.RIGHT
var sprites: Array[Node] 
@export var theTorso: AnimationPlayer
@export var theLegs: AnimationPlayer
@export var animator: AnimationTree
# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var aniTree = $Animations/AnimationTree

var currentState = State.BASE
#using this boolean allows functions in states to be called for one frame
var isStateNew = true

func _ready() -> void:
	sprites.append_array($Sprites.get_children())

func _physics_process(delta):
	match currentState:
		State.BASE:
			process_base(delta)
		State.SLIDE:
			process_slide(delta)
		State.THROW:
			process_throw(delta)
	isStateNew = false
	move_and_slide()
#	print(velocity.x)
	
func change_state(newstate):
	currentState = newstate
	isStateNew = true

func process_base(delta):
	#GRAVITY
	if not is_on_floor():
		velocity.y += gravity * delta
	
	direction = get_input_vector()
	if direction.x:
		velocity.x = direction.x * SPEED
		face_vector.x = direction.x
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if (Input.is_action_just_pressed("slide")) && is_on_floor():
		call_deferred("change_state", State.SLIDE)
		
	if Input.is_action_just_released("attack"):
		call_deferred("change_state", State.THROW)
	#ANIMATIONS
	animator.set("parameters/bodyState/transition_request", "move")
	animate_torso()
	animate_legs()
	handle_jump()
	flip()
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	return input_vector
	
func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
func animate_torso():
	animator.set("parameters/in_air_state2/transition_request", bool(!is_on_floor()))
	
	if direction.x != 0:
		animator.set("parameters/running2/transition_request", "true")
	elif direction.x == 0:
		animator.set("parameters/running2/transition_request", "false")
	if velocity.y != 0:
		if velocity.y > 0:
			animator.set("parameters/in_air2/transition_request", "falling")
		if velocity.y < 0:
			animator.set("parameters/in_air2/transition_request", "jumping")
		
func animate_legs():
	animator.set("parameters/in_air_state/transition_request", bool(!is_on_floor()))
	
	if direction.x != 0:
		animator.set("parameters/running/transition_request", "true")
	elif direction.x == 0:
		animator.set("parameters/running/transition_request", "false")
	if velocity.y != 0:
		if velocity.y > 0:
			animator.set("parameters/in_air/transition_request", "falling")
		if velocity.y < 0:
			animator.set("parameters/in_air/transition_request", "jumping")
		
func flip():
	if velocity.x != 0:
		for i in sprites.size():
			sprites[i].flip_h = !bool(sign(velocity.x) + 1)
		

func process_slide(delta):
	if (isStateNew):
		animator.set("parameters/bodyState/transition_request", "slide")
		velocity.x = slide_speed * face_vector.x 
	velocity.x = lerp(0.0, velocity.x, pow(2, -8 * delta))
	if (abs(velocity.x) < minDashSpeed):
		call_deferred("change_state", State.BASE)
		
func process_throw(delta):
	if (isStateNew):
		animator.set("parameters/isThrowing2/transition_request", "true")
		animator.set("parameters/isThrowing/transition_request", "true")
		
	if not is_on_floor():
		velocity.y += gravity * delta
	
	direction = get_input_vector()
	if direction.x:
		velocity.x = direction.x * SPEED
		face_vector.x = direction.x
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#animations
	animate_legs()
	handle_jump()
	flip()
	

