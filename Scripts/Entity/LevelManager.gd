class_name LevelManager
extends Node

@export var level_stat : Stat
var current_level : int = 1
var current_exp : float = 0
var exp_to_level : float
var total_exp : float = 0

var exps_per_level : Array[float] = [
	100.0, #lvl 2
	150.0, #lvl 3
	200.0, #lvl 4
	250.0, #lvl 5
	300.0, #lvl 6
	350.0, #lvl 7
	400.0, #lvl 8
	450.0, #lvl 9
	500.0, #lvl 10
	550.0, #lvl 11
	600.0, #12
	650.0, #13
	700.0, #14
	750.0, #15
	800.0, #16
	850.0, #17
	900.0, #18
	950.0, #19
	1000.0, #20 
	1050.0, #21
	1100.0, #22
	1150.0, #23
	1200.0, #24
	1250.0, #25
	1300.0, #26
	1350.0, #27
	1400.0, #28
	1450.0, #29
	1500.0, #30
	1550.0, #31
	1600.0, #32
]
var level_index : int = 0


signal level_manager_ready()
signal exp_gained (exp_value : float)
signal exp_evaluated
signal level_up_with_new_level (new_level : int)
signal leveled_up

func _ready():
	exp_gained.connect(_on_exp_changed)
	if level_stat.stat_value <= 0:
		level_stat.stat_value = 0
	level_manager_ready.emit()
	exp_to_level = exps_per_level[0]
	pass

func add_exp(exp : float):
	current_exp += exp
	total_exp += exp
	exp_gained.emit(exp)
	pass

func _on_exp_changed(exp_value : float):
	if current_exp >= exp_to_level:
		level_up()
	exp_evaluated.emit()
	pass

func add_level(levels : int):
	var current_level_index : int = level_stat.stat_derived_value - 1
	var exp_to_add : float
	if levels > 0:
		while levels > 0:
			exp_to_add += exps_per_level[current_level_index]
			current_level_index += 1
			levels -= 1
			pass
	else:
		pass
	add_exp(exp_to_add)
	pass

func level_up():
	while current_exp >= exp_to_level:
		if current_level <= exps_per_level.size():
			current_exp -= exp_to_level
			#leveled_up.emit()
			#level_up_with_new_level.emit(current_level)
			#if current_level <= exps_per_level.size():
			exp_to_level = exps_per_level[current_level - 1]
			current_level += 1
			level_stat.stat_value = float(current_level)
			leveled_up.emit()
			level_up_with_new_level.emit(current_level)
		else:
			current_exp = exps_per_level[exps_per_level.size() - 1]
			break
	pass
