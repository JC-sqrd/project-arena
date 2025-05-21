extends Control

@export var wave_spawner : WaveSpawner
@export var start_wave_button : Button
@export var wave_timer_label : Label
@export var current_wave_label : Label

func _ready():
	if start_wave_button != null:
		start_wave_button.pressed.connect(on_start_wave_button_pressed)
		start_wave_button.focus_mode = 0
	wave_spawner.current_wave_end.connect(on_current_wave_end)
	pass

func on_start_wave_button_pressed():
	wave_spawner.start_next_wave()
	current_wave_label.text = wave_spawner.current_wave.name
	start_wave_button.disabled = true
	pass


func _physics_process(delta: float) -> void:
	if wave_spawner.wave_active:
		wave_timer_label.text = str(ceilf(wave_spawner.time_left))


func on_current_wave_end(current_wave : Wave):
	start_wave_button.disabled = false
	pass
