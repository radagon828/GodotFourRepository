extends Button

var inventory = preload("res://Scenes/UIElements/InventoryMenu/NewInventory.tres")

@onready var itemTextureRect = $ItemTexture
@onready var selectedTexture = $TextureRect
@export var is_selected = false

signal selection_made
# Called when the node enters the scene tree for the first time.
func _ready():
	button_down.connect(_on_button_down)

func _physics_process(delta: float):
	selectedTexture.modulate = Color(0, 0, 0, .5) if is_selected else Color(0, 0, 0, 0)
	
func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
	else:
		itemTextureRect.texture = null
		
func _on_button_down():
	is_selected = !is_selected
	var my_item_index = get_index()
	emit_signal("selection_made")
	var my_item = inventory.items[my_item_index]
	inventory.drag_data = null
