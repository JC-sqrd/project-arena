class_name PercentMaxHealthCheck
extends EffectCheck

@export var percentage_stat : Stat
@export var scaling_ratio : float = 1

var _target_max_health : float

func generate_bonus_value_condition() -> BonusValueCondition: 
	return PercentMaxHealthCondition.new(get_bonus_value())

func get_bonus_value() -> float:
	return percentage_stat.stat_derived_value * scaling_ratio
