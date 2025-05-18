class_name HealEffect
extends Effect

@export var heal_amount : Stat

func get_effect_key() -> Variant:
	return "heal_effect"

func get_effect_value() -> Variant:
	return HealEffectData.new(heal_amount.stat_derived_value)
