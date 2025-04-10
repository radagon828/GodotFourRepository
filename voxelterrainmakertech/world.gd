extends Node3D

@export var world_size: Vector3 = Vector3(16, 16, 16)
@export_range(-1, 1) var cut_off: float = 0.5
@onready var default_cube: CSGBox3D = $DefaultCube


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#var random_generator = RandomNumberGenerator.new()
	var random_generator = FastNoiseLite.new()
	
	for x in range(world_size.x):
		for z in range(world_size.z):
			for y in range(world_size.y):
				#var random = random_generator.randf()
				var random = random_generator.get_noise_3d(x, y, z)
				if random > cut_off:
					var new_cube = default_cube.duplicate()
					new_cube.position = Vector3(x, y, z)
					add_child(new_cube)
	remove_child(default_cube)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
