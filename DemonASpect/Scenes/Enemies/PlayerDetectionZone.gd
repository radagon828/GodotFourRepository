extends Area2D

var player = null

func can_see_player():
	return player != null

func _ready():
	body_entered.connect(on_player_detection)
	body_exited.connect(on_player_evasion)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_player_detection(body: Node2D):
	player = body 
	print("I can see you")

func on_player_evasion(body: Node2D):
	player = null
