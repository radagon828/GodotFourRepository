extends RichTextLabel

@export var dialog: Array[String] = ["placeholder"]
var page = 0
@onready var timer = $Timer
signal on_dialog_end

func _ready():
	#this is essential for some reason
	parse_bbcode(dialog[page])
	visible_characters = 0
	set_process_input(true)
	
	
func _input(event):
	if Input.is_action_just_released("ui_accept"):
		#if the visible characters are more then the ammount of characters in the array then check if
		#there is another page of dialog to turn to
		if visible_characters > get_total_character_count():
			if page < dialog.size()-1:
				page += 1
				parse_bbcode(dialog[page])
				visible_characters = 0
			else:
				emit_signal("on_dialog_end")
		else:
			visible_characters = get_total_character_count()

func _on_timer_timeout():
	visible_characters = visible_characters + 1
	
	

