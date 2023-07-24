extends RigidBody2D

@export var item: Resource 

var inventory = preload("res://Scenes/UIElements/InventoryMenu/NewInventory.tres")

@onready var itemTexture = $ItemTexture
# Called when the node enters the scene tree for the first time.
func _ready():
	if item is Item:
		itemTexture.texture = item.texture

func _on_pickup_box_area_entered(area):
	inventory.set_item(10, item)
	print("pickedup")
	queue_free()
	
#func item_picked_up():
#	call_deferred("_on_pickup_box_area_entered")
	
