extends State

@export var actor: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	
func _exit_state() -> void:
	set_physics_process(false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#GRAVITY
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta
	
	actor.direction = get_input_vector()
	if actor.direction.x:
		actor.velocity.x = actor.direction.x * actor.SPEED
		actor.face_vector.x = actor.direction.x
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)
		
#	if (Input.is_action_just_pressed("slide")) && is_on_floor():
#		call_deferred("change_state", State.SLIDE)
#
#	if Input.is_action_just_released("attack") && discs_held:
#		call_deferred("change_state", State.THROW)
	#ANIMATIONS
	actor.animator.set("parameters/bodyState/transition_request", "move")
	actor.animate_torso()
	actor.animate_legs()
	actor.handle_jump()
	actor.flip()
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	return input_vector
	
