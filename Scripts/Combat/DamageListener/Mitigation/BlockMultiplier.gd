class_name BlockModifier
extends MitigationModifier


@export var block_chance : float = 0

func apply_modifier(damage_data : Dictionary):
	if block_chance >= randf_range(0, 1):
		damage_data["blocked"] = true
	pass
