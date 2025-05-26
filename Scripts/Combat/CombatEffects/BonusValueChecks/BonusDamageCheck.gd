class_name BonusDamageCheck
extends EffectCheck


@export var bonus_damage_stat : Stat
@export var scaling_ratio : float = 1

func generate_bonus_value_condition() -> BonusValueCondition:
	return BonusValueCondition.new(get_bonus_value(),is_multiplier)

func get_bonus_value() -> float:
	return bonus_damage_stat.stat_derived_value * scaling_ratio
	pass
