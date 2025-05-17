class_name MitigationEffect
extends Node

enum MitigationType {ARMOR, MAGIC_RESIST}


@export var mitigate_stat : Stat
@export var mitigation_type : MitigationType = MitigationType.ARMOR

func calculate_mitigation_percentage(damage_data : DamageEffectData) -> float:
	var source = damage_data.source#damage_data["source"]
	var damage = damage_data.damage#damage_data["damage"]
	var type = damage_data.damage_type#damage_data["damage_type"]
	var penetration : float = 0
	if damage_data.penetrates:
		penetration = damage_data["penetration"]
		pass
	if type == Enums.DamageType.PHYSICAL and mitigation_type == MitigationType.ARMOR:
		return (100 / (100 + (mitigate_stat.stat_derived_value * (1 - penetration))))
		pass
	elif type == Enums.DamageType.MAGIC and mitigation_type == MitigationType.MAGIC_RESIST:
		return (100 / (100 + (mitigate_stat.stat_derived_value * (1 - penetration))))
		pass
	elif type == Enums.DamageType.TRUE:
		return 1
	return 1
	pass

#func calculate_mitigation_percentage(damage_data : Dictionary) -> float:
	#var source = damage_data["source"]
	#var damage = damage_data["damage"]
	#var type = damage_data["damage_type"]
	#var penetration : float = 0
	#if damage_data.has("penetration"):
		#penetration = damage_data["penetration"]
		#pass
	#if type == Enums.DamageType.PHYSICAL and mitigation_type == MitigationType.ARMOR:
		#return (100 / (100 + (mitigate_stat.stat_derived_value * (1 - penetration))))
		#pass
	#elif type == Enums.DamageType.MAGIC and mitigation_type == MitigationType.MAGIC_RESIST:
		#return (100 / (100 + (mitigate_stat.stat_derived_value * (1 - penetration))))
		#pass
	#elif type == Enums.DamageType.TRUE:
		#return 1
	#return 1
	#pass
