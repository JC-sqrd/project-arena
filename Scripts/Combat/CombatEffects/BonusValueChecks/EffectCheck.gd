class_name EffectCheck
extends Node

@export var id : String
@export var is_multiplier : bool = false


func generate_bonus_value_condition() -> BonusValueCondition:
	return null

func get_bonus_value() -> float:
	return 0
	pass
