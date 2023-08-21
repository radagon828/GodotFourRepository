extends Node

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
	}
	return save_dict
#const SAVE_GAME_PATH = "res://save_json.json"
#
#@export var version = 1
#
#@export var inventory: Resource
#
#@export var map_name = ""
#@export var global_position = Vector2.ZERO
#
#var test_number = 3
#var level_name = ""
#@onready var save_nodes = get_tree().get_nodes_in_group("Persist")
#
#func _process(delta):
#	print(test_number, level_name)
#
#func save():
#	var save_dict = {
#
#	}
#	return save_dict
#
#func save_game():
#	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
#	var save_nodes = get_tree().get_nodes_in_group("Persist")
#	for node in save_nodes:
#		# Check the node is an instanced scene so it can be instanced again during load.
#		if node.scene_file_path.is_empty():
#			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
#			continue
#
#		# Check the node has a save function.
#		if !node.has_method("save"):
#			print("persistent node '%s' is missing a save() function, skipped" % node.name)
#			continue
#
#		# Call the node's save function.
#		var node_data = node.call("save")
#
#		# JSON provides a static method to serialized JSON string.
#		var json_string = JSON.stringify(node_data)
#
#		# Store the save dictionary as a new line in the save file.
#		save_game.store_line(json_string)
		


