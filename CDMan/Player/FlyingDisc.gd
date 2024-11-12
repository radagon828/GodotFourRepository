extends RigidBody2D

@export var animator: AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator.play("Spin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		pass

