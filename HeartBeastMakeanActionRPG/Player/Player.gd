extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 125
export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $HurtBox
onready var blinkAnimationPlayer = $BlinkAnimationPLayer

func _ready():
	#changes game seed everytime you run the game
	randomize()
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	#by making it equal roll vector enemy knock back will be in the direction the player is facing
	swordHitbox.knockback_vector = roll_vector

#dont need_physics_process because we arn't accessing any kinematic body physics in the code
func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			move_state(delta)
			
		ATTACK:
			attack_state()
			
		ROLL:
			roll_state()
			
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#normalized creates circle to cut of vector range and keep the same speed in all directions
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		#make sure one animation plays on load 
		roll_vector = input_vector
		#makes enemy knockback vectore the same as the direction your moving in
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	#by setting the velocity it remembers the velocity left over from the collision
	#print(velocity)
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	state = MOVE

func _on_HurtBox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	hurtbox.start_invincibility(1)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)


func _on_HurtBox_invincibility_started() -> void:
	blinkAnimationPlayer.play("Start")

func _on_HurtBox_invincibility_ended() -> void:
	blinkAnimationPlayer.play("Stop")
