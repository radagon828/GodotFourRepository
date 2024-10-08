extends Node2D

@onready var surface_collision = $StaticBody2D/CollisionPolygon2D
@onready var surface_area = $StaticBody2D/CollisionPolygon2D/Polygon2D

func _ready() -> void:
	surface_area.polygon = surface_collision.polygon 
