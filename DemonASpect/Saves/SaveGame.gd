class_name SaveGame
extends Resource

const SAVE_GAME_PATH = ""

@export var version = 1

@export var character: Resource
@export var inventory: Resource

@export var map_name = ""
@export var global_position = Vector2.ZERO

func write_savegame() -> void:
	ResourceSaver.save(SAVE_GAME_PATH, self)
	
static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)
	
static func load_savegame() -> Resource:
	if not ResourceLoader.has_cached(SAVE_GAME_PATH):
		return ResourceLoader.load(SAVE_GAME_PATH, "", true)
	
