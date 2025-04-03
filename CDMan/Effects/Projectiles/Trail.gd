extends Line2D
class_name Trails
 
var queue : Array
@export var MAX_LENGTH : int
 
func _process(_delta):
	var pos = _get_position()
 
	queue.push_front(pos)
 
	if queue.size() > MAX_LENGTH:
		queue.pop_back()
 
	clear_points()
	#print(global_position, get_parent().global_position)
 
	for point in queue:
		add_point(point)
 
func _get_position():
	return get_parent().position
	#return get_global_mouse_position()
	
	#top level visibility turned on prevents point from not being on the right position
