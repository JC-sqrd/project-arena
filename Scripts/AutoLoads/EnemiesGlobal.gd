extends Node


static var global_enemies : Array[Enemy]
signal enemy_died(enemy : Enemy)

func _ready():
	print("Enemies Global ready")
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		global_enemies.append(enemy)
	pass

func add_enemy(enemy : Enemy):
	enemy.enemy_died.connect(remove_enemy)
	global_enemies.append(enemy)
	pass

func remove_enemy(enemy : Enemy):
	enemy_died.emit(enemy)
	global_enemies.erase(enemy)
	pass

func get_enemies() -> Array[Enemy]:
	return global_enemies
