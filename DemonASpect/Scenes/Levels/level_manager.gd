extends Node

@export var levelScenes: Array[PackedScene]

var currentLevelIndex = 0

func _ready():
	get_tree().change_scene_to_file(levelScenes[currentLevelIndex].resource_path)
	BaseLevel.load_game()
	
func change_level(levelIndex):
	BaseLevel.save_game()
	
	call_deferred("goto_level", levelIndex)

func goto_level(levelIndex):
	currentLevelIndex = levelIndex
	get_tree().change_scene_to_file(levelScenes[levelIndex].resource_path)
	
	call_deferred("load_level")
	
func load_level():
	BaseLevel.change_scene_name()
	BaseLevel.load_game()
	print(get_tree().get_current_scene().get_name())

