extends Area2D

@onready var player = $"../.."
var knockback = player

func _physics_process(delta):
	print(knockback)


