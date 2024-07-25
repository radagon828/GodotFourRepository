extends Resource

class_name Inventory

signal updated

@export var items: Array[InventoryItem]

#looks at each invetory slot to find the first empty slot to put the new item in
#loop will end/break once a single empty slot is found
#sends update signal to inventory gui afterwards
func insert(item: InventoryItem):
	for i in range(items.size()):
		if !items[i]:
			items[i] = item
			break
	updated.emit()
