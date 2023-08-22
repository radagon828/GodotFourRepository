extends Node

@export var levelScenes: Array[PackedScene]

var currentLevelIndex = 0

func _ready():
	get_tree().change_scene_to_file(levelScenes[currentLevelIndex].resource_path)
	
func change_level(levelIndex):
	BaseLevel.change_scene_name()
	BaseLevel.save_game()
	
	call_deferred("goto_level", levelIndex)

func goto_level(levelIndex):
	currentLevelIndex = levelIndex
	get_tree().change_scene_to_file(levelScenes[levelIndex].resource_path)
	BaseLevel.load_game()

