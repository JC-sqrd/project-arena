class_name Stat
extends Node

@export var stat_name : String = "default_stat"

@export var stat_value : float = 0 : set = _set_stat_value , get = _get_stat_value
@export var can_be_negative : bool = true

var stat_derived_value : float : set = _set_stat_derived_value
var bonus_value : float = 0 
var mod_values : float
var multipliers : float = 1

var emit_stat_changed_signal : bool = true

var mods : Array

signal stat_changed
signal stat_derived_value_changed
signal stat_derived_value_changed_data (old_value : float, new_value : float)
signal stat_changed_data (old_value : float, new_value : float)
signal stat_updated ()
signal stat_updated_data(new_value : float)



func _ready():
	update_stat()
	pass

func update_stat():
	for value in mod_values:
		bonus_value += value
	stat_derived_value = (stat_value + bonus_value) * multipliers
	#stat_changed.emit()
	stat_updated.emit()
	stat_updated_data.emit(stat_derived_value)
	pass

func _set_stat_value(new_value : float):
	var old_value : float = stat_value
	stat_value = new_value
	stat_derived_value = stat_value
	if emit_stat_changed_signal:
		stat_changed_data.emit(old_value, new_value)
		stat_changed.emit()
	pass
	
func _get_stat_value() -> float:
	return stat_value

func _set_stat_derived_value(new_value : float):
	var old_value : float = stat_derived_value
	if !can_be_negative:
		if new_value < 0:
			stat_derived_value = 0
		else:
			stat_derived_value = new_value
	else:
		stat_derived_value = new_value
	if emit_stat_changed_signal:
		stat_derived_value_changed_data.emit(old_value, new_value)
		stat_derived_value_changed.emit()
	#stat_updated.emit()
	#stat_updated_data.emit(stat_derived_value)
	pass

func _on_stat_changed():
	pass # Replace with function body.
	
