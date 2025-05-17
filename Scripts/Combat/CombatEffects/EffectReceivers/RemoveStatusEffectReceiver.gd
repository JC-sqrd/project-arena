class_name RemoveStatusEffectReceiver
extends EffectReceiver

func receive_effect(hit_data : Dictionary):
	if hit_data.has("remove_status_effect"):
		var effect_data : StatusEffectData = hit_data["remove_status_effect"]
		var status_effect : StatusEffect = effect_data.status_effect
		var target : Entity = hit_data["target"]
		status_effect.actor = hit_data["actor"]
		target.status_effect_manager.remove_status_effect_by_id(status_effect.id)
		pass
