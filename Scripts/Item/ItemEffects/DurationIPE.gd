class_name DurationIPE
extends ItemPassiveEffect


@export var cooldown : Stat


func apply_passive_effect(actor : Entity):
	pass


func on_cooldown_end(hit_data : Dictionary):
	for effect in effects:
		effect.apply_effect(hit_data)
