extends Area2D

@export var itemRes: InventoryItem

#adds item into inventory preloaded on player class and then elimanates item from the world
#uses insert functoin on ivnentory script
func collect(inventory: Inventory):
	inventory.insert(itemRes)
	queue_free()
