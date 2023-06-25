extends ColorRect

@onready var firstItemSlot = $CenterContainer/ItemDisplay/SelectableItemSlot

func _ready():
	firstItemSlot.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
