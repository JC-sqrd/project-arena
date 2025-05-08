class_name OnHitReceiver
extends EffectReceiver



func receive_effect(data : Dictionary):
	var on_hit_chance : float = 0
	if data.has("on_hit_effect"):
		on_hit_chance = data["on_hit_effect"]
		if on_hit_chance >= randf_range(0, 1):
			if data.has("actor"):
				var actor : Entity = data["actor"] as Entity
				actor.trigger_on_hit_effect.emit(data)
	pass
