class_name DodgeModifier
extends MitigationModifier


@export var dodge_chance : Stat 

func apply_modifier(damage_data : DamageEffectData):
	if dodge_chance.stat_derived_value >= randf_range(0, 1):
		damage_data.dodged = true
	pass

#func apply_modifier(damage_data : Dictionary):
	#if block_chance >= randf_range(0, 1):
		#damage_data["blocked"] = true
	#pass
