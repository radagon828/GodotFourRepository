extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL = Vector2.UP

# export key word allows value to be edited in inpector
export var speed = Vector2(300.0, 1000.0)
export var gravity = 4000.00
export var stomp_impulse = 1000.00
#: = is used to set the variable type but why?
var _velocity = Vector2.ZERO


	
#	_velocity.y = max(_velocity.y, speed.y)
	
