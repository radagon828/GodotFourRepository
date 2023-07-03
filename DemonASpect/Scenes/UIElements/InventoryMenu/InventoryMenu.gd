extends ColorRect

@onready var firstItemSlot: Button = $CenterContainer/ItemDisplay/SelectableItemSlot
@onready var animatorItem: AnimationPlayer = $AnimationPlayer

func _ready():
	pass
	
#func unPause():
#	animator.play("Unpause")
#	#get_tree(),paused pauses all nodes in the scene that has their process mode set to inherit
#	get_tree().paused = false
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	print("UNPAuSING")
#
func open_inventory():
#	firstItemSlot.grab_focus()
	animatorItem.play("InventoryOpen")
	#get_tree(),paused pauses all nodes in the scene that has their process mode set to inherit
	get_tree().paused = true
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
