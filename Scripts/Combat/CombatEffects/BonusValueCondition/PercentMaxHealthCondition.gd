class_name PercentMaxHealthCondition
extends BonusValueCondition


var percentage : float = 0
var _target_max_health : float = 0

func _init(percentage : float):
	self.percentage = percentage

func condition_met(hit_data : Dictionary) -> bool:
	if hit_data["target"].stat_manager.stats.has("max_health"):
		_target_max_health = hit_data["target"].stat_manager.stats["max_health"].stat_derived_value
	return true


func get_bonus_value() -> float:
	return percentage * _target_max_health

func calculate_bonus_value(damage_data : Dictionary) -> float:
	return percentage * _target_max_health

func _to_string():
	return "PercentMaxHealthCondition"
