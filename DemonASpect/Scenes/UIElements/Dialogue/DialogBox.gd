extends RichTextLabel

@export var dialog: Array[String] = []
var page = 0
@onready var timer = $Timer


func _ready():
#	parse_bbcode(dialog[page])
	visible_characters = 0
	set_process_input(true)
	

func _input(event):
	if Input.is_action_just_released("ui_accept"):
		if visible_characters > get_total_character_count():
			if page < dialog.size()-1:
				page += 1
				parse_bbcode(dialog[page])
				visible_characters = 0
			else:
				get_parent().get_parent().hide()
		else:
			visible_characters = get_total_character_count()
	
func _on_timer_timeout():
	visible_characters = visible_characters + 1
	

