extends KinematicBody2D

#movement
var maxSpeed = 25
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 500
var startDirection = Vector2.RIGHT
#combat
var health = 1
var maxHealth = 1
var healthMeter = null

#must establish health and damage values as floats
func _ready() -> void:
	healthMeter = get_node("GenericHealthBar/ProgressBar")
	$GenericHealthBar.visible = false
	health = float(3)
	maxHealth = float(3)
	direction = startDirection
	$EnemyHitbox.connect("area_entered", self, "on_hitbox_entered")

func _process(delta):
#	velocity.x = (direction * maxSpeed).x

	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	$AnimatedSprite.flip_h = true if direction.x > 0 else false
	
	if ($Timer.is_stopped()):
		$GenericHealthBar.visible = false
	else:
		$GenericHealthBar.visible = true
		
	healthMeter.value = (health / maxHealth) * 100
#	BUG TESTING PRINTS
#	print((health / maxHealth), "\n", (health / maxHealth) * 100)
#	print(health, "  ", maxHealth)
#	print("", $Timer.wait_time, "")
	
func on_hitbox_entered(area2d):
	$Timer.wait_time = 1.5
	$Timer.start()
	health -= 1
	if (health < 1):
		call_deferred("death")

func death():
	queue_free()
