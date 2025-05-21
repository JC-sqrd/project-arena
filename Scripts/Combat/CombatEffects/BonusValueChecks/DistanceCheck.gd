class_name DistanceCheck
extends EffectCheck

@export var stat : Stat
@export var scaling_ratio : float = 1
@export var distance : float = 100
@export var relative_to_actor : bool = true
@export var greater_than : bool = false
var target_distance : float = 0


func on_effect_data_generated(effect : Effect):
	
	pass

func generate_bonus_value_condition() -> BonusValueCondition:
	var distance_condition : DistanceCondition = DistanceCondition.new(distance, get_bonus_value(), relative_to_actor, greater_than, is_multiplier)
	return distance_condition

func get_bonus_value():
	return stat.stat_derived_value * scaling_ratio
	pass
