extends CharacterBody2D

const maxSpeed = 55
const gravity = 500
const FRICTION = 200

enum {
	IDLE,
	CHASE,
	ATTACK,
	HURT
}

var state = IDLE
var knockback = Vector2.RIGHT

@onready var playerDetectionZone = $PlayerDetectionZone
@onready var stats = $Stats
@onready var animationPlayer = $AnimationPlayer
@onready var ratSprite = $Sprite2D
@onready var hurtTimer = $Timer

func _ready():
	velocity = velocity
	set_velocity(velocity)
	$EnemyHurtbox.area_entered.connect(on_hurtbox_entered)

func _physics_process(delta: float):
	match state:
		IDLE:
			idle_state(delta)
			seek_player()
		CHASE:
			chase_state(delta)
		ATTACK:
			attack_state(delta)
		HURT:
			hurt_state(delta)
	move()
	update_sprite()
	velocity.y += gravity * delta

func idle_state(delta):
	animationPlayer.play("idle")
	velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func chase_state(delta):
	var player = playerDetectionZone.player
	if player != null:
		accelerate_towards_point(player.global_position, delta)
	else:
		state = IDLE

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	var distance = point.x - global_position.x
	animationPlayer.play("chase")
	print(distance)
	velocity.x = velocity.move_toward(direction * maxSpeed, 300 * delta).x
	
	if (abs(distance) <= 20):
		state = ATTACK

func attack_state(delta):
	velocity.x = 0
	animationPlayer.play("jumpattack")
		
func _on_animation_player_animation_finished(jumpattack):
	state = IDLE

func hurt_state(delta):
	animationPlayer.play("hurt")
	velocity.x = lerp(0.0, velocity.x, pow(2, -16 * delta))
	if (hurtTimer.time_left < 0.1): 
		state = IDLE

func on_hurtbox_entered(area: Area2D):
	hurtTimer.start()
	velocity = Vector2.ZERO
	knockback = area.knockback_vector * 60
	velocity += knockback
	stats.health -= 1
	state = HURT

func update_sprite():
	if (velocity.x != 0):
		ratSprite.flip_h = true if velocity.x < 0 else false

func move():
	set_up_direction(Vector2.UP)
	move_and_slide()

func _on_stats_no_health():
	queue_free()





