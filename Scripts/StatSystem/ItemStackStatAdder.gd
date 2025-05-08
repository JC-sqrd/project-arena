class_name ItemStackStat
extends Node

@export var item : Item
@export var stat_to_scale : Stat
@export var percent_per_stack : float = 1
@export var scale_base_value : bool = false
var item_stack : int = 1

var _old_added_value : float = 0



func _ready():
	item.stack_changed.connect(apply_stack_scale)
	apply_stack_scale()
	pass

func apply_stack_scale():
	if scale_base_value:
		stat_to_scale.stat_value -= _old_added_value
		var new_scaled_value = (item.stack * percent_per_stack)
		stat_to_scale.stat_value += new_scaled_value
		_old_added_value = new_scaled_value
		stat_to_scale.update_stat()
	else:
		stat_to_scale.bonus_value -= _old_added_value
		var new_scaled_value = (item.stack * percent_per_stack) 
		stat_to_scale.bonus_value += new_scaled_value
		_old_added_value = new_scaled_value
		stat_to_scale.update_stat()
	pass
