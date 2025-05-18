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

var destination_position = Vector2.ZERO
#STATE VARIABLES
var currentState
#using this boolean allows functions in states to be called for one frame
var isStateNew = true

func _ready() -> void:
	currentState = State.IDLE
	bodyAni.play("Idle")
	forkAni.play("ForkLiftLowered")
	destination_position = global_position
	destination_position.x = global_position.x - 60.0
	print(destination_position)
	
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
	moveTimer.paused = false
	moveTimer.timeout.connect(random_action.bind(delta))
	#if moveTimer.timeout:
		#print("please work")

func process_attack(delta):
	moveTimer.paused = true
	pass

func changeDirection():
	bodyAni.play("MainBodyRotate")
	forkAni.play("ForkRotate")

#func _on_move_timer_timeout() -> void:
	#random_action())
	#print("timer out")
	
	
func random_action(delta):
	#var act_number = round(rng.randf_range(1, 10))
	var act_number = 6.0
	
	if (act_number >= 6.0):
		velocity.x = signf(faceVector.x) * 30
	elif(act_number <= 5.0):
		changeDirection()
	

func flip():
	for i in sprites.size():
		sprites[i].flip_h = false if sprites[i].flip_h == true else true
		sprites[i].position.x = 11 if sprites[i].flip_h == true else -10
		enemy_hit_box.position.x = 39 if sprites[i].flip_h == true else 0
		#print("goooooo")f
	if (faceVector == Vector2.LEFT):
		faceVector = Vector2.RIGHT
	else:
		faceVector = Vector2.LEFT
	destination_position.x = -1 * destination_position.x
