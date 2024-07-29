extends Node2D

@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var player = $TileMap/Player

#gets the players current and max health value and displays hearts on the UI according to the ammount
func _ready():
	heartsContainer.setMaxHearts(player.maxHealth)
	heartsContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartsContainer.updateHearts)
	

#unpauses
func _on_inventory_gui_closed():
	get_tree().paused = false

#pauses
func _on_inventory_gui_opened():
	get_tree().paused = true
