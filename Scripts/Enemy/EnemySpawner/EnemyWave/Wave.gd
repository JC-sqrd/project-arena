class_name Wave
extends Node

@export var next_wave : Wave
var wave_timer : Timer = Timer.new()
var wave_spawner : WaveSpawner
var active : bool = false
var time_left_in_wave : float = 0


signal wave_start(wave : Wave)
signal wave_started()
signal wave_ended()
signal wave_end(wave : Wave)

signal one_second_passed()
signal one_minute_passed()

func _ready() -> void:
	wave_timer.one_shot = false
	wave_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	add_child(wave_timer)

func start_wave():
	pass
