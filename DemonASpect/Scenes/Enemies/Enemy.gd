extends CharacterBody2D

var direction = Vector2.ZERO
var maxSpeed = 25
var gravity = 500

enum {
	IDLE,
	CHASE,
	HURT
}
var state = IDLE
#combat
var health = 1
var maxHealth = 1
var healthMeter = null
var knockback = Vector2.RIGHT

func _ready():
	health = float(30)
	maxHealth = float(3)
	velocity = velocity
	set_velocity(velocity)
	$EnemyHurtbox.area_entered.connect(on_hurtbox_entered)
	$AnimatedSprite2D.play("Idle")
	
func _physics_process(delta):
	match state:
		IDLE:
			idle_state(delta)
		CHASE:
			pass
		HURT:
			hurt_state(delta)

func idle_state(delta):
	velocity.y += gravity * delta
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	velocity.x = knockback.x
	move_and_slide()

func on_hurtbox_entered(area: Area2D):
	knockback = area.knockback_vector * 60
	velocity += knockback
	print("I'm HIT")
	health -= 1
	if(health < 1):
		call_deferred("death")

func hurt_state(delta):
	pass

func death():
	queue_free()
