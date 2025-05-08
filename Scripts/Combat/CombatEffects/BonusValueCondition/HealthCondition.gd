class_name HealthCondition
extends BonusValueCondition

@export var required_health : float = 1
@export var below : bool = false

func _init(required_health : float, bonus_value : float, below : bool):
	self.required_health = required_health
	self.bonus_value = bonus_value
	self.below = below
	pass

func condition_met(hit_data : Dictionary) -> bool:
	var target : Entity
	if hit_data.get("target") is Entity:
		target = hit_data.get("target")
	
	if target != null:
		var current_health : float =  target.stat_manager.get_stat("current_health").stat_derived_value
		var max_health : float = target.stat_manager.get_stat("max_health").stat_derived_value
		if below:
			if current_health < (max_health * required_health):
				return true
		else:
			if current_health >= (max_health * required_health):
				return true
	return false

func get_bonus_value() -> float:
	return bonus_value

func calculate_bonus_value(damage_data : Dictionary) -> float:
	return bonus_value

func _to_string():
	return "HealthCondition"
