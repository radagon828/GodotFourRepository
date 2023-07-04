extends Node

#
# Called when the node enters the scene tree for the first time.
func _ready():
		$InventoryMenu.hide()
		$PauseMenu.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if $PauseMenu.paused == true:
			$PauseMenu.unPause()
		else:
			$PauseMenu.pause()
	if event.is_action_pressed("open_inventory"):
		$InventoryMenu.open_inventory()
		if $PauseMenu.paused == true:
			$PauseMenu.hide()
