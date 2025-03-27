extends CharacterBody2D

enum State {ATTACK, IDLE}


const SPEED = 50.0
const JUMP_VELOCITY = -400.0
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var rng = RandomNumberGenerator.new()

#VECTOR
var faceVector = Vector2.LEFT

@export var enemy_hit_box: Area2D

#ANIMATORS
@export var bodyAni: AnimationPlayer
@export var forkAni: AnimationPlayer
@export var moveTimer: Timer
@export var sprites: Array[Node] 

#STATE VARIABLES
var currentState
#using this boolean allows functions in states to be called for one frame
var isStateNew = true


func _ready() -> void:
	currentState = State.IDLE
#	startPosition = position
#	endPosition = endPoint.global_position
#	endPosition.y = position.y
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
	

	
func change_state(newstate):
	currentState = newstate
	isStateNew = true

func process_idle(delta):
	moveTimer.start()
	
	
	pass
#	var moveDirection = endPosition - position
	
##	print(moveDirection.length()) 
#	if moveDirection.length() < 9.1:
#		position.x = endPosition.x
#		moveDirection = Vector2(0,0)
#		call_deferred("changeDirection")
#	velocity = SPEED * moveDirection.normalized() 
	
func process_attack(delta):
	moveTimer.stop()
	pass

func changeDirection():

#	var tempEnd = endPosition
#	endPosition = startPosition
#	startPosition = tempEnd
	bodyAni.play("MainBodyRotate")
	forkAni.play("ForkRotate")


func _on_move_timer_timeout() -> void:
	random_action(round(rng.randf_range(1, 3)))
	
	
func random_action(act_number):
	print(act_number)
	changeDirection()

func flip():
	for i in sprites.size():
		sprites[i].flip_h = false if sprites[i].flip_h == true else true
		sprites[i].position.x = 11 if sprites[i].flip_h == true else -10
		enemy_hit_box.position.x = 39 if sprites[i].flip_h == true else 0
		print("goooooo")
