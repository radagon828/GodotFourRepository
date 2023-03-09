extends CanvasLayer


func _ready() -> void:
	var baseLevels = get_tree().get_nodes_in_group("base_level")
	
	if (baseLevels.size() > 0):
		baseLevels[0].connect("coin_total_changed", self, "on_coin_total_changed")
		
func on_coin_total_changed(totalCoins, collectedCoins):
	$MarginContainer/HBoxContainer/CoinLabel.text = str(collectedCoins, "/", totalCoins)
