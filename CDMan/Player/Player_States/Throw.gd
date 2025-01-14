class_name ThrowState
extends State

@export var actor: CharacterBody2D
@export var fsm: FiniteStateMachine

@export var throw_timer: Timer
@export var shoot_timer: Timer
@onready var disc_object: PackedScene = preload("res://Player/flying_disc.tscn")

@onready var base_state = $"../Base" as BaseState

signal throw_end

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

	actor.animator.set("parameters/discs_held/transition_request", actor.discs_held)
	actor.animator.set("parameters/isThrowing2/transition_request", "true")
	actor.animator.set("parameters/isThrowing/transition_request", "true")
	throw_timer.start()
	shoot_timer.start()
	if actor.discs_held == 2:
		pass
		if actor.face_vector.x > 0:
			actor.animator.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		else:
			actor.animator.set("parameters/OneShot2/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	elif actor.discs_held == 1:
		if actor.face_vector.x > 0:
			actor.animator.set("parameters/OneShot3/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		else:
			actor.animator.set("parameters/OneShot4/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			

func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	#GRAVITY
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	#get direction held and set face_vector
	actor.direction = get_input_vector()
	if actor.direction.x:
		actor.velocity.x = actor.direction.x * actor.SPEED
		actor.face_vector.x = actor.direction.x
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	#animations
	actor.animate_legs()
	actor.handle_jump()
	actor.flip()


func shoot():
	#create object
	var shot = disc_object.instantiate()
	#set direction of object
	shot.direction = actor.face_vector
	#make position of player the position of the disc
	shot.transform = actor.global_transform
	#move object in front of player
	shot.position += Vector2(shot.direction.x * 14, -4)
	#add object to scene
	get_tree().current_scene.call_deferred("add_child", shot)
	$"../../DiscShootSounds".play()
	actor.discs_held -= 1


func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	return input_vector
	

func _on_shoot_timer_timeout() -> void:
	shoot()

func _on_throw_timer_timeout() -> void:
	fsm.call_deferred("change_state", base_state)
	actor.animator.set("parameters/isThrowing2/transition_request", "false")
	actor.animator.set("parameters/isThrowing/transition_request", "false")
