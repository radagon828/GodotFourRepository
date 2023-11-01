extends CharacterBody2D

@export var speed: int = 35

@onready var animations: AnimationPlayer = $AnimationPlayer
var direction = "Down"

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection*speed

func updateAnimation():
	if velocity.length() != 0:
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
		elif velocity.y > 0: direction = "Down"
		animations.play("walk" + direction)
	else:
		animations.play("idle" + direction)

func _physics_process(delta):
	handleInput()
	updateAnimation()
	move_and_slide()
