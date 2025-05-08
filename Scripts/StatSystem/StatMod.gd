extends Node

class_name StatMod

enum MOD_VALUE_TYPE {FLAT, PERCENTAGE}
enum MOD_TYPE {ETERNAL, FLEETING}


@export var mod_id : String = "default_mod"
@export var stat_to_modify : Stat
@export var mod_value : float = 0
var final_mod_value : float = mod_value
var liftime : float = 1
var isActive : bool = false

var source : Node

var old_stat_value : float

func _init():
	final_mod_value = calculate_mod_final_value()
	pass

func _ready():
	final_mod_value = calculate_mod_final_value()
	#stat_to_modify.ready.connect(apply_mod_to_stat)
	apply_mod_to_stat()
	pass
	
func calculate_mod_final_value() -> float:
	return mod_value

func apply_mod_to_stat():
	stat_to_modify.bonus_value += calculate_mod_final_value()
	stat_to_modify.mods.append(self)
	stat_to_modify.update_stat()
	pass

func remove_mod_from_stat():
	if stat_to_modify.mods.has(self):
		stat_to_modify.bonus_value -= calculate_mod_final_value()
		stat_to_modify.mods.erase(self)
		stat_to_modify.update_stat()
	pass
