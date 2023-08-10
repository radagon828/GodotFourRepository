class_name RollState
extends State

@export var actor: CharacterBody2D
@export var animator: AnimationTree
@export var dashTimer: Timer

signal roll_finished

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta):
	animator.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	animator.set("parameters/movement/transition_request", "roll")
	if (dashTimer.time_left > 0.1):
		actor.velocity.x = actor.roll_vector.x * actor.ROLL_SPEED
	actor.velocity.x = lerp(0.0, actor.velocity.x, pow(2, -8 * delta))
	
func on_roll_finished():
	roll_finished.emit()
