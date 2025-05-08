class_name EnemyWave
extends Wave



@export var wave_duration : float 
@onready var current_time : float = wave_duration

var enemy_spawns : Array[EnemySpawn]
var wave_enemies : Array[Enemy]

var player : PlayerCharacter

func _enter_tree() -> void:
	child_entered_tree.connect(on_child_entered_tree)

func _ready():
	super()
	time_left_in_wave = current_time
	wave_timer.timeout.connect(on_wave_timer_timeout)
	wave_end.connect(on_wave_end)

func on_child_entered_tree(node : Node):
	if node is WaveEnemySpawn:
		node.wave = self
		enemy_spawns.append(node)
		node.enemy_spawned.connect(on_wave_enemy_spawned)

func start_wave():
	wave_start.emit(self)
	wave_timer.start(1)
	current_time = wave_duration
	active = true
	pass

func on_wave_timer_timeout():
	current_time -= 1
	time_left_in_wave = current_time
	one_second_passed.emit()
	if current_time <= 0:
		wave_end.emit(self)
		active = false
		wave_timer.stop()
		current_time = wave_duration
		print(name + " end")
	pass

func on_wave_enemy_spawned(enemy : Enemy):
	wave_enemies.append(enemy)
	pass

func on_wave_end(wave : Wave):
	for enemy in wave_enemies:
		if enemy != null:
			enemy.queue_free()
		EnemiesGlobal.global_enemies.erase(enemy)
	player.stat_manager.get_stat("current_health").stat_derived_value = player.stat_manager.get_stat("max_health").stat_derived_value
	player.stat_manager.get_stat("current_mana").stat_derived_value = player.stat_manager.get_stat("max_mana").stat_derived_value
	wave_enemies.clear()
	pass
