extends RigidBody2D

@export var animator: AnimatedSprite2D
@export var direction = Vector2.RIGHT
@export var speed = 300
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator.play("spin")
	linear_velocity.x = direction.x * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	linear_velocity.x += -direction.x * speed * delta
	
	
	if linear_velocity.x > 0:
		animator.flip_h = 0
	else:
		animator.flip_h = 1 

	if Input.is_action_pressed("move_up"):
		pass
