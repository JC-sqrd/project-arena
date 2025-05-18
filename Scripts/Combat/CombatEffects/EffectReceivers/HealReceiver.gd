class_name HealReceiver
extends EffectReceiver



func receive_effect(hit_data : Dictionary):
	if hit_data.has("heal_effect"):
		var heal_data : HealEffectData = hit_data["heal_effect"] as HealEffectData
		heal_data.apply_effect(hit_data)
	pass
