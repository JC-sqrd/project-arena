class_name BonusValueCondition
extends RefCounted


var bonus_value : float = 0

func _init(bonus_value : float):
	self.bonus_value = bonus_value

func condition_met(hit_data : Dictionary) -> bool:
	return true


func get_bonus_value() -> float:
	return bonus_value

func calculate_bonus_value(damage_data : Dictionary) -> float:
	return bonus_value
