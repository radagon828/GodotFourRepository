extends AnimatedSprite

func _ready() -> void:
	connect("animation_finished", self, "_on_animation_finished")
	# frame = 0 is not neccesary
	frame = 0
	play("Animate")
	
func _on_animation_finished() -> void:
	queue_free()
