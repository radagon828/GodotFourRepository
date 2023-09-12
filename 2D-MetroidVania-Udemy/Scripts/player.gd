extends CharacterBody2D

var speed: float = 200.0
@export var ACCELERATION = 2000

func _physics_process(delta):
	var move_vector = get_movement_vector()
	print(velocity.x)
	if move_vector.x != 0:
		velocity.x += move_vector.x * delta * ACCELERATION
		velocity.x = clamp(velocity.x, -speed, speed)
	elif move_vector.x == 0:
		velocity.x = move_toward(velocity.x, 0, 700 * delta)
	move_and_slide()

func get_movement_vector():
	var move_vector = Vector2.ZERO
	move_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	return move_vector
