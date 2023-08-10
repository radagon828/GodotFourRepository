extends Area2D

var player = null
@onready var detectionZone = $CollisionShape2D

func can_see_player():
	return player != null

func _ready():
	area_entered.connect(on_player_detection)
	area_exited.connect(on_player_evasion)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_player_detection(body: Area2D):
	player = body 

func on_player_evasion(_body: Area2D):
	player = null
