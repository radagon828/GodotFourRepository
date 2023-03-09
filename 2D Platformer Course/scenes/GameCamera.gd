extends Camera2D

var targetPosition = Vector2.ZERO
var cameraPositionX : int
var cameraPositionY : int

export(Color, RGB) var backgroundColor

func _ready():
	VisualServer.set_default_clear_color(backgroundColor)
#global posiont is postion of the objcet the script is attached to, in this case the camera
func _process(delta):
	acquire_target_position()
	#lerp allows for the slow progression of one value to another based on weight
	cameraPositionX = int(lerp(targetPosition.x, global_position.x, pow(2, -1 * delta)))
	cameraPositionY = int(lerp(targetPosition.y, global_position.y, pow(2, -1 * delta)))
	global_position = Vector2(cameraPositionX,cameraPositionY)

func acquire_target_position():
	var players = get_tree().get_nodes_in_group("player")
	if (players.size() > 0):
		var player = players[0]
		global_position = player.global_position
