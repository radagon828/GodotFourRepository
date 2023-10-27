extends ColorRect

@onready var firstItemSlot: Button = $CenterContainer/ItemDisplay/SelectableItemSlot
@onready var animatorItem: AnimationPlayer = $AnimationPlayer
var opened: bool = false

func close_inventory():
	animatorItem.play("InventoryClose")
	self.hide()
	opened = false

func open_inventory():
	firstItemSlot.grab_focus()
	animatorItem.play("InventoryOpen")
	opened = true
	self.show()
