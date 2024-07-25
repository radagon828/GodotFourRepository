extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5
@export var animationPLayer: AnimationPlayer
@export var endPoint: Marker2D

var startPosition
var endPosition

#assigns current position as start point and marker2d as endpoint
func _ready():
	startPosition = position
	endPosition = endPoint.global_position

#changes end point to the starting point
func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

#makes move direction the direction of the end position and calls
#changeDirection if end point is reached
#determines speed of node as well
func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		position = endPosition
#		moveDirection = Vector2(0, 0)
		changeDirection()
	velocity = moveDirection.normalized() * speed
	
#changes animation based on direction of movement
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

#all physics processes
func _physics_process(delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()
