class_name OnCritIPE
extends ItemPassiveEffect

@export var trigger_chance : float = 1

func _ready():
	super()
	if owner is Item:
		item = owner
		owner.item_equipped.connect(
			func():
			owner.actor.critical_striked.connect(on_critical_striked)	
		)
	pass

func apply_passive_effect(actor : Entity):
	
	pass

func on_critical_striked(hit_data : Dictionary):
	if trigger_chance >= randf_range(0, 1):
		hit_data["stack"] = item.stack
		for effect in effects:
			effect.apply_effect(hit_data)
	pass
