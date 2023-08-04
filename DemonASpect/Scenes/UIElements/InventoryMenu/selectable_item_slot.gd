extends Button

#var inventory = preload("res://Scenes/UIElements/InventoryMenu/NewInventory.tres")

var itemDescription: Array[String] = []
var hasItem: bool = false

@onready var itemTextureRect = $ItemTexture
@onready var selectedTexture = $TextureRect
@onready var itemOptions = $ItemOptions
@export var is_selected = false

signal selection_made
signal item_options_opened
signal back_out
signal see_item_description(itemDescription)
# Called when the node enters the scene tree for the first time.
func _ready():
	button_down.connect(_on_button_down)
	itemOptions.hide()
	
#changed background color of selected button
func _process(delta: float):
	selectedTexture.modulate = Color(0, 0, 0, .5) if is_selected else Color(0, 0, 0, 0)
	if self.has_focus() == true && Input.is_action_just_pressed("roll"): swap_select()
	if Input.is_action_just_pressed("attack") && itemOptions.is_visible():
		on_back_out_pressed()

#function displays the item texture in the inventory menu and also assigns the item description to a dialog box
func display_item(item):
	if item is Item:
		hasItem = true
		itemTextureRect.texture = item.texture
		itemDescription.append_array(item.description)
	else:
		hasItem = false
		itemTextureRect.texture = null

func swap_select():
	is_selected = !is_selected
	emit_signal("selection_made")
#	var my_item_index = get_index()
#	var my_item = inventory.items[my_item_index]
	
#shows item options for respective slot, also sends signal to item display
func _on_button_down():
	if self.has_focus() && hasItem:
		itemOptions.show()
		itemOptions.get_child(0).grab_focus()
		emit_signal("item_options_opened")

#hides item options
func on_back_out_pressed():
	emit_signal("back_out")
	itemOptions.hide()
	self.grab_focus()

#opens item desciption
func _on_examine_pressed():
	emit_signal("see_item_description", itemDescription)
	var buttons = itemOptions.get_children()
	for button in buttons:
		button.focus_mode = Control.FOCUS_NONE

func on_dialog_finished():
	var buttons = itemOptions.get_children()
	for button in buttons:
		button.focus_mode = Control.FOCUS_ALL
	buttons[0].grab_focus()
	
