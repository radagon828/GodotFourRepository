extends Area2D

var knockback_vector = Vector2.ZERO
@onready var ratMan = $"../.."

func _physics_process(delta):
	knockback_vector = ratMan.attackVector
