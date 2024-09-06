extends Control

signal opened
signal closed

var isOpen : bool = false

@onready var inventory: Inventory = preload("res://inventory/playerInventory.tres")
@onready var ItemStackGuiClass = preload("res://gui/itemStackGui.tscn")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

#connects signal from invetory script to update function
func _ready():
	connectSlots()
	inventory.updated.connect(update)
	update()


func connectSlots():
	for slot in slots:
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

#runs update function on each inventory slot, if the slot has an item the gui will reflect that
func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		
		if !inventorySlot.item: continue
		
		var itemStackGui: ItemStackGui = slots[i].itemStackGui
		if !itemStackGui:
			itemStackGui = ItemStackGuiClass.instantiate()
			slots[i].insert(itemStackGui)
			
		itemStackGui.inventorySlot = inventorySlot
		itemStackGui.update()
#send pause game signal to world;, and opens inventory
func open():
	visible = true
	isOpen = true
	opened.emit()

#send unpause game signal to world, and closes inventory
func close():
	visible = false
	isOpen = false
	closed.emit()
	
func onSlotClicked(slot):
	pass
