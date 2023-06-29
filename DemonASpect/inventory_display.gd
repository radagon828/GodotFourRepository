extends GridContainer

var inventory = preload("res://NewInventory.tres")

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
	var selectableItemSlot = get_child(item_index)
	var item = inventory.items[item_index]
	selectableItemSlot.display_item(item)

#refills array with updated item positions
func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)
		

