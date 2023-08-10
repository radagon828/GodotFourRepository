class_name AirAttack
extends State

@export var actor: CharacterBody2D
@export var animator: AnimationTree

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	var inputVector = actor.get_input_vector()
	actor.velocity.x = clamp(actor.velocity.x, -actor.MAX_SPEED, actor.MAX_SPEED)
	actor.running(inputVector, delta)

	if (actor.animationFinished || actor.is_on_floor()):
		actor.on_attack_finished()
