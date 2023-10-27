extends Node2D

#resources
var inventory = preload("res://Scenes/UIElements/InventoryMenu/NewInventory.tres")
var dialogInstance = preload("res://Scenes/UIElements/Dialogue/dialog_box.tscn")
var examineBox: Panel = null

#custom data
@export var door_unlocking_dialog: Array[String] = ["Door unlocked with key"]
@export var door_locked_dialog: Array[String] = ["Door is locked"]

@export var area_index: int :
	get:
		return area_index
	set(value):
		area_index = value

@export var is_unlocked: int :
	get:
		return is_unlocked
	set(value):
		is_unlocked = value

var in_use_range: bool = false 

#Nodes
@onready var doorHitbox: Area2D = $Area2D
@onready var doorSprite: Sprite2D = $Sprite2D
@onready var canvas: CanvasLayer = $"../../CanvasLayer"
#signal
signal dialog_event
signal event_end
signal door_entered(area_index)

func _process(delta):
	doorSprite.frame = 0 if is_unlocked == 1 else 1
	if Input.is_action_just_pressed("use") && in_use_range && is_unlocked == 0:
		locked_door_interaction()
#		print("door_ is locked")
	elif Input.is_action_just_pressed("use") && in_use_range && is_unlocked == 1:
		unlocked_door_interaction()
		print("door_ is unlocked")

#checks for a key in the players inventory and runs door unlock event if key is found
func locked_door_interaction():
	var itemCount = 0
	for item_index in inventory.items.size():
			var item = inventory.items[item_index]
			if item is Item:
				if item.name == "SimpleKey":
					door_unlock_event(item_index, item)
					break
			itemCount += 1
	if itemCount == inventory.items.size(): door_locked_event() 


#sends signal to level manager with the index of the area the door leads into
func unlocked_door_interaction():
#	emit_signal("door_entered", area_index)
#	for some reason not accessing the level manager directly causes this to not work, not sure if i should be concerned
	LevelManager.change_level(area_index)
	print("unlocked_interaction")

#after signal that door dialogue has ended has been recieved the dialogue is deleted
func on_door_event_end():
	examineBox.queue_free()
	emit_signal("event_end")

#unlocks door and plays dialogue box indicating that it has been unlocked, 
#also removes key from inventory
func door_unlock_event(item_index, item):
	is_unlocked = 1
	inventory.remove_item(item_index)
	instantiate_dialog(door_unlocking_dialog)

#plays dialogue for the door being locked
func door_locked_event():
	get_tree().paused = true
	instantiate_dialog(door_locked_dialog)
	
#creates dialog box for door event, also sends event signal to area script
func instantiate_dialog(door_dialog):
	emit_signal("dialog_event")
	examineBox = dialogInstance.instantiate()
	var dialogText = examineBox.get_child(0).get_child(0)
	dialogText.dialog = door_dialog
	dialogText.on_dialog_end.connect(on_door_event_end)
	canvas.add_child(examineBox)

#these functions detect when a player is in intercation range
func _on_area_2d_area_entered(area):
	in_use_range = true
	print("can open")
	
func _on_area_2d_area_exited(area):
	in_use_range = false
	
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"is_unlocked" : is_unlocked,
		"pos_x" : position.x,
		"pos_y" : position.y,
		"area_index" : area_index
	}
	return save_dict
