class_name WeightedEnemySpawn
extends EnemySpawn

@export var weight : float = 0


func spawn_enemy(spawn_position : Vector2, player : PlayerCharacter) -> Enemy:
	var enemy = enemy_scene.instantiate() as Enemy
	if enemy is Enemy:
		enemy.position = spawn_position
		enemy.player = player
		pass
	return enemy

func instantiate_enemy() -> Enemy:
	return enemy_scene.instantiate() as Enemy
	
