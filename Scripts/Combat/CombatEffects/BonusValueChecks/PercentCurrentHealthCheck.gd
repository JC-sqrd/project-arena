class_name PercentCurrentHealthCheck
extends EffectCheck

@export var percentage_stat : Stat
@export var scaling_ratio : float = 1


func generate_bonus_value_condition() -> BonusValueCondition: 
	return PercentCurrentHealthCondition.new(get_bonus_value())

func get_bonus_value() -> float:
	return percentage_stat.stat_derived_value * scaling_ratio
