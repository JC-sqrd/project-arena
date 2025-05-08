extends Node

class_name StatModManager

#@export var stat_manager : StatManager
#var mods : Array
#
#func _ready():
	#assert(stat_manager != null, "Stat manager reference is null")
	#stat_manager.stat_manager_ready.connect(initialize_stat_mod_manager)
	#pass
	#
#func initialize_stat_mod_manager():
	#for mod : StatMod in get_children():
		#mods.append(mod)
		#apply_mod_to_stat(stat_manager.stats[mod.stat_to_modify], mod)
	#pass
	#
#func apply_mod_to_stat(stat : Stat, mod : StatMod):
	#stat.bonus_value += mod.final_mod_value
	#stat.mods.append(mod)
	#stat.update_stat()
	#pass
#
#func remove_mod_from_stat(stat : Stat, mod : StatMod):
	#if stat.mods.has(mod):
		#stat.bonus_value -= mod.final_mod_value
		#stat.mods.erase(mod)
		#stat.update_stat()
	#pass
