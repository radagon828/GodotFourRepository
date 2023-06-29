extends Button

var inventory = preload("res://NewInventory.tres")

@onready var itemTextureRect = $ItemTexture
@onready var selectedTexture = $TextureRect
@export var is_selected = false

signal selection_made
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta: float):
	selectedTexture.modulate = Color(0, 0, 0, .5) if is_selected else Color(0, 0, 0, 0)
	
func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
	else:
		itemTextureRect.texture = null
		


func _on_button_down():
	is_selected = false if is_selected else true 
	var my_item_index = get_index()
	emit_signal("selection_made", my_item_index)
	var my_item = inventory.items[my_item_index]
	inventory.drag_data = null
