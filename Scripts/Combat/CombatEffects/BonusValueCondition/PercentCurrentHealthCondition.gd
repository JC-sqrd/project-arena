class_name PercentCurrentHealthCondition
extends BonusValueCondition

var percentage : float = 0
var _target_current_health : float

func _init(percentage : float):
	self.percentage = percentage

func condition_met(hit_data : Dictionary) -> bool:
	if hit_data["target"].stat_manager.stats.has("current_health"):
		_target_current_health = hit_data["target"].stat_manager.stats["current_health"].stat_derived_value
	return true


func get_bonus_value() -> float:
	return percentage * _target_current_health

func calculaate_bonus_value(damage_data : DamageEffectData) -> float:
	return percentage * _target_current_health

func _to_string():
	return "PercentCurrentHealthCondition"
