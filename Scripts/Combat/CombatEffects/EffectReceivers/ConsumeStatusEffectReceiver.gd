class_name ConsumeStatusEffectReceiver
extends EffectReceiver


func receive_effect(hit_data : Dictionary):
	if hit_data.has("consume_status_effect"):
		var target : Entity = hit_data["target"] as Entity
		var effect_data : ConsumeStatusEffect.ConsumeStatusEffectData = hit_data["consume_status_effect"] as ConsumeStatusEffect.ConsumeStatusEffectData
		if target.status_effect_manager.has_status_effect_id(effect_data.status_effect_id):
			target.on_hit.emit(_create_hit_data(hit_data, effect_data.effect_data))
			target.status_effect_manager.remove_status_effect_by_id(effect_data.status_effect_id)
			pass
		pass


func _create_hit_data(hit_data : Dictionary, effect_data : Dictionary) -> Dictionary:
	effect_data["target"] = hit_data["target"]
	effect_data["source"] = hit_data["source"]
	effect_data["actor"] = hit_data["actor"]
	return effect_data
