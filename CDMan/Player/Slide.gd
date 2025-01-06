extends State


func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	
func _exit_state() -> void:
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
#	if (isStateNew):
#		animator.set("parameters/bodyState/transition_request", "slide")
#		velocity.x = slide_speed * face_vector.x 
#	velocity.x = lerp(0.0, velocity.x, pow(2, -8 * delta))
#	if (abs(velocity.x) < minDashSpeed):
#		call_deferred("change_state", State.BASE)
	pass
