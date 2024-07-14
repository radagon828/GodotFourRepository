extends CharacterBody2D

class_name Player

signal healthChanged

@export var speed: int = 50
@export var animationPLayer: AnimationPlayer

@onready var hurtColor = $Sprite2D/ColorRect
@export var maxHealth = 3

@onready var currentHealth: int = maxHealth

func handleInput():
	var moveDirection = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = moveDirection * speed
	
func updateAnimation():
	if velocity.length() == 0:
		if animationPLayer.is_playing():
			animationPLayer.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
	
		animationPLayer.play("walk" + direction)
	
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print(collider.name)
	
func _physics_process(delta):
	handleInput()
	move_and_slide()
	handleCollision()
	updateAnimation()

func _on_hurtbox_area_entered(area):
	if area.name == "hitbox":
		currentHealth -= 1
		if currentHealth < 0 :
			currentHealth = maxHealth
		
		healthChanged.emit(currentHealth)
