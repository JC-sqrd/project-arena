class_name SpawnEverySecond
extends SpawnTiming



func is_valid(current_wave_seconds : float) -> bool:
	if current_wave_seconds == 0:
		return false
	return true
	
