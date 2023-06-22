extends CenterContainer

var inventory = preload("res://Inventory.tres")

@onready var itemTextureRect = $ItemTextureRect

#displays the texture of the item in the item slot, also displays empty slot 
func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
	else:
		itemTextureRect.texture = load("res://Items/EmptyInventorySlot.png")
		
#get index() returns item node order # based on position in scene tree
#removes item from slot temporarily
func _get_drag_data(_at_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	#checks if its null
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		set_drag_preview(dragPreview)
		#stores data of picked up item
		inventory.drag_data = data
		return data

#will reurn true if data is dictionary and has an item
func _can_drop_data(_at_position, data):
	return data is Dictionary and data.has("item")

#swaps or places items in empty position
func _drop_data(_at_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	inventory.swap_items(my_item_index, data.item_index)
	inventory.set_item(my_item_index, data.item)
	inventory.drag_data = null
