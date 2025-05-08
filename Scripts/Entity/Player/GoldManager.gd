class_name GoldManager
extends Node


@export var gold : Stat

signal gold_gained (gained_value : float)

func add_gold(gold_to_add : float):
	gold.stat_value += gold_to_add
	gold_gained.emit(gold_to_add)
