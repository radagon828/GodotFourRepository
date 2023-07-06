extends Node

signal no_health

@export var max_health = 1 : 
	get:
		return max_health
	set(value):
		max_health = value

var health = max_health :
	get:
		return health
	set(value):
		health = value
		if health <= 0:
			emit_signal("no_health")
 
func _ready():
	self.health = max_health

