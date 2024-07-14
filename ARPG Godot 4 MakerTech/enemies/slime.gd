extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5
@export var animationPLayer: AnimationPlayer
@export var endPoint: Marker2D

var startPosition
var endPosition

func _ready():
	startPosition = position
	endPosition = endPoint.global_position

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd
	
func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		position = endPosition
#		moveDirection = Vector2(0, 0)
		changeDirection()
	velocity = moveDirection.normalized() * speed
	
func updateAnimation():
	if velocity.length() == 0:
		if animationPLayer.is_playing():
			animationPLayer.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
	
		animationPLayer.play("walk" + direction)

func _physics_process(delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()
