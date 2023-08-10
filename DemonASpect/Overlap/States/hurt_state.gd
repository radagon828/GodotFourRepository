class_name HurtState
extends State

@export var hurtTimer: Timer
@export var actor: CharacterBody2D
@export var animator: AnimationTree

signal recovery

func _ready():
	set_physics_process(false)
	
func _enter_state() -> void:
	set_physics_process(true)
	animator.set("parameters/is_hurt/transition_request", true)
	
func _exit_state() -> void:
	set_physics_process(false)
	animator.set("parameters/is_hurt/transition_request", false)

func _physics_process(delta):
	if hurtTimer.time_left < 0.1:
		recovery.emit()
	actor.velocity.x = lerp(0.0, actor.velocity.x, pow(2, -8 * delta))

