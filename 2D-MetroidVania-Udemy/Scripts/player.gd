extends CharacterBody2D

enum PlayerStates {MOVE, SWORD, HURT}
var CurrentState = PlayerStates.MOVE

var speed: float = 200.0
var gravity = 20
var pressed = 1
#@export var ACCELERATION = 2000
@export var JUMP_SPEED = 400
@export var FRICTION = 1500
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

func _physics_process(delta):
	
	match CurrentState:
		PlayerStates.MOVE:
			move(delta)
		PlayerStates.SWORD:
			sword()
	handle_gravity()
	up_direction = Vector2.UP
	move_and_slide()
	
func move(delta):
	var move_vector = get_movement_vector()
	if move_vector.x != 0:
		if move_vector.x > 0:
			velocity.x += speed * delta
			velocity.x = clamp(speed, 100, speed)
			sprite.flip_h = false
			anim.play("Walk")
			$SwordHitbox/CollisionShape2D.position = Vector2(25, 0)
			
		if move_vector.x < 0:
			velocity.x -= speed * delta
			velocity.x = clamp(speed, -100, -speed)
			sprite.flip_h = true
			anim.play("Walk")
			$SwordHitbox/CollisionShape2D.position = Vector2(-25, 0)
			
	elif move_vector.x == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		anim.play("Idle")
	jump()
	if Input.is_action_just_pressed("attack"):
		CurrentState = PlayerStates.SWORD
		
func handle_gravity():
	if not is_on_floor():
		velocity.y += gravity
	
func get_movement_vector():
	var move_vector = Vector2.ZERO
	move_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	return move_vector

func jump():
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		velocity.y -= JUMP_SPEED
	
	if !is_on_floor() && Input.is_action_just_pressed("jump") && pressed >= 1:
		velocity.y = 0
		velocity.y -= JUMP_SPEED
		
	if Input.is_action_just_pressed("jump"):
		pressed -= 1
		
	if pressed <= 0:
		velocity.y = velocity.y
	
	if is_on_floor():
		pressed = 1
	
	if velocity.y != 0:
		if velocity.y < 0:
			anim.play("Jump")
		elif velocity.y > 10 && !is_on_floor():
			anim.play("Fall")
			
func sword():
	velocity.x = 0
	anim.play("Sword")
	
func OnStateFinished():
	CurrentState = PlayerStates.MOVE
