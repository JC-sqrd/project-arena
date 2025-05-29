class_name DamageEffect
extends Effect

@export var damage_stat : Stat
@export var penetration_stat : Stat : get = _get_penetration_stat
@export var crit_chance_stat : Stat
@export var scaling_ratio : float = 1
@export var damage_type : Enums.DamageType
@export var health_percent_damage : bool = false
## Flag for lifesteal
@export var can_lifesteal : bool = true
@export var lifesteal_stat : Stat
@export var lifesteal_type : Enums.DamageType 
var bonus_damage_checks : Array[EffectCheck]

var total_damage : float = 0
var bonus_damage : float = 0
var bonus_multiplier : float = 1

signal damage_data_created (damage_data : DamageEffectData)
signal damage_effect_received (damage_data : Dictionary)
signal bonus_damage_calculated (damage_effect : DamageEffect)
signal applied_damage(damage : float)
signal applied_damage_with_data (damaga_data : float)

#var damage_effect_data : DamageEffectData 

func _ready():
	super()
	for child in get_children():
		if child is EffectCheck:
			bonus_damage_checks.append(child)
	#damage_effect_data = DamageEffectData.new()
	pass

func get_effect_key() -> Variant:
	return "damage_effect"

func get_effect_value() -> Variant:
	#var damage_data : Dictionary
	#damage_data["damage"] = damage_stat.stat_derived_value
	#damage_data["total_damage"] = damage_stat.stat_derived_value
	#var penetrates : bool = false
	#var critical : bool = false
	#if penetration_stat != null:
		#penetrates = true
		#damage_data["penetration"] = penetration_stat.stat_derived_value
	#if crit_chance_stat != null:
		#if crit_chance_stat.stat_derived_value >= randf_range(0, 1):
			#damage_data["critical"] = true
			#critical = true
		#else:
			#damage_data["critical"] = false
	#damage_data["damage_type"] = damage_type
	#if lifesteal:
		#damage_data["lifesteal"] = DamageReceiver.Lifesteal.new(lifesteal_stat.stat_derived_value, lifesteal_type)
		#pass
	#
	var checks : Array[BonusValueCondition]
	for check in bonus_damage_checks:
		checks.append(check.generate_bonus_value_condition())
	#damage_data["checks"] = checks
	#damage_data_created.emit(damage_data)
	#damage_data["damage_received_callback"] = on_damage_received
	
	#---------------------------------------------------------------------------------
	
	var damage_effect_data : DamageEffectData = DamageEffectData.new()
	damage_effect_data.damage = damage_stat.stat_derived_value
	damage_effect_data.total_damage = damage_stat.stat_derived_value
	damage_effect_data.blocked = false
	if penetration_stat != null:
		damage_effect_data.penetrates = false
		damage_effect_data.penetration = penetration_stat.stat_derived_value
	if crit_chance_stat != null:
		if crit_chance_stat.stat_derived_value >= randf_range(0, 1):
			damage_effect_data.critical = true
		else:
			damage_effect_data.critical = false
	damage_effect_data.damage_type = damage_type
	damage_effect_data.is_lifesteal = (can_lifesteal)
	if can_lifesteal and lifesteal_stat != null:
		damage_effect_data.lifesteal_percentage = lifesteal_stat.stat_derived_value
		#damage_effect_data.lifesteal = (DamageReceiver.Lifesteal.new(lifesteal_stat.stat_derived_value, lifesteal_type))
	damage_effect_data.checks = (checks)
	
	damage_data_created.emit(damage_effect_data) 
	#actor.damage_data_created.emit(damage_effect_data)
	actor.effect_data_created.emit(damage_effect_data)
	return damage_effect_data

func on_damage_received(damage_data : Dictionary):
	damage_effect_received.emit(damage_data)


#func apply_effect(hit_data : Dictionary):
	#var target : Entity = hit_data.get("target")
	##var actor : Entity = hit_data.get("actor")
	#var mitigated_damage : float
	#var damage_data : Dictionary
	#
	#total_damage = calculate_total_final_damage(hit_data) * calculate_total_bonus_multiplier(hit_data)
	#
#
	#if target.is_in_group("Hittable"):
		#damage_data = _create_damage_data(hit_data, total_damage)
		#mitigated_damage = target.take_damage(damage_data)
		#damage_data["damage"] = mitigated_damage
		#bonus_damage = 0
		#bonus_multiplier = 1
		#applied_damage.emit(mitigated_damage)
		#applied_damage_with_data.emit(damage_data)
		#
		#if hit_data["actor"] != null:
			#var actor : Entity = hit_data.get("actor")
			#actor.applied_damage.emit(mitigated_damage)
			#damage_data.merge(hit_data, true)
			#if damage_data.has("critical"): actor.critical_striked.emit(damage_data)
			#actor.applied_damage_with_data.emit(damage_data)
			#pass
	#
	#if lifesteal and hit_data.has("actor"):
		#var actor : Entity = hit_data.get("actor")
		#if actor.is_in_group("Hittable"):
			#actor.heal(_create_heal_data(hit_data, mitigated_damage * lifesteal_stat.stat_derived_value))
		#pass
	#pass

func calculate_total_bonus_damage(hit_data : Dictionary) -> float:
	var temp_bonus_damage : float = 0
	for check in bonus_damage_checks:
		if !check.is_multiplier and check.requirement_met(hit_data):
			temp_bonus_damage += check.get_bonus_value()
	bonus_damage_calculated.emit(self)
	return temp_bonus_damage + bonus_damage

func calculate_total_bonus_multiplier(hit_data : Dictionary) -> float:
	var mulitplier : float = 1
	for check in bonus_damage_checks:
		if check.is_multiplier == true and check.requirement_met(hit_data):
			bonus_multiplier += check.get_bonus_value()
	return bonus_multiplier

func calculate_total_final_damage(hit_data : Dictionary) -> float:
	return (damage_stat.stat_derived_value * scaling_ratio) + calculate_total_bonus_damage(hit_data)

func _create_damage_data(hit_data : Dictionary, damage : float):
	var damage_data : Dictionary
	damage_data["source"] = hit_data.get("source")
	damage_data["damage"] =  damage
	damage_data["type"] = damage_type
	if penetration_stat != null:
		damage_data["penetration"] = penetration_stat.stat_derived_value
		pass
	if crit_chance_stat != null:
		if crit_chance_stat.stat_derived_value >= randf_range(0, 1):
			damage_data["critical"] = true
	damage_data_created.emit(damage_data)
	return damage_data

func _create_heal_data(hit_data : Dictionary, heal_amount : float):
	var heal_data : Dictionary
	heal_data["source"] = hit_data.get("source")
	heal_data["heal_amount"] = heal_amount 
	heal_data["type"] = lifesteal_type 
	return heal_data

func _get_penetration_stat() -> Stat:
		return penetration_stat

func update_conditions():
	pass
