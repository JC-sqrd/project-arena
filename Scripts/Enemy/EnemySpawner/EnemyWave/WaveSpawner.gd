class_name WaveSpawner
extends Node2D



@export var player : PlayerCharacter
@export var spawn_zone : Vector2 = Vector2(200, 200)
@export_group("X")
@export var min_x : float
@export var max_x : float
@export_group("Y")
@export var min_y : float
@export var max_y : float
@export var root_wave : Wave
@export var spawn_shape : CollisionShape2D
@export var draw_spawn_zone : bool = false


var waves : Array[Wave]
var current_wave : Wave
var time_left : float = 0
var wave_active : bool = false

signal current_wave_start(current_wave : Wave)
signal current_wave_end(current_wave : Wave)

func _enter_tree() -> void:
	child_entered_tree.connect(on_child_entered_tree)


func _ready() -> void:
	player = Globals.player
	for child in get_children():
		if child is EnemyWave:
			child.player = player
	if root_wave != null:
		current_wave = root_wave

func _draw():
	if draw_spawn_zone: 
		var spawn_rect = Rect2(Vector2(-(spawn_zone.x / 2), -(spawn_zone.y / 2)), spawn_zone)  #Rect2(global_position.x - (spawn_zone.x / 2), global_position.y - (spawn_zone.y / 2), spawn_zone.x, spawn_zone.y) 
		draw_rect(spawn_rect, Color(Color.RED, 0.1), true)
	

func start_next_wave():
	current_wave.wave_end.connect(on_current_wave_end)
	current_wave_start.emit(current_wave)
	current_wave.start_wave()
	wave_active = true
	pass

func _physics_process(delta: float) -> void:
	if wave_active:
		time_left = current_wave.time_left_in_wave
	pass

func on_current_wave_end(wave : Wave):
	current_wave.wave_end.disconnect(on_current_wave_end)
	if wave.next_wave != null:
		current_wave = wave.next_wave
	current_wave_end.emit(current_wave)
	wave_active = false
	print("Current wave ended")
	pass

func on_child_entered_tree(node : Node):
	if node is Wave:
		node.wave_spawner = self
	if node is EnemyWave:
		node.player = player
		pass

func get_random_position() -> Vector2:
	var rand_x : int = randi_range(global_position.x - (spawn_zone.x / 2), global_position.x + (spawn_zone.x / 2))
	var rand_y : int = randi_range(global_position.y - (spawn_zone.y / 2), global_position.y + (spawn_zone.y / 2))
	return Vector2(rand_x,rand_y)
