extends Panel

class_name ItemStackGui

@onready var itemSprite: Sprite2D = $item
@onready var amountLabel: Label = $Label

var inventorySlot: InventorySlot

func update():
	if !inventorySlot || !inventorySlot.item: return
	
	itemSprite.visible = true
	itemSprite.texture = inventorySlot.item.texture
	amountLabel.visible = true if inventorySlot.amount > 1 else false
	amountLabel.text = str(inventorySlot.amount)
