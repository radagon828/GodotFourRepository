class_name AttackTwoState
extends State

@export var actor: CharacterBody2D
@export var animator: AnimationTree

signal third_attack

func _ready():
	set_physics_process(false)
	
func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	animator.set("parameters/combo/transition_request", "attackTwo")
	actor.velocity.x = lerp(0.0, actor.velocity.x, pow(2, -8 * delta))
#	print("success")
	if(actor.cancelable && Input.is_action_just_pressed("attack")):
		actor.attackQueued = true
#		print("attack queued")

	if (actor.attackQueued && actor.animationFinished):
		actor.attackQueued = false
		actor.animationFinished = false
		third_attack.emit()
#		print("combo")

	if (!actor.attackQueued && actor.animationFinished):
#		print("done")
		actor.on_attack_finished()
