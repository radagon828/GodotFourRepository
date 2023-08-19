class_name SaveGame
extends Node

const SAVE_GAME_PATH = ""

@export var version = 1

@export var inventory: Resource

@export var map_name = ""
@export var global_position = Vector2.ZERO

var save_nodes = get_tree().get_nodes_in_group("Persist")

func save():
	var save_dict = {
#		"stats" : get_parent()
	}
	return save_dict
	
func save_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
			var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(json_string)
		

func write_savegame() -> void:
	ResourceSaver.save(SAVE_GAME_PATH, self)
	
	var data
static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)
	
static func load_savegame() -> Resource:
	if not ResourceLoader.has_cached(SAVE_GAME_PATH):
		return ResourceLoader.load(SAVE_GAME_PATH, "", true)
	
