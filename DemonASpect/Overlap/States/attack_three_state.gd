class_name AttackThreeState
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
	animator.set("parameters/combo/transition_request", "attackFinish")
	actor.velocity.x += 7 * actor.roll_vector.x
	actor.velocity.x = lerp(0.0, actor.velocity.x, pow(2, -16 * delta))
#	print("final")

	if (actor.animationFinished):
#		print("done")
		actor.on_attack_finished()
