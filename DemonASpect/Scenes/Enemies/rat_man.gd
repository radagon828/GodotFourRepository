extends CharacterBody2D

const max_speed = 125
const gravity = 300

enum {
	IDLE,
	CHASE,
	ATTACK,
	HURT
}

var state = IDLE

@onready var playerDetectionZone = $PlayerDetectionZone
@onready var stats = $Stats
@onready var animationPlayer = $AnimationPlayer

func _ready():
	velocity = velocity
	set_velocity(velocity)
	$EnemyHurtbox.area_entered.connect(on_hurtbox_entered)

func _physics_process(delta):
	match state:
		IDLE:
			idle_state(delta)
		CHASE:
			pass
		ATTACK:
			pass
		HURT:
			pass

func idle_state(delta):
	animationPlayer.play("idle")

func on_hurtbox_entered(area: Area2D):
	stats.health -= 1

func move():
	set_up_direction(Vector2.UP)
	move_and_slide()

func _on_stats_no_health():
	queue_free()
