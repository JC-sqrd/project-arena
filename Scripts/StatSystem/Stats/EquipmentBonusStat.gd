class_name EquipmentBonusStat
extends Node

@onready var node : Node = owner
@export var equipment : Equipment
@export var stat_name : String : set = _set_stat_name
@export var bonus_value : Stat
@export var percentage : bool = false : set = _set_percentage
@export var scale_with_stack : bool = false
var stat : Stat
var item_stack : float = 1

var actor : Entity

var _old_bonus_value : float = 0

func _ready():
	equipment.equipped.connect(apply_bonus_value)
	equipment.unequipped.connect(remove_bonus_value)
	await equipment.ready
	actor = equipment.actor
	pass

func apply_bonus_value(actor : Entity):
	if equipment != null:
		actor = equipment.actor
	if actor != null:
		if actor.stat_manager.stats.has(stat_name):
			stat = actor.stat_manager.stats[stat_name]
			if !percentage:
				stat.bonus_value -= _old_bonus_value
				if scale_with_stack:
					stat.bonus_value += bonus_value.stat_derived_value 
					_old_bonus_value = bonus_value.stat_derived_value
				else:
					stat.bonus_value += bonus_value.stat_derived_value
					_old_bonus_value = bonus_value.stat_derived_value
				stat.update_stat()
			elif percentage:
				stat.bonus_value -= _old_bonus_value
				if scale_with_stack:
					stat.bonus_value += stat.stat_value * (bonus_value.stat_derived_value)
					_old_bonus_value = stat.stat_value * (bonus_value.stat_derived_value)
				else:
					stat.bonus_value += stat.stat_value * bonus_value.stat_derived_value
					_old_bonus_value = stat.stat_value * bonus_value.stat_derived_value
				stat.update_stat()
	pass

func remove_bonus_value():
	if equipment != null:
		actor = equipment.actor
	if actor != null:
		if actor.stat_manager.stats.has(stat_name):
			stat = actor.stat_manager.stats[stat_name]
			if !percentage:
				stat.bonus_value -= _old_bonus_value
				stat.update_stat()
			elif percentage:
				stat.bonus_value -= _old_bonus_value
				stat.update_stat()
		_old_bonus_value = 0
	print("BONUS STAT REMOVED FROM: " + str(actor))
	pass


func _set_stat_name(new_value : String):
	remove_bonus_value()
	stat_name = new_value
	apply_bonus_value(actor)
	pass

func _set_percentage(new_value : bool):
	remove_bonus_value()
	percentage = new_value
	apply_bonus_value(actor)
	pass

func _on_item_ready():
	apply_bonus_value(actor)
	pass

func get_item_owner() -> Item:
	if owner is Item:
		return owner
	else:
		return null
	pass
