extends RigidBody2D

enum State {OUTWARD, RETURN, HIT}

@export var animator: AnimatedSprite2D
@export var direction = Vector2.RIGHT
@export var speed = 500
@export var friction = 25
@onready var playerMarker = $"../CDMan/PlayerMarker"
@onready var thePlayer = $"../CDMan"

#STATE VARIABLES
var currentState
#using this boolean allows functions in states to be called for one frame
var isStateNew = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator.play("spin")
	linear_velocity.x = direction.x * speed
	currentState = State.OUTWARD
	
func _physics_process(delta: float) -> void:
	match currentState:
		State.OUTWARD:
			process_outward(delta)
		State.RETURN:
			process_return(delta)
		State.HIT:
			process_hit_return(delta)
	isStateNew = false
	if linear_velocity.x > 0:
		animator.flip_h = 0
	else:
		animator.flip_h = 1 

func change_state(newstate):
	currentState = newstate
	isStateNew = true
	print("changing state")
	
func process_outward(delta):
	linear_velocity.x += -direction.x * friction
	#to have a gradual slowdown to discs moving up and down
	linear_velocity.y = move_toward(linear_velocity.y , 0, 2)
	if abs(linear_velocity.x) < 10:
#		call_deferred("change_state", State.RETURN)
		pass

	if Input.is_action_pressed("move_up"):
		linear_velocity += Vector2.UP * 5
	elif Input.is_action_pressed("move_down"):
		linear_velocity += Vector2.DOWN * 5
		pass
		

func process_return(delta):
	direction = playerMarker.global_position - position
	linear_velocity += direction
	print("returning")

func process_hit_return(delta):
	print("cahnged")
	if isStateNew: linear_velocity = -direction * 2
	
	direction = playerMarker.global_position - position
	linear_velocity += direction

#disc returns to player upon hit, should change to upon enemy hit
func _on_disc_hit_box_body_entered(body: Node2D) -> void:
#	change_state(State.HIT)
	print("entered")

#disc timer
func _on_disc_timer_timeout() -> void:
	thePlayer.discs_held += 1
	call_deferred("queue_free")
