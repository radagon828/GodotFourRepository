extends Button

var inventory = preload("res://Scenes/UIElements/InventoryMenu/NewInventory.tres")

@onready var itemTextureRect = $ItemTexture
@onready var selectedTexture = $TextureRect

@onready var itemOptions = $ItemOptions

@export var is_selected = false

signal selection_made
signal item_options_opened
signal back_out
# Called when the node enters the scene tree for the first time.
func _ready():
	button_down.connect(_on_button_down)
	itemOptions.hide()
	
#changed background color of selected button
func _physics_process(delta: float):
	selectedTexture.modulate = Color(0, 0, 0, .5) if is_selected else Color(0, 0, 0, 0)
	if self.has_focus() == true && Input.is_action_just_pressed("roll"): swap_select()
	if Input.is_action_just_pressed("attack") && itemOptions.is_visible():
		emit_signal("back_out")
		itemOptions.hide()
		self.grab_focus()
		
func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
	else:
		itemTextureRect.texture = null

func swap_select():
	is_selected = !is_selected
	var my_item_index = get_index()
	emit_signal("selection_made")
	var my_item = inventory.items[my_item_index]
	inventory.drag_data = null
	
func _on_button_down():
	if self.has_focus():
		itemOptions.show()
		itemOptions.get_child(0).grab_focus()
		emit_signal("item_options_opened")
		

