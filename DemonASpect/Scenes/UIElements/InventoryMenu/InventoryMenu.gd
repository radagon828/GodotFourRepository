extends ColorRect

@onready var firstItemSlot: Button = $CenterContainer/ItemDisplay/SelectableItemSlot
@onready var animatorItem: AnimationPlayer = $AnimationPlayer

var opened: bool = false

func _ready():
	pass
	
func close_inventory():
	animatorItem.play("InventoryCLose")
	#get_tree(),paused pauses all nodes in the scene that has their process mode set to inherit
	get_tree().paused = false
	self.hide()
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("UNPAuSING")
#
func open_inventory():
	firstItemSlot.grab_focus()
	animatorItem.play("InventoryOpen")
	#get_tree(),paused pauses all nodes in the scene that has their process mode set to inherit
	get_tree().paused = true
	opened = true
	self.show()
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
