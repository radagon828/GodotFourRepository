extends Player


# Called when the node enters the scene tree for the first time.
func _ready():
	print("i'm here")


	
func _physics_process(delta):
	if velocity.x != 0:
		print("i'm here")
