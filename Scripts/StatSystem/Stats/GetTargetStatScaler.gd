class_name GetTargetStatScaler
extends Node

@export var stat : Stat
@export var scale_with_stat_id : String
var scale_with_stat : Stat
var stat_manager : StatManager
var target : Entity
@export var scale_ratio : float = 1
@export var scale_base_value : bool = false

var _old_scaled_value : float = 0
var _original_base_value : float = 0

func _ready():
	owner.ready.connect(on_owner_ready)
	on_ready()
	pass

func on_owner_ready():
	if owner is Entity:
		target = owner
	elif owner.has_method("get_target"):
		target = owner.get_actor()
	target.ready.connect(on_target_ready)
	pass

func on_target_ready():
	if owner.has_method("get_target"):
		stat_manager = owner.get_target().stat_manager
		scale_with_stat = stat_manager.get_stat(scale_with_stat_id)
		pass
	scale_with_stat.stat_changed.connect(apply_scaled_value)
	stat.stat_changed.connect(_update_base_value)
	_original_base_value = stat.stat_value
	apply_scaled_value()
	pass

func on_ready():
	if owner.has_method("get_target"):
		if owner.get_target() != null:
			stat_manager = owner.get_target().stat_manager
			scale_with_stat = stat_manager.get_stat(scale_with_stat_id)
			scale_with_stat.stat_derived_value_changed.connect(apply_scaled_value)
			stat.stat_derived_value_changed.connect(_update_base_value)
			_original_base_value = stat.stat_value
			apply_scaled_value()
	pass

func apply_scaled_value():
	if scale_base_value:
		stat.stat_value -= _old_scaled_value
		var new_scaled_value = scale_with_stat.stat_derived_value * scale_ratio
		stat.stat_value += new_scaled_value
		_old_scaled_value = new_scaled_value
		stat.update_stat()
	else:	
		stat.bonus_value -= _old_scaled_value
		var new_scaled_value = scale_with_stat.stat_derived_value * scale_ratio
		stat.bonus_value += new_scaled_value
		_old_scaled_value = new_scaled_value
		stat.update_stat()
	pass

func _update_base_value():
	_original_base_value = stat.stat_value
	pass
