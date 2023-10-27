extends GridContainer

var inventory = preload("res://Scenes/UIElements/InventoryMenu/NewInventory.tres")
var swapIndexes: Array[int] 

var dialogInstance = preload("res://Scenes/UIElements/Dialogue/dialog_box.tscn")
var examineBox: Panel = null
#prepares all functions for the individual slots
func _ready():
	inventory.items_changed.connect(_on_items_changed)
	update_inventory_display()
	#preparing slot functions
	for item_index in inventory.items.size():
		var selectableItemSlot = get_child(item_index)
		selectableItemSlot.selection_made.connect(prepare_to_swap)
		selectableItemSlot.item_options_opened.connect(on_item_options_opened)
		selectableItemSlot.back_out.connect(back_out)
		selectableItemSlot.see_item_description.connect(play_item_description)
		

#adds item slot to an index, if the index has two items the position of the two items will swap
func prepare_to_swap():
	swapIndexes.clear()
	for item_index in inventory.items.size():
		if get_child(item_index).is_selected:
			swapIndexes.append(item_index)
	if swapIndexes.size() > 1:
		inventory.swap_items(swapIndexes[0], swapIndexes[1])
		swapIndexes.clear()


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
#		print(inventory.items[item_index].description)
		
#makes inventory slots unselectable when item option menu is opened
func on_item_options_opened():
	for item_index in inventory.items.size():
		var selectableItemSlot = get_child(item_index)
		selectableItemSlot.focus_mode = Control.FOCUS_NONE

#makes inventory slots selectable when item option menu is closed
func back_out():
	if examineBox != null:
		examineBox.queue_free()
	for item_index in inventory.items.size():
		var selectableItemSlot = get_child(item_index)
		selectableItemSlot.focus_mode = Control.FOCUS_ALL
		selectableItemSlot.itemOptions.hide()

#instantiates text box
func play_item_description(description):
	examineBox = dialogInstance.instantiate()
	var dialogText = examineBox.get_child(0).get_child(0)
	dialogText.dialog = description
	get_parent().get_parent().add_child(examineBox)
	dialogText.on_dialog_end.connect(end_examine)

func end_examine():
	if examineBox != null:
		examineBox.queue_free()
	for item_index in inventory.items.size():
		var selectableItemSlot = get_child(item_index)
		if selectableItemSlot.itemOptions.is_visible():
			selectableItemSlot.on_dialog_finished()
			

