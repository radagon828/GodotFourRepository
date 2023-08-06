extends Node

@export var levelScenes: Array[PackedScene]

var currentLevelIndex = 0

func _ready():
	change_level(currentLevelIndex)

func change_level(levelIndex):
	currentLevelIndex = levelIndex
	get_tree().change_scene_to_file(levelScenes[levelIndex].resource_path)
	
