class_name HealReceiver
extends EffectReceiver



func receive_effect(hit_data : Dictionary):
	if hit_data.has("heal_effect"):
		var heal_data : HealEffect.HealEffectData = hit_data["heal_effect"] as HealEffect.HealEffectData
		heal_data.apply_effect(hit_data)
	pass
