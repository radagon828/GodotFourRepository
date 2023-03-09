extends Node

signal coin_total_changed

export(PackedScene) var levelCompleteScene

var playerScene = preload("res://scenes/Player.tscn")
var spawnPosition = Vector2.ZERO
var currentPlayerNode = null
var totalCoins = 0
var collectedCoins = 0

#defines player spawn position and calls register player method
#calls coin_total_changed method when the amount of coins in the level are decreased
func _ready():
	spawnPosition = $Player.global_position
	register_player($Player)
	coin_total_changed(get_tree().get_nodes_in_group("coin").size())
	
	$Flag.connect("player_won", self, "on_player_won")

#defines how many coins collected
func coin_collected():
	collectedCoins += 1
	print(totalCoins, " - ", collectedCoins)
	emit_signal("coin_total_changed", totalCoins, collectedCoins)

#updates how many coins are in the level and emits a signal with the updated ammounts
func coin_total_changed(newTotal):
	totalCoins = newTotal
	emit_signal("coin_total_changed", totalCoins, collectedCoins)

#defines current player scene as the current one
func register_player(player):
	currentPlayerNode = player
	#receives died signal emited from player
	currentPlayerNode.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)

#spawns in player using saved spawn position after player death
func create_player():
	var playerInstance = playerScene.instance()
	add_child_below_node(currentPlayerNode, playerInstance)
	playerInstance.global_position = spawnPosition
	register_player(playerInstance)

#destroys player instance and calls create player method
func on_player_died():
	currentPlayerNode.queue_free()
	create_player()

#spawns level complete ui that allows player to transition levels, also 
#despawns player to prevent death after victory
func on_player_won():
	currentPlayerNode.queue_free()
	var levelComplete = levelCompleteScene.instance()
	add_child(levelComplete)

