extends CharacterBody2D

@export var movement_data : PlayerMovementData

@export var animPlayer: AnimationPlayer
@export var sprite2d : Sprite2D
@export var coyote_timer: Timer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var air_jump = false
var just_wall_jumped = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	print(coyote_timer.time_left)
	apply_gravity(delta)
	#this needs to be order of functions>>>>
	handle_wall_jump()
	handle_jump()
	#<<<<<<
	var input_axis = Input.get_axis("ui_left", "ui_right")
	handle_acceleration(input_axis, delta)
	handle_air_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	update_animations(input_axis)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_timer.start()
	just_wall_jumped = false
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta
		
func handle_jump():
	if is_on_floor(): air_jump = true
		
	if is_on_floor() or coyote_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = movement_data.jump_velocity
	if not is_on_floor():
		if Input.is_action_just_released("ui_up") and velocity.y < movement_data.jump_velocity / 2:
			velocity.y = movement_data.jump_velocity / 2
			
		if Input.is_action_just_pressed("ui_up") and air_jump and not just_wall_jumped:
			velocity.y = movement_data.jump_velocity * 0.8
			air_jump = false

func handle_wall_jump():
	if not is_on_wall_only(): return
	var wall_normal = get_wall_normal()
	if Input.is_action_just_pressed("ui_up"):
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jump_velocity
		just_wall_jumped = true
#	if Input.is_action_just_pressed("ui_left") and wall_normal == Vector2.LEFT:
#		velocity.x = wall_normal.x * movement_data.speed
#		velocity.y = movement_data.jump_velocity
#	if Input.is_action_just_pressed("ui_right") and wall_normal == Vector2.RIGHT:
#		velocity.x = wall_normal.x * movement_data.speed
#		velocity.y = movement_data.jump_velocity
	

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func apply_air_resistance(input_axis, delta):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)

func handle_acceleration(input_axis, delta):
	if not is_on_floor(): return
	if input_axis:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta)
	
func update_animations(input_axis):
	if input_axis != 0:
		sprite2d.flip_h = (input_axis < 0)
		animPlayer.play("Run")
	else:
		animPlayer.play("Idle")
		
	if not is_on_floor():
		animPlayer.play("Jump")
		
		
