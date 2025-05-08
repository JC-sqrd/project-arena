class_name OnHitIPE
extends ItemPassiveEffect

@export var trigger_chance : float = 1

func _ready():
	super()
	if owner is Item:
		owner.item_equipped.connect(
			func():
			owner.actor.trigger_on_hit_effect.connect(on_trigger_on_hit_effect)	
		)
		
	pass

func apply_passive_effect(actor : Entity):
	
	pass

func on_trigger_on_hit_effect(hit_data : Dictionary):
	if trigger_chance >= randf_range(0, 1):
		for effect in effects:
			effect.apply_effect(hit_data)
	pass
