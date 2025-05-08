class_name DistanceCondition
extends BonusValueCondition

@export var distance : float = 0
@export var greater_than : bool = false
@export var relative_to_actor : bool = false
var is_percentage : bool = false
var target_distance : float = 0
var damage_curve : Curve


func _init(distance : float, bonus_value : float, damage_curve : Curve, relative_to_actor : bool, greater_than : bool):
	self.distance = distance
	self.bonus_value = bonus_value
	self.relative_to_actor = relative_to_actor
	self.greater_than = greater_than
	self.damage_curve = damage_curve
	pass

func condition_met(hit_data : Dictionary) -> bool:
	var target : Entity = hit_data.get("target")
	var relative_to : Node
	if relative_to_actor:
		relative_to = hit_data.get("actor")
	else :
		relative_to = hit_data.get("source")
	
	target_distance = (target.global_position - relative_to.global_position).length()
	if !greater_than:
		if target_distance <= distance:
			return true
	else:
		if target_distance >= distance:
			return true
	return false

func get_bonus_value() -> float:
	return bonus_value * damage_curve.sample(target_distance/distance)

func calculate_bonus_value(damage_data : Dictionary) -> float:
	if is_percentage:
		return (damage_data["damage"] as float) * bonus_value * damage_curve.sample(target_distance/distance)
	return bonus_value * damage_curve.sample(target_distance/distance)

func _to_string():
	return "DistanceCondition"#"DistanceCondition[distance:" + str(distance) + ", bonus_value: " + str(bonus_value) + ", relative_to_actor: " + str(relative_to_actor) + ", greater_than: " + str(greater_than) + "]"
