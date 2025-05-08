class_name LifestealEffect
extends Effect


@export var heal_stat : Stat
@export var damage_effect : DamageEffect
@export var lifesteal_stat : Stat
@export var heal_type : Enums.DamageType

func _ready():
	pass


func apply_effect(hit_data : Dictionary):
	var target = hit_data.get("target")
	var reduction : float
	if target is Entity:
		if heal_type == Enums.DamageType.PHYSICAL:
			#reduction = target.damage_listener.calculate_post_mitigated_damage(hit_data);
			pass
		elif heal_type == Enums.DamageType.MAGIC:
			#reduction == target.stat_manager.get_stat("magic").stat_derived_value
			pass
		pass

	
	pass

func lifesteal(hit_data: Dictionary, heal_flat : float, reduction : float):
	var actor = hit_data.get("actor")
	if actor.is_in_group("Hittable"):
		actor.heal(_create_heal_data(hit_data, heal_stat.stat_derived_value * lifesteal_stat.stat_derived_value))
		pass
	pass

func _create_damage_data(hit_data : Dictionary, damage : float):
	var damage_data : Dictionary
	damage_data["source"] = hit_data.get("source")
	damage_data["damage"] =  damage
	damage_data["type"] = damage_effect.damage_type
	return damage_data
	pass

func _create_heal_data(hit_data : Dictionary, heal_amount : float):
	var heal_data : Dictionary
	heal_data["source"] = hit_data.get("source")
	heal_data["heal_amount"] = heal_amount 
	heal_data["type"] = heal_type 
	return heal_data
	pass
