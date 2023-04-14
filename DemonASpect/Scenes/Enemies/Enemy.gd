extends CharacterBody2D

var direction = Vector2.ZERO
var maxSpeed = 25
var gravity = 500
#combat
var health = 1
var maxHealth = 1
var healthMeter = null
var knockback = Vector2.ZERO
#var player =  "res://Scenes/Player/Player.gd"

func _ready():
	health = float(3)
	maxHealth = float(3)
	velocity = velocity
	set_velocity(velocity)
	$EnemyHurtbox.area_entered.connect(on_hitbox_entered)
	$AnimatedSprite2D.play("Idle")
	

func _physics_process(delta):
	velocity.y += gravity * delta

	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	move_and_slide()

func on_hitbox_entered(area: Area2D):
#	var knockback_vector =
#	knockback = area.knockback * 120
#	velocity = knockback
	print("I'm HIT")
	health -= 1
	if(health < 1):
		call_deferred("death")

func death():
	queue_free()
