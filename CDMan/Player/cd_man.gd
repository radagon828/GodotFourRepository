extends CharacterBody2D

#MOVEMENT VALUES
const SPEED = 150.0
const JUMP_VELOCITY = -200.0
var gravity = 500
var direction = Vector2(0, 0)
#face vector saves direction while direction always changes based on input
var face_vector = Vector2.RIGHT

#ANIMATION NODES
var sprites: Array[Node] 
@export var animator: AnimationTree
@export var discAnimator: AnimationPlayer
@export var discAnimator2: AnimationPlayer
# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var aniTree = $Animations/AnimationTree

#DISC VARIABLES
@export var discs_held = 2
#represents the discs in their respective hands
var rBool
var lBool
#to manipulate the visibility of sprites
@onready var right_disc = $Sprites/DiscManDISCS
@onready var left_disc = $Sprites/DiscManDISCS2
@onready var disc_object: PackedScene = preload("res://Player/flying_disc.tscn")

#STATE VARIABLES
#var currentState = State.BASE
#using this boolean allows functions in states to be called for one frame
@export var fsm: FiniteStateMachine
@onready var base_state = $FiniteStateMachine/Base as BaseState
@onready var throw_state = $FiniteStateMachine/Throw as ThrowState
@onready var slide_state = $FiniteStateMachine/Slide as SlideState


func _ready() -> void:
	sprites.append_array($Sprites.get_children())
	#these assignments make certain the animation player doesn't default 
	#these values to the wrong ones
	#may assign these values to the level manager in the way future
	left_disc.visible = 1
	right_disc.visible = 1
	rBool = right_disc.visible 
	lBool = left_disc.visible
	right_disc.modulate = Color(1,1,1,1)
	left_disc.modulate = Color(1,1,1,1)
	
	#SIGNAL CONNECTIONS
	
	
func _physics_process(delta):
	showDiscsHeld()
	move_and_slide()

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


func disc_teleport(rVisible, lVisible):
	discs_held += 1
	if !rVisible: 
		discAnimator2.play("Disc1TeleportRecovery")
#		print("recovery")
	if !lVisible:
		discAnimator.play("Disc2TeleportRecovery")
#		print("recovery2")

#	discAnimator.seek(.25)
#	if discAnimator.is_playing():
#		print("playing")

#SIGNAL FUNCTIONS
func _on_player_hurt_box_area_entered(area: Area2D) -> void:
	if area.name == "DiscHitBox": 
		discs_held += 1
		area.get_parent().call_deferred("queue_free")

	
func debug():
	print("playing animation")
	pass

