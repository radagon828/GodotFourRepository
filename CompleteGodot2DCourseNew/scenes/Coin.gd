extends Node2D

# calls method when coins area2d is entered
func _ready():
	$Area2D.connect("area_entered", self, "on_area_entered")

# on coin area entered play the coins pickup animation and 
#call the disable_pickup method after that animation is finished playing
#gets current level scene and calls the coin_collect method in the scene upon coin pickup
func on_area_entered(area2d):
	$AnimationPlayer.play("pickup")
	call_deferred("disable_pickup")
	var baseLevel = get_tree().get_nodes_in_group("base_level")[0]
	baseLevel.coin_collected()
	
#prevents playing of coin pickup animation so that the coin appears gone from the scene
func disable_pickup():
	$Area2D/CollisionShape2D.disabled = true
