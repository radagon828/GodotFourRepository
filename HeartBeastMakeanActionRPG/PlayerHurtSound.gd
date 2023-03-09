extends AudioStreamPlayer

func _ready() -> void:
	connect("finished", self, "queue_free")
