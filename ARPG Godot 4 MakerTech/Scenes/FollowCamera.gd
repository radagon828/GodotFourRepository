extends Camera2D

@export var tile_map: TileMap

func _ready():
	
	var visibleArea = tile_map.get_used_rect();
	var tileSize = tile_map.cell_quadrant_size;
	var upperLeftCorner = visibleArea.position * tileSize;
	var lowerRightCorner = (visibleArea.position + visibleArea.size) * tileSize;   
	limit_left = tile_map.position.x + upperLeftCorner.x;
	limit_top = tile_map.position.y + upperLeftCorner.y;
	limit_right = tile_map.position.x + lowerRightCorner.x;
	limit_bottom = tile_map.position.y + lowerRightCorner.y;
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
