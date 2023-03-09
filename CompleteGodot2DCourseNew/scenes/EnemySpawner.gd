extends Position2D

enum Direction { RIGHT, LEFT }

export(PackedScene) var enemyScene
export(Direction) var startDirection

var currentEnemyNode = null
var spawnOnNextTick = false

#calls check_enemy_spawn if timer runs out
# spawns initial enemy
func _ready() -> void:
	$SpawnTimer.connect("timeout", self, "on_spawn_timer_timeout")
	call_deferred("spawn_enemy")
	
#spawns enemy instance as a child of the Enemies node
#spawns it at spawner position
func spawn_enemy():
	currentEnemyNode = enemyScene.instance()
	currentEnemyNode.startDirection = Vector2.RIGHT if startDirection == Direction.RIGHT else Vector2.LEFT
	get_parent().add_child(currentEnemyNode)
	currentEnemyNode.global_position = global_position

#check if current enemy exists or not
func check_enemy_spawn():
	#if the current enemy node no longer exists
	if (!is_instance_valid(currentEnemyNode)):
		#if spawn on next tick is true spawn enemy
		if (spawnOnNextTick):
			spawn_enemy()
			spawnOnNextTick = false
		#if not wait an additional 1.5 seconds to spawn a new enemy
		else:
			spawnOnNextTick = true

func on_spawn_timer_timeout():
	check_enemy_spawn()
