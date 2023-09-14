extends CharacterBody2D

var speed: float = 200.0
var gravity = 20
var pressed = 2
#@export var ACCELERATION = 2000
@export var JUMP_SPEED = 400
@export var FRICTION = 1500
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

func _physics_process(delta):
	move(delta)
	move_and_slide()
	velocity.y += gravity
	up_direction = Vector2.UP

func move(delta):
	var move_vector = get_movement_vector()
	print(velocity.y)
	if move_vector.x != 0:
		if move_vector.x > 0:
			velocity.x += speed * delta
			velocity.x = clamp(speed, 100, speed)
			sprite.flip_h = false
			anim.play("Walk")
		if move_vector.x < 0:
			velocity.x -= speed * delta
			velocity.x = clamp(speed, -100, -speed)
			sprite.flip_h = true
			anim.play("Walk")
	elif move_vector.x == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		anim.play("Idle")
	jump()
	
	
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
		pressed = 2
	
	if velocity.y != 0:
		if velocity.y < 0:
			anim.play("Jump")
		elif velocity.y > 10 && !is_on_floor():
			anim.play("Fall")

