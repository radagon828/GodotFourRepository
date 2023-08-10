extends Node

@onready var environment = $Environment
@onready var user_interface = $Player/PlayerUI
@onready var levelManager = $"/root/LevelManager"

func _ready():
	for scene in environment.get_children():
		scene.dialog_event.connect(disable_ui)
		scene.event_end.connect(enable_ui)
		scene.door_entered.connect(enter_area)
	
#disables ui interaction when a dialog event is started
func disable_ui():
	#for some reason even though the player is set to pausable he will no pause unless this function runs
	user_interface.process_mode = Node.PROCESS_MODE_DISABLED

#enables ui interaction after an event dialogue is disabled
func enable_ui():
	user_interface.process_mode = Node.PROCESS_MODE_ALWAYS

#changes level when door is entered
func enter_area(area_index):
	levelManager.change_level(area_index)



