extends Camera2D

var targetPosition = Vector2.ZERO

export(Color, RGB) var backgroundColor

#REVIEW CAMERA FOLLOW LECTURE
func _ready():
	VisualServer.set_default_clear_color(backgroundColor)
#global posiont is postion of the objcet the script is attached to, in this case the camera
func _process(delta):
	acquire_target_position()
	#lerp allows for the slow progression of one value to another based on weight

	global_position = lerp(targetPosition, global_position, pow(2, -15 * delta))
#target
func acquire_target_position():
	var players = get_tree().get_nodes_in_group("player")
	if (players.size() > 0):
		var player = players[0]
		targetPosition = player.global_position

