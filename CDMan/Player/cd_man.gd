extends CharacterBody2D

enum State {BASE, SLIDE, THROW, HURT}

#MOVEMENT VALUES
const SPEED = 150.0
const JUMP_VELOCITY = -200.0
@export var slide_speed = 500
var minDashSpeed = 100
var gravity = 500
var direction = Vector2(0, 0)
#face vector saves direction while direction always changes based on input
var face_vector = Vector2.RIGHT

#ANIMATION NODES
var sprites: Array[Node] 
@export var animator: AnimationTree
# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var aniTree = $Animations/AnimationTree

#STATE VARIABLES
var currentState = State.BASE
#using this boolean allows functions in states to be called for one frame
var isStateNew = true

#DISC VARIABLES
@export var discs_held = 2
var rBool
var lBool
@onready var right_disc = $Sprites/DiscManDISCS
@onready var left_disc = $Sprites/DiscManDISCS2
@onready var throwTimer = $ThrowTimer
@export var disc_object : PackedScene


 
func _ready() -> void:
	sprites.append_array($Sprites.get_children())
	left_disc.visible = 1
	right_disc.visible = 1
	rBool = right_disc.visible 
	lBool = left_disc.visible
	Engine.set_time_scale(1)
	
func _physics_process(delta):
	match currentState:
		State.BASE:
			process_base(delta)
		State.SLIDE:
			process_slide(delta)
		State.THROW:
			process_throw(delta)
	isStateNew = false
	showDiscsHeld()
	move_and_slide()
	
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
		
	if Input.is_action_just_released("attack") && discs_held:
		call_deferred("change_state", State.THROW)
	#ANIMATIONS
	animator.set("parameters/bodyState/transition_request", "move")
	animate_torso()
	animate_legs()
	handle_jump()
	flip()
	
func process_slide(delta):
	if (isStateNew):
		animator.set("parameters/bodyState/transition_request", "slide")
		velocity.x = slide_speed * face_vector.x 
	velocity.x = lerp(0.0, velocity.x, pow(2, -8 * delta))
	if (abs(velocity.x) < minDashSpeed):
		call_deferred("change_state", State.BASE)

func process_throw(delta):
	if (isStateNew):
		animator.set("parameters/discs_held/transition_request", discs_held)
		animator.set("parameters/isThrowing2/transition_request", "true")
		animator.set("parameters/isThrowing/transition_request", "true")
		throwTimer.start()
		if discs_held == 2:
			if face_vector.x > 0:
				animator.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			else:
				animator.set("parameters/OneShot2/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		elif discs_held == 1:
			if face_vector.x > 0:
				animator.set("parameters/OneShot3/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			else:
				animator.set("parameters/OneShot4/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
	#GRAVITY
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#get direction held and set face_vector
	direction = get_input_vector()
	if direction.x:
		velocity.x = direction.x * SPEED
		face_vector.x = direction.x
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if throwTimer.time_left < 0.1:
		call_deferred("change_state", State.BASE)
		animator.set("parameters/isThrowing2/transition_request", "false")
		animator.set("parameters/isThrowing/transition_request", "false")
	#animations
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

func showDiscsHeld():
	if discs_held == 2:
		rBool = true
		lBool = true
	elif discs_held == 1:
		rBool = false
		lBool = true
	elif discs_held == 0:
		rBool = false
		lBool = false

func shoot():
	var shot = disc_object.instantiate()
	shot.direction = face_vector
	get_parent().add_child(shot)
	shot.transform = global_transform
	shot.position += Vector2(face_vector.x * 14, -4)
	discs_held -= 1
	

func flip():
	if velocity.x != 0:
		for i in sprites.size():
			#flips the sprites based on the velocity, sign turns current velocity into
			# a signal value, the plus 1 turns -1 into a false 0, the bool function turns 
			#0 into false and a positive number into true
			sprites[i].flip_h = !bool(sign(velocity.x) + 1)
		
	if face_vector.x < 0:
		#CHANGE POSITON TO CENTER SPRITES ON HURTBOX
		for i in sprites.size():
			sprites[i].position.x = 0
		right_disc.visible = lBool
		left_disc.visible = rBool  
		animator.set("parameters/facingRight/transition_request", "false")
		animator.set("parameters/facingRight2/transition_request", "false")
	else: 
		#CHANGE POSITON TO CENTER SPRITES ON HURTBOX
		for i in sprites.size():
			sprites[i].position.x = -1
		animator.set("parameters/facingRight/transition_request", "true")
		animator.set("parameters/facingRight2/transition_request", "true")
		right_disc.visible = rBool
		left_disc.visible = lBool 

func _on_player_hurt_box_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.name == "DiscHitBox": 
		discs_held += 1
		area.get_parent().call_deferred("queue_free")

