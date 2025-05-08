class_name StatDivider
extends Stat


@export var a_stat : Stat
@export var b_stat : Stat
@export var divide_base_value : bool = false
#@export var stat : Stat
#@export var scale_with_stat : Stat
#@export var scale_base_value : bool = false

var _old_scaled_value : float = 0
var _original_base_value : float = 0

func _ready():
	#scale_with_stat.stat_changed.connect(apply_added_value)
	#stat.stat_changed.connect(_update_base_value)
	#_original_base_value = stat.stat_value
	a_stat.stat_derived_value_changed.connect(apply_added_value)
	b_stat.stat_derived_value_changed.connect(apply_added_value)
	apply_added_value()
	pass

func apply_added_value():
	if divide_base_value:
		stat_value = a_stat.stat_value / b_stat.stat_value
	else:
		stat_value = a_stat.stat_derived_value / b_stat.stat_derived_value
	update_stat()
	#if scale_base_value:
		#stat.stat_value -= _old_scaled_value
		#var new_added_value = scale_with_stat.stat_derived_value 
		#stat.stat_value += new_added_value
		#_old_scaled_value = new_added_value
		#stat.update_stat()
	#else:	
		#stat.bonus_value -= _old_scaled_value
		#var new_added_value = scale_with_stat.stat_derived_value 
		#stat.bonus_value += new_added_value
		#_old_scaled_value = new_added_value
		#stat.update_stat()
	pass

func _update_base_value():
	#_original_base_value = stat.stat_value
	pass
