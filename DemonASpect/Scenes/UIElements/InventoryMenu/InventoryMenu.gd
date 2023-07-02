extends ColorRect

@onready var firstItemSlot = $CenterContainer/ItemDisplay/SelectableItemSlot

func _ready():
	firstItemSlot.grab_focus()
	
#func unPause():
#	animator.play("Unpause")
#	#get_tree(),paused pauses all nodes in the scene that has their process mode set to inherit
#	get_tree().paused = false
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	print("UNPAuSING")
#
#func pause():
#	animator.play("Pause")
#	#get_tree(),paused pauses all nodes in the scene that has their process mode set to inherit
#	get_tree().paused = true
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
