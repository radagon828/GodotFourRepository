extends ColorRect

@export var dialogPath: String = ""
@export var textSpeed: float = 0.05

var dialog

func _ready():
	$Timer.wait_time = textSpeed
	dialog = getDialog()
	
func getDialog() -> Array:
