extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play()


func _on_animation_finished() -> void:
	queue_free()
