class_name ApplyStatusEffectReceiver
extends EffectReceiver

func receive_effect(hit_data : Dictionary):
	if hit_data.has("apply_status_effect"):
		var effect_data : StatusEffectData = hit_data["apply_status_effect"]
		var status_effect : StatusEffect = effect_data.status_effect.duplicate()
		var target : Entity = hit_data["target"]
		status_effect.actor = hit_data["actor"]
		var random : float = randf_range(0, 1)
		if effect_data.chance >= random:
			target.status_effect_manager.add_status_effect(status_effect, effect_data.stack)
		pass
