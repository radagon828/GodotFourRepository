extends Area2D

var player = null

# boolean that outputs tru or false
func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body: Node) -> void:
	player = body

func _on_PlayerDetectionZone_body_exited(body: Node) -> void:
	player = null
