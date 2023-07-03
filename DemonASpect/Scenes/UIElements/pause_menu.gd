extends ColorRect

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var play_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var quit_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	play_button.pressed.connect(unPause)
	quit_button.pressed.connect(get_tree().quit)
	
	
func unPause():
	animator.play("Unpause")
	#get_tree(),paused pauses all nodes in the scene that has their process mode set to inherit
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func pause():
#	play_button.grab_focus()
	self.show()
	animator.play("Pause")
	#get_tree(),paused pauses all nodes in the scene that has their process mode set to inherit
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
