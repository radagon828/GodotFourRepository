extends Panel

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item
@onready var amountLabel: Label = $CenterContainer/Panel/Label

#changes inventory slot to reflect the item being there by adding the item sprite
# and also the slot sprite
func update(slot: InventorySlot):
	if !slot.item:
		backgroundSprite.frame = 0
		itemSprite.visible = false
		amountLabel.visible = false
	else:
		backgroundSprite.frame = 1
		itemSprite.visible = true
		itemSprite.texture = slot.item.texture
		amountLabel.visible = true if slot.amount > 1 else false
		amountLabel.text = str(slot.amount)
