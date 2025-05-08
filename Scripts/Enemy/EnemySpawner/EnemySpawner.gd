class_name EnemySpawner
extends Node2D

@export var enemy_spawns : Array[EnemySpawn]
@export var mini_boss_scene : PackedScene
@export var mini_boss_2_scene : PackedScene
@export var spawn_time : float = 0
@export var spawn_sprite_scene : PackedScene
@export var player : PlayerCharacter
@export var spawn_zone : Vector2 = Vector2(200, 200)
@export var auto_spawn : bool = true
@export var draw_spawn_zone : bool = false
@export_range(1, 5, 1) var spawn_rate_range : int = 1
@onready var timer = $Timer

var time : float = 0
var health_counter : float 
var defense_counter : float

var multiplier : float = 0
var defense_multiplier : float = 0

var enemy_level : int = 0
var total_weight : float = 0

var mini_boss_spawned : bool = false
var mini_boss_2_spawned : bool = false

func _ready():
	player = Globals.player
	if auto_spawn:
		timer.timeout.connect(_on_timeout)
		timer.start()
	for child in get_children():
		if child is WeightedEnemySpawn:
			total_weight += child.weight
	#_on_timeout()
	#_on_timeout()
	#_on_timeout()
	#spawn_enemy(Vector2(randi() % int(spawn_zone.x), randi() % int(spawn_zone.y)) )
	#spawn_enemy()
	#spawn_enemy()
	#for index in 200:
		#_on_timeout() 
	#
	pass

func _on_timeout():
	timer.stop()
	var enemy_position : Vector2 = Vector2(randi() % int(spawn_zone.x), randi() % int(spawn_zone.y)) 
	var spawn_sprite : Sprite2D = spawn_sprite_scene.instantiate() as Sprite2D
	spawn_sprite.position = enemy_position
	add_child(spawn_sprite)
	get_tree().create_timer(spawn_time, false, true, false).timeout.connect(
		func():
			spawn_sprite.queue_free()
			spawn_enemy(enemy_position)
	)
	pass

func spawn_enemy(enemy_position : Vector2):
	var enemy : Enemy
	var random : float = randf_range(0, total_weight)
	var cursor : float = 0
	for spawn in enemy_spawns:
		cursor += spawn.weight
		if cursor >= random:
			if spawn.enemy_scene != null:
				enemy = spawn.instantiate_enemy()
				enemy.position = enemy_position
				enemy.player = player
				add_child(enemy)
				print("Enemy spawned: " + str(enemy))
				#enemy.stat_manager.get_stat("level").stat_value += clampf(enemy_level, 1, 30)
				enemy.stat_manager.stats["level"].stat_value += clampf(enemy_level, 1, 30)
				enemy.stat_manager.stats["level"].update_stat()
				EnemiesGlobal.add_enemy(enemy)
			pass
	timer.start()
	pass

func _process(delta):
	if draw_spawn_zone:
		queue_redraw()
	time += delta	
	health_counter += delta
	defense_counter += delta
	
	
	#if floor(GameState.mins) >= 5 and !mini_boss_spawned:
		#var mini_boss : Enemy = mini_boss_scene.instantiate()
		#mini_boss.position = Vector2(randi() % int(spawn_zone.x), randi() % int(spawn_zone.y))
		#mini_boss.player = player
		#add_child(mini_boss)
		#mini_boss.stat_manager.stats["level"].stat_value += clampf(enemy_level, 1, 30)
		#mini_boss.stat_manager.stats["level"].update_stat()
		#mini_boss_spawned = true
		#pass
	
	#if floor(GameState.mins) >= 10 and !mini_boss_2_spawned:
		#var mini_boss : Enemy = mini_boss_2_scene.instantiate()
		#mini_boss.position = Vector2(randi() % int(spawn_zone.x), randi() % int(spawn_zone.y))
		#mini_boss.player = player
		#add_child(mini_boss)
		#mini_boss.stat_manager.stats["level"].stat_value += clampf(enemy_level, 1, 30)
		#mini_boss.stat_manager.stats["level"].update_stat()
		#mini_boss_2_spawned = true
		#pass
	
	if health_counter >= 45:
		print("45 seconds passed, increased enemy level")
		enemy_level += 1
		#multiplier += 0.1
		health_counter = 0
	if defense_counter >= 60:
		print("60 seconds passed, increased enemy armor and magic resistance")
		#defense_multiplier += 0.05
		defense_counter = 0
			
	pass

func _draw():
	if draw_spawn_zone:
		var spawn_rect = Rect2(position, spawn_zone)
		draw_rect(spawn_rect, Color(Color.RED, 0.1), true)
