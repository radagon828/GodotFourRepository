extends Control

signal opened
signal closed

var isOpen : bool = false

@onready var inventory: Inventory = preload("res://inventory/playerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

#connects signal from invetory script to update function
func _ready():
	inventory.updated.connect(update)
	update()

#runs update function on each inventory slot that has an item in the corresponding array slot
func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

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
