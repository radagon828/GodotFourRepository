extends Camera2D

onready var topLeft = $Limits/Topleft
onready var bottomRight = $Limits/BottomRight

func _ready() -> void:
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x
