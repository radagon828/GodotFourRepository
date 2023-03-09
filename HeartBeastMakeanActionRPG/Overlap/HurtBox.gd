extends Area2D

export(bool) var show_hit = true

const HitEffect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	print("start invincibility")
	self.invincible = true
	timer.start(duration)
	print(timer.wait_time)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout() -> void:
	print("timer timeout")
	self.invincible = false

#monierable controls whether or not mask is active
func _on_HurtBox_invincibility_started() -> void:
#	collisionShape.set_deferred("disabled", true)
	set_deferred("monitoring", false)
	print("invincibility started")

func _on_HurtBox_invincibility_ended() -> void:
#	collisionShape.disabled = false
	monitoring = true
	print("invincibility ended")

