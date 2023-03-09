extends KinematicBody2D

var motion = Vector2(0,0)

const SPEED = 1500
#gravity is 500 pixels per frame
const GRAVITY = 150
#define up direction
const UP = Vector2(0,-1)
const JUMP_SPEED = 3500
#WORLD_LIMIT is the y axis position that marks how far down you can go until you game over
const WORLD_LIMIT = 4000

signal animate

func _physics_process(delta):
	apply_gravity()
	jump()
	move()
	animate()
	move_and_slide(motion, UP)
	
func apply_gravity():
	if position.y > WORLD_LIMIT:
		end_game()
	if is_on_floor():
		motion.y = 0
	elif is_on_ceiling():
		motion.y = 1
	else:
		motion.y += GRAVITY

func jump():
	if Input.is_action_pressed("Jump") and is_on_floor():
		motion.y -= JUMP_SPEED

func move():
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		motion.x = -SPEED
	elif Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		motion.x = SPEED
	else:
		motion.x = 0
	
func animate():
	
	emit_signal("animate", motion)
	
func end_game():
	get_tree().change_scene("res://Levels/GameOver.tscn")


