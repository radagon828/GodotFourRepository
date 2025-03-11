class_name HurtState
extends State

@export var actor: CharacterBody2D
@export var hurt_timer: Timer
signal hurt_end

func _ready() -> void:
	set_physics_process(false)

#without call deffered all of the functions in here will not run
func _enter_state() -> void:
	set_physics_process(true)
	hurt_timer.start()
	actor.velocity.x = -actor.face_vector.x * 200
	actor.velocity.y -= 70 
	
func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta
	actor.velocity.x = move_toward(actor.velocity.x, 0, 10)
	actor.animator.set("parameters/bodyState/transition_request", "hurt")


func _on_hurt_timer_timeout() -> void:
	hurt_end.emit()
