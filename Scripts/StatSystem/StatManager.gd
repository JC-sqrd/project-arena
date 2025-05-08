extends Node

class_name StatManager

@export var stats : Dictionary

var stat_mod_manager : StatModManager

signal stat_manager_ready()

func _ready():
	populate_stats()
	stat_manager_ready.emit()

func get_stat(stat_key : String) -> Stat:
	if stats.has(stat_key):
		return stats[stat_key]
	else:
		return null

func populate_stats():
	for stat : Stat in get_children():
		stats[stat.stat_name] = stat
	pass
#func add_mod_to_stat():
	#pass
	#
#func remove_mod_from_stat():
	#pass
