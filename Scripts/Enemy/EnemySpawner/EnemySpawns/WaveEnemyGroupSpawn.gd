class_name WaveEnemyGroupSpawn
extends WaveEnemySpawn


func on_one_second_passed():
	for spawn_timing in spawn_timings:
		if spawn_timing.is_valid(wave.current_time):
			var spawn : Sprite2D = spawn_sprite.instantiate() as Sprite2D
			var spawn_position : Vector2 = wave.wave_spawner.get_random_position()#Vector2(randi() % int(wave.wave_spawner.spawn_zone.x), randi() % int(wave.wave_spawner.spawn_zone.y))
			spawn.global_position = spawn_position
			get_tree().root.add_child(spawn)
			get_tree().create_timer(1, false, true, false).timeout.connect(
				func():
					var enemy : Enemy = enemy_scene.instantiate() as Enemy
					enemy.player = wave.player
					enemy.global_position = spawn_position
					EnemiesGlobal.add_enemy(enemy)
					get_tree().root.add_child(enemy)
					enemy.stat_manager.stats["level"].stat_value += enemy_level
					enemy.stat_manager.stats["level"].update_stat()
					enemy_spawned.emit(enemy)
					spawn.queue_free()
					pass
			) 
			pass
		pass
	pass
