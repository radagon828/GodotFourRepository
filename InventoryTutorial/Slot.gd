extends Panel

var default_tex = preload("res://item_slot_default_background.png")
var empty_tex = preload("res://item_slot_empty_background.png")


var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

var ItemClass = preload("res://item.tscn")
var item = null

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	
	if randi() % 2 == 0:
		item = ItemClass.instantiate()
		add_child(item)
	refresh_style()
	
func refresh_style():
	if item == null:
		set('theme_override_styles/panel', empty_style)
	else:
		set('theme_override_styles/panel', default_style)
	

