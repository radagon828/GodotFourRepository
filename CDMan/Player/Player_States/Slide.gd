class_name SlideState
extends State

@export var slide_speed = 500
var minDashSpeed = 100

@export var actor: CharacterBody2D
@export var fsm: FiniteStateMachine
@onready var base_state = $"../Base" as BaseState

signal slide_end

func _ready() -> void:
	set_physics_process(false)

#without call deffered all of the functions in here will not run
func _enter_state() -> void:
	set_physics_process(true)
	print("slide_state")
	actor.animator.set("parameters/bodyState/transition_request", "slide")
	actor.velocity.x = slide_speed * actor.face_vector.x 
	
func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:

	actor.velocity.x = lerp(0.0, actor.velocity.x, pow(2, -8 * delta))
	if (abs(actor.velocity.x) < minDashSpeed):
		fsm.call_deferred("change_state", base_state)


