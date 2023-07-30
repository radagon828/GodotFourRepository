extends Node2D

#resources
var inventory = preload("res://Scenes/UIElements/InventoryMenu/NewInventory.tres")
var dialogInstance = preload("res://Scenes/UIElements/Dialogue/dialog_box.tscn")
var examineBox: Panel = null

#dialogue
@export var door_unlocking_dialog: Array[String] = ["Door Unlocked"]

#Bool
@export var is_unlocked: bool = false
var in_use_range: bool = false 

#Nodes
@onready var doorHitbox: Area2D = $Area2D
@onready var doorSprite: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = $"../../Player"

func _process(delta):
	doorSprite.frame = 0 if is_unlocked else 1
	if Input.is_action_just_pressed("use") && in_use_range && !is_unlocked:
		for item_index in inventory.items.size():
			var item = inventory.items[item_index]
			if item is Item:
				if item.name == "SimpleKey":
					door_unlock_event(item_index, item)
					break

func on_door_unlocked():
	examineBox.queue_free()
	get_tree().paused = false

func door_unlock_event(item_index, item):
	is_unlocked = true
	inventory.remove_item(item_index)
	
	instantiate_dialog()
	
	get_tree().paused = true

func instantiate_dialog():
	examineBox = dialogInstance.instantiate()
	var dialogText = examineBox.get_child(0).get_child(0)
	dialogText.dialog = door_unlocking_dialog
	dialogText.on_dialog_end.connect(on_door_unlocked)
	player.add_child(examineBox)
	
func _on_area_2d_area_entered(area):
	in_use_range = true
	print("use_key")


func _on_area_2d_area_exited(area):
	in_use_range = false
	print("can't_use_key")
