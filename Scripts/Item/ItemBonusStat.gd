class_name ItemBonusStat
extends Node

@onready var item : Item = get_item_owner()
@export var stat_name : String : set = _set_stat_name
@export var bonus_value : Stat
@export var percentage : bool = false : set = _set_percentage
@export var scale_with_stack : bool = false
var stat : Stat
var item_stack : float = 1

var _old_bonus_value : float = 0

func _ready():
	item.item_equipped.connect(_on_item_ready)
	item.item_equipped.connect(apply_bonus_value)
	if scale_with_stack:
		item.stack_changed.connect(apply_bonus_value)
	item.item_unequipped.connect(remove_bonus_value)
	bonus_value.stat_derived_value_changed.connect(apply_bonus_value)
	apply_bonus_value()
	#item.actor.stat_manager.stat_manager_ready.connect(_on_stat_manager_ready)
	pass

func apply_bonus_value():
	if item != null:
		if item.actor.stat_manager.stats.has(stat_name):
			stat = item.actor.stat_manager.stats[stat_name]
			if !percentage:
				stat.bonus_value -= _old_bonus_value
				if scale_with_stack:
					stat.bonus_value += bonus_value.stat_derived_value * item.stack
					_old_bonus_value = bonus_value.stat_derived_value * item.stack
				else:
					stat.bonus_value += bonus_value.stat_derived_value
					_old_bonus_value = bonus_value.stat_derived_value
				item_stack = item.stack
				stat.update_stat()
			elif percentage:
				stat.bonus_value -= _old_bonus_value
				if scale_with_stack:
					stat.bonus_value += stat.stat_value * (bonus_value.stat_derived_value * item.stack)
					_old_bonus_value = stat.stat_value * (bonus_value.stat_derived_value * item.stack)
				else:
					stat.bonus_value += stat.stat_value * bonus_value.stat_derived_value
					_old_bonus_value = stat.stat_value * bonus_value.stat_derived_value
				item_stack = item.stack
				stat.update_stat()
	pass

func remove_bonus_value():
	if item != null:
		if item.actor.stat_manager.stats.has(stat_name):
			stat = item.actor.stat_manager.stats[stat_name]
			if !percentage:
				stat.bonus_value -= _old_bonus_value
				stat.update_stat()
			elif percentage:
				stat.bonus_value -= _old_bonus_value
				stat.update_stat()
		_old_bonus_value = 0
	pass

func _set_bonus_value(new_value : float):
	remove_bonus_value()
	bonus_value.stat_derived_value = new_value
	apply_bonus_value()
	pass

func _set_stat_name(new_value : String):
	remove_bonus_value()
	stat_name = new_value
	apply_bonus_value()
	pass

func _set_percentage(new_value : bool):
	remove_bonus_value()
	percentage = new_value
	apply_bonus_value()
	pass

func _on_item_ready():
	apply_bonus_value()
	pass

func get_item_owner() -> Item:
	if owner is Item:
		return owner
	else:
		return null
	pass
