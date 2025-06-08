class_name DamageListener
extends Node

@export var health : Stat
@export var health_manager : HealthManager
var mitigation_effects : Array[MitigationEffect]
var modifiers : Array[MitigationModifier]

var post_mitigated_damage : float

var damage_multiplier : float = 1
var damage_multiplier_bonus : float = 0
var damage_multiplier_scalar : float = 1

var block_incoming_damage : bool = false

signal damage_applied()
signal damage_blocked()
signal damage_dodged()
signal incoming_damage(damage_data : DamageEffectData)

func _ready():
	child_entered_tree.connect(
		func(node : Node):
			if node is MitigationEffect:
				mitigation_effects.append(node)
			elif node is MitigationModifier:
				modifiers.append(node)
			pass
	)
	for child in get_children():
		if child is MitigationEffect:
			mitigation_effects.append(child)
		elif child is MitigationModifier:
			modifiers.append(child)
	pass

#func apply_mitigation_effects(damage_data : Dictionary) -> float:
	#var post_mitigated_damage : float = calculate_post_mitigated_damage(damage_data) * calculate_damage_multiplier()
	#apply_modifiers(damage_data)
	#reset_damage_multiplier()
	#if damage_data["damage_type"] as Enums.DamageType != Enums.DamageType.TRUE and (damage_data.has("blocked") and damage_data["blocked"] as bool):
		#damage_blocked.emit()
		#return 0
	#damage_data["blocked"] = false
	#damage_data["damage"] = floorf(post_mitigated_damage)
	#return _apply_damage(damage_data)

func apply_mitigation_effects(damage_data : DamageEffectData) -> float:
	incoming_damage.emit(damage_data)
	var post_mitigated_damage : float = calculate_post_mitigated_damage(damage_data) * calculate_damage_multiplier()
	apply_modifiers(damage_data)
	reset_damage_multiplier()
	if damage_data.damage_type != Enums.DamageType.TRUE and damage_data.dodged:
		#damage_blocked.emit()
		damage_dodged.emit()
		return 0
	damage_data["blocked"] = false
	damage_data["damage"] = floorf(post_mitigated_damage)
	return _apply_damage(damage_data)

#func calculate_post_mitigated_damage(damage_data : Dictionary) -> float:
	#var post_mitigated_damage = damage_data["damage"]
	#var source : Node = damage_data["source"]
	#var type : Enums.DamageType = damage_data["damage_type"]
	#var mitigation_percentage : float = 0
	#var mitigation : float = 0
	#for mitigation_effect in mitigation_effects:
		#mitigation_percentage = mitigation_effect.calculate_mitigation_percentage(damage_data)
		## ** for debug purposes
		#mitigation += mitigation_effect.calculate_mitigation_percentage(damage_data)
		#post_mitigated_damage *= mitigation_percentage
	#if damage_data.has("critical"):
		#if damage_data["critical"] == true:
			#return post_mitigated_damage * 2
	#return post_mitigated_damage
	#pass

func calculate_post_mitigated_damage(damage_data : DamageEffectData) -> float:
	var post_mitigated_damage = damage_data.damage
	var source : Node = damage_data.source
	var type : Enums.DamageType = damage_data.damage_type
	var mitigation_percentage : float = 0
	var mitigation : float = 0
	for mitigation_effect in mitigation_effects:
		mitigation_percentage = mitigation_effect.calculate_mitigation_percentage(damage_data)
		# ** for debug purposes
		mitigation += mitigation_effect.calculate_mitigation_percentage(damage_data)
		post_mitigated_damage *= mitigation_percentage
	if damage_data.critical:
		return post_mitigated_damage * damage_data.crit_multiplier
	return post_mitigated_damage
	pass

func apply_mitiagation_multiplier() -> float:
	return 1

func apply_modifiers(damage_data : DamageEffectData):
	for modifier in modifiers:
		modifier.apply_modifier(damage_data)
	pass
#func apply_modifiers(damage_data : Dictionary):
	#for modifier in modifiers:
		#modifier.apply_modifier(damage_data)
	#pass

func calculate_damage_multiplier() -> float:
	apply_mitiagation_multiplier()
	return (damage_multiplier + damage_multiplier_bonus) * damage_multiplier_scalar

func reset_damage_multiplier():
	damage_multiplier_bonus = 0
	damage_multiplier_scalar = 1
	pass

func _apply_damage(damage_data : DamageEffectData) -> float:
	var damage : float = damage_data.damage
	#if (health.stat_derived_value - damage) <= 0:
		#var leftover_health = health.stat_derived_value
		#health.stat_derived_value -= leftover_health
		#damage = leftover_health
	#else:
		#health.stat_derived_value -= damage
	#
	#if health.stat_derived_value <= 0:
		#(damage_data.target).slain.emit(damage_data.actor)
		#if damage_data.actor != null:
			#(damage_data.actor).slayed.emit(damage_data.target)
		#(damage_data.target).die()
	#damage_applied.emit()
	#return damage
	
	#-----------------------------------
	
	
	if (health_manager.current_health.stat_derived_value - damage) <= 0:
		var leftover_health = health_manager.current_health.stat_derived_value
		health_manager.remove_current_health(leftover_health)
		damage = leftover_health
	else:
		health_manager.remove_current_health(damage)
	
	if health_manager.current_health.stat_derived_value <= 0:
		(damage_data.target).slain.emit(damage_data.actor)
		if damage_data.actor != null:
			(damage_data.actor).slayed.emit(damage_data.target)
		(damage_data.target).die()
	damage_applied.emit()
	return damage
	pass

#func _apply_damage(damage_data : Dictionary) -> float:
	#var damage = damage_data.get("damage")
	#if (health.stat_derived_value - damage) <= 0:
		#var leftover_health = health.stat_derived_value
		#health.stat_derived_value -= leftover_health
		#damage = leftover_health
	#else:
		#health.stat_derived_value -= damage
	#
	#if health.stat_derived_value <= 0:
		#(damage_data["target"] as Entity).slain.emit(damage_data["actor"])
		#if damage_data["actor"] != null:
			#(damage_data["actor"] as Entity).slayed.emit(damage_data["target"])
		#(damage_data["target"] as Entity).die()
	#damage_applied.emit()
	#return damage
	#pass
