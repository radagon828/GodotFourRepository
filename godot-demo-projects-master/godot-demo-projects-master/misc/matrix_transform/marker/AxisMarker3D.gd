@tool
extends Node3D
class_name AxisMarker3D
@icon("res://marker/AxisMarker3D.svg")


func _process(_delta):
	var holder: Node3D = get_child(0).get_child(0)
	var cube: Node3D = holder.get_child(0)
	# "Hide" the origin vector if the AxisMarker is at (0, 0, 0)
	if position == Vector3():
		holder.transform = Transform3D()
		cube.transform = Transform3D().scaled(Vector3.ONE * 0.0001)
		return

	holder.transform = Transform3D(Basis(), position / 2)
	holder.transform = holder.transform.looking_at(position, Vector3.UP)
	holder.transform = get_parent().global_transform * holder.transform
	cube.transform = Transform3D(Basis().scaled(Vector3(0.1, 0.1, position.length())))
