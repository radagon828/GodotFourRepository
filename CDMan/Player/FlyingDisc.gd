extends RigidBody2D

@export var animator: AnimatedSprite2D
@export var direction = Vector2.RIGHT
@export var speed = 200
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
#		linear_velocity += Vector2.UP * 2
		pass
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	print("hello weath")
	print(area.name)
	if area.name == "PlayerHurtBox": 
		area.get_parent().discs_held += 1
		call_deferred("queue_free")
	
