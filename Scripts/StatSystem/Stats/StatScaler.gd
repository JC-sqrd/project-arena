class_name StatScaler
extends Node

enum ScalingType{LINEAR, HYPERBOLIC}

@export var stat : Stat
@export var scale_with_stat : Stat
@export var scale_ratio : float
@export var scaling_type : ScalingType = ScalingType.LINEAR
@export var scale_base_value : bool = false

var _old_scaled_value : float = 0
var _original_base_value : float = 0

func _ready():
	scale_with_stat.stat_changed.connect(apply_scaled_value)
	scale_with_stat.stat_updated.connect(apply_scaled_value)
	stat.stat_changed.connect(_update_base_value)
	#stat.stat_updated.connect(_update_base_value)
	_original_base_value = stat.stat_value
	apply_scaled_value()
	pass
	
func apply_scaled_value():
	if scale_base_value:
		stat.emit_stat_changed_signal = false
		stat.stat_value -= _old_scaled_value
		stat.emit_stat_changed_signal = true
		var new_scaled_value = calculate_scale_value(scale_with_stat.stat_derived_value,scale_ratio)
		stat.stat_value += new_scaled_value
		_old_scaled_value = new_scaled_value
		stat.update_stat()
	else:	
		stat.bonus_value -= _old_scaled_value
		var new_scaled_value = calculate_scale_value(scale_with_stat.stat_derived_value, scale_ratio)
		stat.bonus_value += new_scaled_value
		_old_scaled_value = new_scaled_value
		stat.update_stat()
	pass

func calculate_scale_value(x: float, ratio : float) -> float:
	if scaling_type == ScalingType.HYPERBOLIC:
		return 1.0 - (1.0 / 1.0 +(x * ratio))
	elif scaling_type == ScalingType.LINEAR:
		return x * ratio
	return - 1

func _update_base_value():
	_original_base_value = stat.stat_value
	pass

class ScaleType:
	func get_scale_value(x : float, ratio : float) -> float:
		return -1
	pass

class LinearScaleType extends ScaleType:
	func get_scale_value(x : float, ratio : float) -> float:
		return x * ratio
	pass

class HyperBolicScaleType extends ScaleType:
	func get_scale_value(x : float, ratio : float) -> float:
		return 1.0 - (1.0 / 1.0 +(x * ratio))
	pass
