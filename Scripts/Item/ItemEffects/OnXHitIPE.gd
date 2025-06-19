class_name OnXHitIPE
extends ItemPassiveEffect

@export var hit_requirement : int = 1

var hit_counter : int = 0

func _ready():
	super()
	if owner is Item:
		item = owner
		owner.item_equipped.connect(
			func():
			owner.actor.trigger_on_hit_effect.connect(on_trigger_on_hit_effect)
			owner.actor.basic_attack_hit.connect(on_basic_attack)
		)
		
	pass

func apply_passive_effect(actor : Entity):
	
	pass

func on_trigger_on_hit_effect(hit_data : Dictionary):
	
	pass

func on_basic_attack(hit_data : Dictionary):
	hit_counter += 1
	print("BASIC ATTACK HIT!! " + str(hit_counter))
	hit_data["stack"] = item.stack
	if hit_counter >= hit_requirement:
		hit_counter = 0
		for effect in effects:
			effect.apply_effect(hit_data)
		pass
	pass
