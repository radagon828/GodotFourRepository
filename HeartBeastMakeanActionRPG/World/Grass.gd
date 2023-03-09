extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	var world = get_tree().current_scene
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position
	
	
func _on_HurtBox_area_entered(area: Area2D) -> void:
	create_grass_effect()
	queue_free()
