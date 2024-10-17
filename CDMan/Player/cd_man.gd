extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -200.0
var gravity = 500

@export var sprites: Array[Node] 
@export var theTorso: AnimationPlayer
@export var theLegs: AnimationPlayer
# Get the gravity from the project settings to be synced with RigidBody nodes.


func _ready() -> void:
	sprites.append_array($Sprites.get_children())

func _physics_process(delta):
	
	#GRAVITY
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var direction = get_input_vector()
	if direction.x:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	handle_jump()
	animate()
	flip()
	move_and_slide()
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	return input_vector
	
func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func animate():
	if is_on_floor() && velocity.x != 0:
		theTorso.play("runningTorso")
		theLegs.play("runningLegs")
	elif is_on_floor():
		theTorso.play("idleTorso")
		theLegs.play("idleLegs")
	elif not is_on_floor():
		theTorso.play("jumpTorso")
		theLegs.play("jumpLegs")
		
func flip():
	if velocity.x != 0:
		for i in sprites.size():
			sprites[i].flip_h = !bool(sign(velocity.x) + 1)

