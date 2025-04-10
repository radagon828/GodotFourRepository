extends Node3D

@export var world_size: Vector3 = Vector3(16, 16, 16)
@export_range(-1, 1) var cut_off: float = 0.5
@onready var default_cube: CSGBox3D = $DefaultCube

var cubes: int = 0

func _ready() -> void:
	Performance.add_custom_monitor("game/cubes", func(): return cubes)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#var random_generator = RandomNumberGenerator.new()
	var random_generator = FastNoiseLite.new()
	
	var start_time = Time.get_ticks_usec()
	
	for x in range(world_size.x):
		for z in range(world_size.z):
			for y in range(world_size.y):
				#var random = random_generator.randf()
				var random = random_generator.get_noise_3d(x, y, z)
				if random > cut_off:
					var new_cube = default_cube.duplicate()
					new_cube.position = Vector3(x, y, z)
					add_child(new_cube)
					cubes +=1
	remove_child(default_cube)
	
	var end_time = Time.get_ticks_usec()
	var gen_time = (end_time - start_time) / 1000000.0
	print_debug("Blocks in world: %s\n Gen Time: %s" % [cubes, gen_time])

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
