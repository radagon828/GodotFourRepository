extends HBoxContainer

@onready var HeartGuiClass = preload("res://gui/heartGui.tscn")

#determines the maximum ammount of hearts a player can have
func setMaxHearts(max: int):
	for i in range(max):
		var heart = HeartGuiClass.instantiate()
		add_child(heart)

#changes players amount of hearts based on current health updates
func updateHearts(currentHealth: int):
	var hearts = get_children()
	
	for i in range(currentHealth):
		hearts[i].update(true)
		
	for i in range(currentHealth, hearts.size()):
		hearts[i].update(false)
