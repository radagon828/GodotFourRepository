extends Node

@onready var InvMenu = $InventoryMenu
@onready var PauseMenu = $PauseMenu
@onready var ItemDisplay = $InventoryMenu/CenterContainer/ItemDisplay
#
# Called when the node enters the scene tree for the first time.
func _ready():
		InvMenu.hide()
		PauseMenu.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if PauseMenu.paused == true:
			PauseMenu.unPause()
		else:
			PauseMenu.pause()
			if InvMenu.opened == true: 
				InvMenu.hide()
				InvMenu.opened = false
				ItemDisplay.back_out()
				ItemDisplay.update_inventory_display()
	if event.is_action_pressed("open_inventory"):
		if InvMenu.opened == true:
			InvMenu.close_inventory()
			ItemDisplay.back_out()
			ItemDisplay.update_inventory_display()
		else:
			InvMenu.open_inventory()
			if PauseMenu.paused == true: 
				PauseMenu.hide() 
				PauseMenu.paused = false
