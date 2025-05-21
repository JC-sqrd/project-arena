class_name BonusStatStatusEffect
extends StatusEffect


@export var bonus_stat : Stat
@export var stat_id : String
@export var is_percentage : bool = false

var stat : Stat 
var _old_bonus_value : float = 0

func _ready():
	duration_end.connect(on_duration_end)
	add_child(timer)
	pass

func activate_status_effect(target : Entity):
	target_entity = target
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	active = true
	timer.timeout.connect(
		func():
			duration_end.emit()
			active = false
			queue_free()
	)
	stat = target_entity.stat_manager.get_stat(stat_id)
	if !is_percentage:
		_old_bonus_value = bonus_stat.stat_derived_value
		stat.bonus_value += _old_bonus_value
	else :
		_old_bonus_value = stat.stat_derived_value * bonus_stat.stat_derived_value
		stat.bonus_value += _old_bonus_value
	stat.update_stat()
	#stat.stat_derived_value_changed.connect(on_target_stat_changed)
	timer.start()
	pass

func on_target_stat_changed():
	#stat.stat_derived_value_changed.disconnect(on_target_stat_changed)
	if !is_percentage:
		_old_bonus_value = bonus_stat.stat_derived_value
		stat.bonus_value += _old_bonus_value
	else :
		_old_bonus_value = stat.stat_derived_value * bonus_stat.stat_derived_value
		stat.bonus_value += _old_bonus_value
	stat.update_stat()
	#stat.stat_derived_value_changed.connect(on_target_stat_changed)
	pass

func on_duration_end():
	stat.bonus_value -= _old_bonus_value
	stat.update_stat()
	pass
