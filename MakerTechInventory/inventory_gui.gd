extends Control

var isOpen: bool = false

func open():
	visible = true
	isOpen = true
	
func close():
	visible = false
	isOpen = false
	
func _input(event):
	if Input.is_action_just_pressed("toggle_inventory"):
		if isOpen:
			close()
		else:
			open()
