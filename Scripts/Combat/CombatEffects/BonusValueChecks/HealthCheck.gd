class_name HealthCheck
extends EffectCheck

@export var bonus_stat : Stat
@export var required_health : float = 1
@export var scaling_ratio : float = 1
@export var below : bool = false

func generate_bonus_value_condition() -> BonusValueCondition:
	return HealthCondition.new(required_health, get_bonus_value(), below)

func get_bonus_value() -> float:
	return bonus_stat.stat_derived_value * scaling_ratio
	pass
