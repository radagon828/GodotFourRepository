extends CharacterBody2D

enum State {ATTACK, IDLE}

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var faceVector = Vector2.LEFT


@export var bodyAni: AnimationPlayer
@export var forkAni: AnimationPlayer
@export var moveTimer: Timer
#STATE VARIABLES
var currentState
#using this boolean allows functions in states to be called for one frame
var isStateNew = true


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	currentState = State.IDLE
	

func _physics_process(delta: float) -> void:
	match currentState:
		State.ATTACK:
			process_attack(delta)
		State.IDLE:
			process_idle(delta)
	isStateNew = false
	velocity.y += gravity
	move_and_slide()
	
func change_state(newstate):
	currentState = newstate
	isStateNew = true
	
func process_idle(delta):
	bodyAni.play("Idle")
	forkAni.play("ForkLiftLowered")
#	if 
#	velocity.x
	pass
	
func process_attack(delta):
	pass

	
func animate_fork():
	pass
func animate_body():
	pass
	
