extends Button


@onready var itemTextureRect = $ItemTexture
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
	else:
		itemTextureRect.texture = null
		




func _on_pressed():
	toggle_mode = true
	itemTextureRect.texture = null
