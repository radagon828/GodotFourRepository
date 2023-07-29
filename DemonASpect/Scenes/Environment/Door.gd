extends Node2D

@export var is_unlocked: bool = false
var in_use_range: bool = false 
@onready var doorHitbox: Area2D = $Area2D
@onready var doorSprite: Sprite2D = $Sprite2D

func _ready():
	doorHitbox.get

func _process(delta):
	doorSprite.frame = 0 if is_unlocked else 0


func _on_area_2d_area_entered(area):
	in_use_range = true
	print("use_key")


func _on_area_2d_area_exited(area):
	in_use_range = false
	print("can't_use_key")
