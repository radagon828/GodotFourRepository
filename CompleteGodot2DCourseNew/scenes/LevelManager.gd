extends Node
#this node is set to autoload in the project settings
export(Array, PackedScene) var levelScenes

var currentLevelIndex = 0

	
#changes level to file indicated by index
func change_level(levelIndex):
	currentLevelIndex = levelIndex
	if (currentLevelIndex == levelScenes.size()):
		currentLevelIndex = 0
		
	get_tree().change_scene(levelScenes[currentLevelIndex].resource_path)

func increment_level():
	change_level(currentLevelIndex + 1)
