extends KinematicBody2D

enum State { NORMAL, ATTACKING }

var gravity = 1000
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 140
var horizontalAcceleration = 2000
var jumpSpeed = 320 
var jumpTerminationMultiplier = 3
var currentState = State.NORMAL
var isStateNew = true

func _ready():
	pass
	
func _process(delta: float) -> void:
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.ATTACKING:
			process_attacking(delta)
	isStateNew = false

func change_state(newState):
	currentState = newState
	isStateNew = true

func process_normal(delta):
	var moveVector = get_movement_vector()
	
	velocity.x += moveVector.x * horizontalAcceleration * delta
	if (moveVector.x == 0):
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
		
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	if (moveVector.y < 0 && is_on_floor()):
		velocity.y = moveVector.y * jumpSpeed
		
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if (is_on_floor() && Input.is_action_just_pressed("attack")):
		call_deferred("change_state", State.ATTACKING)
	
	update_animation()
	update_hitboxs()

func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return moveVector
	
func process_attacking(delta):
	if (isStateNew):
		$AnimationPlayer.play("Slash")
	yield( get_node("AnimationPlayer"), "animation_finished")
	call_deferred("change_state", State.NORMAL)


func update_animation():
	var moveVec = get_movement_vector()
	
	if (!is_on_floor()):
		$AnimationPlayer.play("Bounce")
	elif (moveVec.x != 0):
		$AnimationPlayer.play("Run")
	else:
		$AnimationPlayer.play("Idle")
	
	if (moveVec.x != 0):
		$Sprite.flip_h = false if moveVec.x > 0 else true

func update_hitboxs():
	var moveVec = get_movement_vector()
	if (moveVec.x != 0):
		if (moveVec.x > 0):
			$CollisionShape2D.position.x = -0.5
			$SwordHit/CollisionShape2D.position.x = 8
		else:
			$CollisionShape2D.position.x = 0.5
			$SwordHit/CollisionShape2D.position.x = -8
