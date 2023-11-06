extends Node2D

#@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
#@onready var polygon_2d = $StaticBody2D/CollisionPolygon2D/Polygon2D
@onready var level_completed = $CanvasLayer/LevelCompleted

func _ready():
#	polygon_2d.polygon = collision_polygon_2d.polygon
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.level_completed.connect(show_level_completed)
	
func show_level_completed():
	level_completed.show()
	get_tree().paused = true
