extends ColorRect

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var play_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var quit_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

@export var paused: bool = false

func _ready() -> void:
	play_button.pressed.connect(unPause)
	quit_button.pressed.connect(get_tree().quit)
	
	
func unPause():
	animator.play("Unpause")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	paused = false
	self.hide()
	
func pause():
	self.show()
	animator.play("Pause")
	paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
