extends Node

@export var levelScenes: Array[PackedScene]
@onready var levels = get_tree().get_nodes_in_group("Doors")
var test_number = 3

var currentLevelIndex = 0

func _ready():
	change_level(currentLevelIndex)

func change_level(levelIndex):
	currentLevelIndex = levelIndex
	get_tree().change_scene_to_file(levelScenes[levelIndex].resource_path)

func _process(delta):
#	print(test_number)
	print(levels.size())
	for member in levels:
		print(member)

