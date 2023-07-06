extends GridContainer

var inventory = preload("res://Scenes/UIElements/InventoryMenu/NewInventory.tres")
var swapIndexes: Array[int] 


func _ready():
	inventory.items_changed.connect(_on_items_changed)
	update_inventory_display()
	for item_index in inventory.items.size():
		var selectableItemSlot = get_child(item_index)
		selectableItemSlot.selection_made.connect(prepare_to_swap)
		selectableItemSlot.itemOptionsOpened.connect(on_item_options_opened)
		
#adds item slot to an index, if the index has two items the position of the two items will swap
func prepare_to_swap():
	swapIndexes.clear()
	for item_index in inventory.items.size():
		if get_child(item_index).is_selected:
			swapIndexes.append(item_index)
	if swapIndexes.size() > 1:
		inventory.swap_items(swapIndexes[0], swapIndexes[1])
		swapIndexes.clear()
	print(swapIndexes)
	

#changes the ordering of items when the positions of the items are changes
func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)
		

#gets index of inventory item and runs display item func from slot script
func update_inventory_slot_display(item_index):
	#gets each inv slot in tree and inserts item data
	var selectableItemSlot = get_child(item_index)
	var item = inventory.items[item_index]
	selectableItemSlot.display_item(item)
	selectableItemSlot.is_selected = false
	

#refills array with updated item positions
func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)
		

func on_item_options_opened():
	pass
	print("done")
	for item_index in inventory.items.size():
		var selectableItemSlot = get_child(item_index)
		selectableItemSlot.focus_mode = Control.FOCUS_NONE
