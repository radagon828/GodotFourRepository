extends ColorRect

var inventory = preload("res://Inventory.tres")

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func _drop_data(_position, data):
	inventory.set_item(data.item_index, data.item)
