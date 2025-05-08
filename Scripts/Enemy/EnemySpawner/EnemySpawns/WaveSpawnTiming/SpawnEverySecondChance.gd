class_name SpawnEverySecondChance
extends SpawnTiming


@export_range(0,1) var spawn_chance : float = 0


func is_valid(current_wave_seconds : float) -> bool:
	if spawn_chance >= randf_range(0, 1) and current_wave_seconds > 0:
		return true
	return false
	
