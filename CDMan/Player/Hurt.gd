class_name HurtState
extends State


func _ready() -> void:
	set_physics_process(false)

#without call deffered all of the functions in here will not run
func _enter_state() -> void:
	set_physics_process(true)
	print("slide_state")

	
func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	pass
