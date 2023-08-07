extends Node

@onready var InvMenu = $InventoryMenu
@onready var PauseMenu = $PauseMenu
@onready var ItemDisplay = $InventoryMenu/CenterContainer/ItemDisplay
#
# Called when the node enters the scene tree for the first time.
func _ready():
		InvMenu.hide()
		PauseMenu.hide()

func _process(delta):
	get_tree().paused = false if !InvMenu.opened && !PauseMenu.paused else true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if PauseMenu.paused == true:
			PauseMenu.unPause()
		else:
			if InvMenu.opened == true: 
				InvMenu.close_inventory()
				InvMenu.opened = false
				ItemDisplay.end_examine()
				ItemDisplay.back_out()
			PauseMenu.pause()
			PauseMenu.play_button.grab_focus()
			
	if event.is_action_pressed("open_inventory"):
		if InvMenu.opened == true:
			ItemDisplay.end_examine()
			ItemDisplay.back_out()
			InvMenu.close_inventory()
		else:
			if PauseMenu.paused == true: 
				PauseMenu.hide() 
				PauseMenu.paused = false
			InvMenu.open_inventory()
