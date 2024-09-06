extends Button

@onready var backgroundSprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer

var itemStackGui: ItemStackGui
#changes inventory slot to reflect the item being there by adding the item sprite
# and also the slot sprite
func insert(isg: ItemStackGui):
	itemStackGui = isg
	backgroundSprite.frame = 1
	container.add_child(itemStackGui)
