extends Resource

class_name Inventory

signal updated

@export var slots: Array[InventorySlot]

#looks at each invetory slot to find the first empty slot to put the new item in
#loop will end/break once a single empty slot is found
#sends update signal to inventory gui afterwards
func insert(item: InventoryItem):
	for slot in slots:
		if slot.item == item:
			slot.amount += 1
			updated.emit()
			return
	
	for i in range(slots.size()):
		if !slots[i].item:
			slots[i].item = item
			slots[i].amount = 1
			updated.emit()
			return
	
