extends GridContainer

var inventory = preload("res://Inventory.tres")

func _ready():
	inventory.items_changed.connect(_on_items_changed)
	update_inventory_display()
	
#changes the ordering of items when the positions of the items are changes
func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot_display(item_index)
		

#gets index of inventory item and runs display item func from slot script
func update_inventory_slot_display(item_index):
	#gets each inv slot in tree and inserts item data
	var itemSlotDisplay = get_child(item_index)
	var item = inventory.items[item_index]
	itemSlotDisplay.display_item(item)
	

#refills array with updated item positions
func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)
		
		#unhandle means it hasn't been handled
#Dictionary means if the item exists
#sets item in the same slot as it was before if you didn't select an inventory space
func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary:
			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)

		

