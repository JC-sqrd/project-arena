class_name EnemySpawn
extends EntitySpawn


@export var enemy_scene : PackedScene
@export var spawn_sprite : PackedScene
@export var enemy_level : int = 1

signal enemy_spawned(enemy : Enemy)

func spawn_enemy(spawn_position : Vector2, player : PlayerCharacter) -> Enemy:
	var enemy = enemy_scene.instantiate() as Enemy
	if enemy is Enemy:
		enemy.position = spawn_position
		enemy.player = player
		enemy_spawned.emit(enemy)
		pass
	return enemy

func instantiate_enemy() -> Enemy:
	return enemy_scene.instantiate() as Enemy
