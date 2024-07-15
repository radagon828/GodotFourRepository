extends CharacterBody2D

class_name Player

signal healthChanged

@export var speed: int = 50
@export var animationPLayer: AnimationPlayer
@onready var effects = $Effects
@onready var hurtTimer = $hurtTimer

@onready var hurtColor = $Sprite2D/ColorRect
@export var maxHealth = 3
#making this onready solved the problem of the 
#export variable not determaning max health
@onready var currentHealth: int = maxHealth

@export var knockbackPower: int = 500

var isHurt: bool = false
var enemyCollisions = []

func _ready():
	effects.play("RESET")

func handleInput():
	var moveDirection = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = moveDirection * speed
	
#changes animation based on player movement direction
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

#detects collision between interactable objects
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print(collider.name)

#calls functions
func _physics_process(delta):
	handleInput()
	move_and_slide()
	handleCollision()
	updateAnimation()
	if !isHurt:
		for enemyArea in enemyCollisions:
			hurtByEnemy(enemyArea)
	
#decreases health when contact with a hitbox occurs by emiting a signal to the world node
#makesplayer invincible for the duration of hurtTimer
func hurtByEnemy(area):
	currentHealth -= 1
	if currentHealth < 0 :
		currentHealth = maxHealth
			
	healthChanged.emit(currentHealth)
	isHurt = true
		
	knockback(area.get_parent().velocity)
	effects.play("hurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt = false
	
#adds enemy hurbox to an array that will be used 
#to check if they player is still in it after invincability ends
func _on_hurtbox_area_entered(area):
	if area.name == "hitbox":
		enemyCollisions.append(area)
		
func knockback(enemyVelocity):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	print_debug(velocity)
	print_debug(position)
	print_debug(" ")
	move_and_slide()

#stops enemy hurtbox from hurting player once they leave it
func _on_hurtbox_area_exited(area):
	enemyCollisions.erase(area)
