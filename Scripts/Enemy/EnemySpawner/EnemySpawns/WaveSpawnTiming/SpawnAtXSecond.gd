class_name SpawnAtXSecond
extends SpawnTiming

@export var spawn_at_x_second : float

func is_valid(current_wave_seconds : float) -> bool:
	if current_wave_seconds == spawn_at_x_second:
		return true
	return false
