class_name OnHitEffect
extends Effect


@export var on_hit_chance : float = 1

func apply_effect(hit_data : Dictionary):
	var actor : Entity = hit_data["actor"]
	if on_hit_chance >= randf_range(0, 1):
		actor.trigger_on_hit_effect.emit(hit_data)
	pass

func get_effect_key() -> Variant:
	return "on_hit_effect"

func get_effect_value() -> Variant:
	return on_hit_chance
