class_name SlowStatusEffect
extends StatusEffect

@export var slow_percentage : float = 0
var target_move_speed : Stat 

func activate_status_effect(target : Entity):
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = duration
	timer.timeout.connect(_on_duration_end)
	#get_tree().create_timer(duration, false, true, false).timeout.connect(_on_duration_end)
	target_entity = target
	target_move_speed = target.stat_manager.get_stat("move_speed")
	if target_move_speed != null:
			target_move_speed.multipliers += -slow_percentage
			target_move_speed.update_stat()
			pass
	else:
		print("status effect target null")
	timer.start()
	pass

func _on_duration_end():
	if target_move_speed != null:
		target_move_speed.multipliers -= -slow_percentage
		target_move_speed.update_stat()
		pass
	queue_free()
	pass
