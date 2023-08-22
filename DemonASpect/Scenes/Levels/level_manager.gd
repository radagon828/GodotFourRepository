extends Node

@export var levelScenes: Array[PackedScene]
#@onready var levels = get_tree().get_nodes_in_group("Doors")

#@onready var 

var currentLevelIndex = 0

func _ready():
	get_tree().change_scene_to_file(levelScenes[currentLevelIndex].resource_path)
	BaseLevel.change_scene_name()
	
func change_level(levelIndex):
	BaseLevel.save_game()
	
	call_deferred("goto_level", levelIndex)

func goto_level(levelIndex):
	currentLevelIndex = levelIndex
	get_tree().change_scene_to_file(levelScenes[levelIndex].resource_path)
	BaseLevel.load_game()
	BaseLevel.change_scene_name()
