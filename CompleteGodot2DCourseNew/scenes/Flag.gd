extends Node2D

signal player_won

func _ready() -> void:
	$Area2D.connect("area_entered", self, "on_area_entered")

#emits signal upon player entering flag area
func on_area_entered(_area2d):
	emit_signal("player_won")
