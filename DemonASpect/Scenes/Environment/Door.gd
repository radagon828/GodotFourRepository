extends Node2D

#resources
var inventory = preload("res://Scenes/UIElements/InventoryMenu/NewInventory.tres")
var dialogInstance = preload("res://Scenes/UIElements/Dialogue/dialog_box.tscn")
var examineBox: Panel = null

#custom data
@export var door_unlocking_dialog: Array[String] = ["Door Unlocked"]
@export var area_index: int = 0

#Bool
@export var is_unlocked: bool = false
var in_use_range: bool = false 

#Nodes
@onready var doorHitbox: Area2D = $Area2D
@onready var doorSprite: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = $"../../Player"

#signal
signal dialog_event
signal event_end
signal door_entered(area_index)

func _process(delta):
	doorSprite.frame = 0 if is_unlocked else 1
	if Input.is_action_just_pressed("use") && in_use_range && !is_unlocked:
		locked_door_interaction()
	elif Input.is_action_just_pressed("use") && in_use_range && is_unlocked:
		unlocked_door_interaction()

func locked_door_interaction():
	for item_index in inventory.items.size():
			var item = inventory.items[item_index]
			if item is Item:
				if item.name == "SimpleKey":
					door_unlock_event(item_index, item)
					break
					
func unlocked_door_interaction():
	emit_signal("door_entered", area_index)

func on_door_unlocked():
	examineBox.queue_free()
	emit_signal("event_end")
	get_tree().paused = false
	
func door_unlock_event(item_index, item):
	is_unlocked = true
	inventory.remove_item(item_index)
	
	instantiate_dialog()
	get_tree().paused = true
	emit_signal("dialog_event")

func instantiate_dialog():
	examineBox = dialogInstance.instantiate()
	var dialogText = examineBox.get_child(0).get_child(0)
	dialogText.dialog = door_unlocking_dialog
	dialogText.on_dialog_end.connect(on_door_unlocked)
	player.add_child(examineBox)
	
func _on_area_2d_area_entered(area):
	in_use_range = true

func _on_area_2d_area_exited(area):
	in_use_range = false
