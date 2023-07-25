extends RigidBody2D

@export var item: Resource 

var inventory = preload("res://Scenes/UIElements/InventoryMenu/NewInventory.tres")

@onready var itemTexture = $ItemTexture
# Called when the node enters the scene tree for the first time.
func _ready():
	if item is Item:
		itemTexture.texture = item.texture

func _on_pickup_box_area_entered(area):
	var item_index = inventory.items.find(null, 0)
	inventory.set_item(item_index, item)
	print("pickedup")
	queue_free()
	

