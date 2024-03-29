extends CharacterBody2D

var direction = Vector2.RIGHT
var maxSpeed = 55
var gravity = 500

enum {
	IDLE,
	CHASE,
	HURT
}
var state = IDLE
#combat
var healthMeter = null
var knockback = Vector2.RIGHT

@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
func _ready():
	velocity = velocity
	set_velocity(velocity)
	$EnemyHurtbox.area_entered.connect(on_hurtbox_entered)
	$AnimatedSprite2D.play("Idle")
	
	
func move():
	set_up_direction(Vector2.UP)
	move_and_slide()
	
func _physics_process(delta):
	match state:
		IDLE:
			velocity.x = maxSpeed * delta
			idle_state(delta)
			seek_player()
		CHASE:
			chase_state(delta)
			
		HURT:
			hurt_state(delta)
	move()
	
func idle_state(delta):
	velocity.y += gravity * delta
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	velocity.x = knockback.x

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	var distance = point.x - global_position.x
	print(distance)
	velocity.x = velocity.move_toward(direction * maxSpeed, 300 * delta).x

func seek_player():
	if playerDetectionZone.can_see_player():
#		state = CHASE
		pass

func chase_state(delta):
	var player = playerDetectionZone.player
	if player != null:
		accelerate_towards_point(player.global_position, delta)
	else:
		state = IDLE

func on_hurtbox_entered(area: Area2D):
	knockback = area.knockback_vector * 60
	velocity += knockback
	print("I'm HIT")
	stats.health -= 1

func hurt_state(delta):
	pass

func _on_stats_no_health():
	queue_free()
