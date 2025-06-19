class_name ModifyEquipmentStat
extends EquipmentTierModification

enum ModifyMode {SET, ADD, REMOVE}

@export var stat : Stat
@export var new_stat_value : float = 0
@export var mode : ModifyMode = ModifyMode.SET
var old_stat_value : float = 0

func apply_modification(equipment : Equipment):
	old_stat_value = stat.stat_value
	if mode == 0:
		stat.stat_value = new_stat_value
	elif mode == 1:
		stat.stat_value += new_stat_value
	elif mode == 2:
		stat.stat_value -= new_stat_value
	pass

func remove_modification(equipment : Equipment):
	if mode == 0:
		stat.stat_value = old_stat_value
	elif mode == 1:
		stat.stat_value -= old_stat_value
	elif mode == 2:
		stat.stat_value += old_stat_value
	pass
