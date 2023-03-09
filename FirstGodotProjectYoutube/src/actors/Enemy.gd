extends "res://src/actors/Actor.gd"
class_name Enemy

func _ready() -> void:
	#will become true when enemy is visible due to visibility enabler 2d
	set_physics_process(false)
	_velocity.x = -speed.x

	
func _physics_process(delta: float) -> void: 
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
		#this some how resets the velocity.x value to zero 
		#so for move_and_slide we have to only assign the y axis or seomthing
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	
func kill():
	queue_free()



