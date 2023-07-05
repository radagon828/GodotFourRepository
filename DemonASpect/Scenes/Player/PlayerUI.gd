extends Node

@onready var InvMenu = $InventoryMenu
@onready var PauseMenu = $PauseMenu
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
	if event.is_action_pressed("open_inventory"):
		if InvMenu.opened == true:
			InvMenu.close_inventory()
		else:
			InvMenu.open_inventory()
			if PauseMenu.paused == true: 
				PauseMenu.hide() 
				PauseMenu.paused = false
