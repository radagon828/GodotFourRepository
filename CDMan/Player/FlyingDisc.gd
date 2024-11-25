extends RigidBody2D

enum State {OUTWARD, RETURN}

@export var animator: AnimatedSprite2D
@export var direction = Vector2.RIGHT
var returnDir = Vector2.ZERO
@export var speed = 400
@onready var playerMarker = $"../CDMan/PlayerMarker"

#STATE VARIABLES
var currentState = State.OUTWARD
#using this boolean allows functions in states to be called for one frame
var isStateNew = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator.play("spin")
	linear_velocity.x = direction.x * speed
	
func _physics_process(delta: float) -> void:
	match currentState:
		State.OUTWARD:
			process_outward(delta)
		State.RETURN:
			process_return(delta)

	isStateNew = false

	if linear_velocity.x > 0:
		animator.flip_h = 0
	else:
		animator.flip_h = 1 

func change_state(newstate):
	currentState = newstate
	isStateNew = true
	
func process_outward(delta):
	returnDir = playerMarker.global_position - position
	linear_velocity += returnDir * .2
	
#	if abs(linear_velocity.x) < 10:
#		call_deferred("change_state", State.RETURN)
		
	if Input.is_action_pressed("move_up"):
#		linear_velocity += Vector2.UP * 2
		pass

func process_return(delta):
#	returnDir = playerMarker.global_position - position
#	linear_velocity += direction * 1
	print(position)
