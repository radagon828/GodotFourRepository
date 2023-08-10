extends Area2D

@onready var player = $"../.."
var knockback_vector = Vector2.ZERO

func _physics_process(_delta):
	knockback_vector = player.roll_vector

