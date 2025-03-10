extends CharacterBody2D

enum State {ATTACK, IDLE}


const SPEED = 50.0
const JUMP_VELOCITY = -400.0
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

#VECTOR
var faceVector = Vector2.LEFT
var startPosition = Vector2(0, 0)
var endPosition = Vector2(0, 0)
@export var endPoint: Marker2D

#ANIMATORS
@export var bodyAni: AnimationPlayer
@export var forkAni: AnimationPlayer
@export var moveTimer: Timer

#STATE VARIABLES
var currentState
#using this boolean allows functions in states to be called for one frame
var isStateNew = true


func _ready() -> void:
	currentState = State.IDLE
	startPosition = position
	endPosition = endPoint.global_position
	endPosition.y = position.y
	bodyAni.play("Idle")
	forkAni.play("ForkLiftLowered")
	

func _physics_process(delta: float) -> void:
	match currentState:
		State.ATTACK:
			process_attack(delta)
		State.IDLE:
			process_idle(delta)
	isStateNew = false
	velocity.y += gravity
	move_and_slide()
	
	
	if abs(velocity.x) > 0.0:
		bodyAni.play("Walking")
	else:
		bodyAni.play("Idle")
	
func change_state(newstate):
	currentState = newstate
	isStateNew = true

func process_idle(delta):
	var moveDirection = endPosition - position
	
#	print(moveDirection.length()) 
	if moveDirection.length() < 9.1:
		position.x = endPosition.x
		moveDirection = Vector2(0,0)
		call_deferred("changeDirection")
	velocity = SPEED * moveDirection.normalized() 
	
func changeDirection():
	velocity.x = 0
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd
	bodyAni.play("MainBodyRotate")
	forkAni.play("ForkRotate")
	
	print("WAHASTASDKA")
	
func process_attack(delta):
	pass
	



