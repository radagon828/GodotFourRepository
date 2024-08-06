extends CharacterBody2D

class_name Player

signal healthChanged

@export var speed: int = 50
@export var animationPLayer: AnimationPlayer
@onready var effects = $Effects
@onready var hurtBox = $hurtbox
@onready var hurtTimer = $hurtTimer
@onready var weapon = $weapon

@export var maxHealth = 3
#making this onready solved the problem of the 
#export variable not determaning max health
@onready var currentHealth: int = maxHealth

@export var knockbackPower: int = 500

@export var inventory: Inventory

var lastAnimDirection: String = "Down"
var isHurt: bool = false
var isAttacking: bool = false

func _ready():
	effects.play("RESET")

func handleInput():
	var moveDirection = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = moveDirection * speed
	
	if Input.is_action_just_pressed("attack"):
		attack()

func attack():
	animationPLayer.play("attack" + lastAnimDirection)
	isAttacking = true
	weapon.enable()
	await animationPLayer.animation_finished
	isAttacking = false
	weapon.disable()
	
#changes animation based on player movement direction
func updateAnimation():
	if isAttacking : return
	
	if velocity.length() == 0:
		if animationPLayer.is_playing():
			animationPLayer.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
	
		animationPLayer.play("walk" + direction)
		lastAnimDirection = direction

#detects collision between interactable objects
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
#		print(collider.name)

#calls functions
func _physics_process(delta):
	handleInput()
	move_and_slide()
	handleCollision()
	updateAnimation()
	#checks if player is overlapping with enemy hurtbox and runs hurt by enemy function if so
	#if equals in this scenario
	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "hitbox":
				hurtByEnemy(area)
	
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

#uses items collect function to add item to inventory
func _on_hurtbox_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)
		
func knockback(enemyVelocity):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	print_debug(velocity)
	print_debug(position)
	print_debug(" ")
	move_and_slide()

func _on_hurtbox_area_exited(area): pass
