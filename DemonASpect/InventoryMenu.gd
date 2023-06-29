extends ColorRect

@onready var firstItemSlot = $CenterContainer/ItemDisplay/SelectableItemSlot

func _ready():
	firstItemSlot.grab_focus()
